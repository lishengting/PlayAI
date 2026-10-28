#!/usr/bin/env bash
# 为 macOS 构建最小化 FFmpeg 共享库（进程内视频抽帧用，替代 mtmd 的子进程方案）。
# 动态链接是为满足 LGPL v2.1 第 6 条的「可替换机制」义务
# （见 docs/release/THIRD_PARTY_LICENSES.md 第二节）。
#
# 用法:
#   bash scripts/build_ffmpeg_macos.sh              # x86_64 + arm64 各编一次，合 universal
#   ARCHS=x86_64 bash scripts/build_ffmpeg_macos.sh # 只编单架构（快，本机调试用）
#   PLLM_FFMPEG_MACOS_BUILD=/path bash scripts/build_ffmpeg_macos.sh
#
# 产物: $HOME/pllm-ffmpeg-macos/lib/lib{avcodec,avformat,avutil,swscale,swresample}.<MAJOR>.dylib
#       （universal，实体文件，名字与库自身的 install_name 一致）
#
# 为什么分架构各编一次再 lipo
# --------------------------
# FFmpeg 的 configure 是**单一目标架构**的，没有 CMake 那种
# CMAKE_OSX_ARCHITECTURES 多架构机制，只能按架构各配一次、各编一次，最后 lipo 合并。
#
# 为什么必须 --install-name-dir=@rpath
# -----------------------------------
# FFmpeg 在 darwin 上的 SHFLAGS 是
#   -install_name,$(INSTALL_NAME_DIR)/$(SLIBNAME_WITH_MAJOR)
# 而 INSTALL_NAME_DIR 默认取 $SHLIBDIR——也就是**构建机上的绝对安装路径**。
# 不覆盖的话，libpllm_llama.dylib 会记录一条指向
# /Users/<某人>/pllm-ffmpeg-macos/... 的 LC_LOAD_DYLIB，发布到别人机器上直接
# dyld 报 "library not loaded"。写成 @rpath 后，由主可执行文件的
# LC_RPATH `@executable_path/../Frameworks` 解析到 app bundle 的 Frameworks/ 目录。
#
# 为什么这里不跟 Windows/Linux 一样加 --disable-inline-asm
# -------------------------------------------------------
# 那两个平台加它是为了不依赖 nasm/yasm 且避开各自的工具链问题；macOS 的 clang
# 内联汇编本身可用，关掉只会白丢 NEON/SSE 优化。x86 的外汇编（x86asm）仍按
# 本机是否装了 nasm 自动决定，见下面 detect。
set -euo pipefail

FFMPEG_VERSION="${FFMPEG_VERSION:-n7.1}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALL_DIR="${PLLM_FFMPEG_MACOS_BUILD:-$HOME/pllm-ffmpeg-macos}"
BUILD_TREE="${PLLM_FFMPEG_MACOS_TREE:-$HOME/pllm-ffmpeg-macos-tree}"
ARCHS="${ARCHS:-x86_64 arm64}"
DEPLOY_TARGET="${MACOSX_DEPLOYMENT_TARGET:-12.0}"
JOBS="${JOBS:-$(sysctl -n hw.ncpu 2>/dev/null || echo 4)}"
HOST_ARCH="$(uname -m)"

# ---- 源码目录 ----
# 优先用仓库内 vendored 的 native/src/ffmpeg（与 Windows/Linux 同版本，可复现性
# 与 LGPL 合规都依赖这一点）；判据用 configure 而不是 .git——vendored 源码是平铺
# 文件、没有 .git 目录，用 .git 判断会对着一份完整源码去 git clone 然后失败。
if [ -n "${PLLM_FFMPEG_SRC:-}" ]; then
  SRC_DIR="$PLLM_FFMPEG_SRC"
elif [ -f "$REPO_ROOT/native/src/ffmpeg/configure" ]; then
  SRC_DIR="$REPO_ROOT/native/src/ffmpeg"
else
  SRC_DIR="$HOME/pllm-ffmpeg-src"
fi

echo "==> 构建 FFmpeg $FFMPEG_VERSION（shared, minimal, universal）"
echo "    源码:     $SRC_DIR"
echo "    构建树:   $BUILD_TREE/<arch>（每架构一棵）"
echo "    安装到:   $INSTALL_DIR"
echo "    架构:     $ARCHS（主机 $HOST_ARCH）"
echo "    部署目标: macOS $DEPLOY_TARGET"
echo "    并行:     -j$JOBS"

# ---- 外汇编（x86asm）探测 ----
# x86_64 的 SIMD 汇编走 nasm/yasm；没有的话 FFmpeg 会退回纯 C 实现，h264/hevc
# 解码明显变慢（抽帧是低频操作，能跑但慢）。arm64 不需要——aarch64 的汇编由
# clang 直接汇编 .S，不依赖外部汇编器。
X86ASM_FLAG=""
if command -v nasm >/dev/null 2>&1 || command -v yasm >/dev/null 2>&1; then
  echo "    x86 汇编: 已找到 $(command -v nasm || command -v yasm)，x86_64 启用 x86asm"
else
  X86ASM_FLAG="--disable-x86asm"
  echo "    x86 汇编: 未找到 nasm/yasm，x86_64 退回纯 C（想提速：brew install nasm 后重跑）"
fi

# ---- 准备源码 ----
if [ ! -f "$SRC_DIR/configure" ]; then
  echo "==> 源码不存在，clone FFmpeg $FFMPEG_VERSION ..."
  git clone --depth 1 --branch "$FFMPEG_VERSION" \
    https://git.ffmpeg.org/ffmpeg.git "$SRC_DIR"
fi

# FFmpeg 的 configure/make 是**就地构建**，会往源码目录写大量产物。源码现在优先
# 取仓库内的 native/src/ffmpeg，就地编会把工作树弄脏（build_ffmpeg.sh 与
# build_ffmpeg_cygwin.sh 同样是先拷到临时树再编）。
#
# **每个架构一棵独立的树**，而不是一棵树编完 make distclean 再编下一个。
# distclean 依赖当次 ffbuild/config.mak 里的 OBJS 列表，只要漏删一批 .o，下一个
# 架构的链接就会捞到上一个架构的目标文件——ld 只给一句 warning
# "found architecture 'x86_64', required architecture 'arm64'"，然后甩一片莫名其妙的
# undefined symbols。一棵树才 150MB 左右，多花这点磁盘换掉一整类静默错很值。
rm -rf "$BUILD_TREE"

# ---- 逐架构构建 ----
first_arch="$(echo $ARCHS | awk '{print $1}')"

for arch in $ARCHS; do
  case "$arch" in
    arm64)  ff_arch="aarch64" ;;
    x86_64) ff_arch="x86_64" ;;
    *) echo "!! 不支持的架构：$arch（只支持 x86_64 / arm64）" >&2; exit 2 ;;
  esac

  # 目标架构与主机不同才需要显式交叉。FFmpeg n7.1 只在给了 --cross-prefix 时
  # 自动开 cross_compile，否则必须自己声明，不然它会拿主机架构去试编译然后报
  # "C compiler test failed"。
  cross_flag=""
  [ "$arch" != "$HOST_ARCH" ] && cross_flag="--enable-cross-compile"

  echo ""
  echo "==================== $arch ===================="
  tree="$BUILD_TREE/$arch"
  echo "==> 复制源码到 $tree ..."
  mkdir -p "$BUILD_TREE"
  cp -a "$SRC_DIR" "$tree"
  cd "$tree"

  # 恢复可执行位：git 里 vendored 的 configure / ffbuild/*.sh 是 100644（本仓库实测
  # configure 与 10 个 .sh 都没有可执行位），cp -a 会把这个状态一起带过来，直接
  # ./configure 会 "Permission denied"（build_ffmpeg.sh 的注释记录过这个坑）。
  chmod +x configure 2>/dev/null || true
  chmod +x ffbuild/*.sh 2>/dev/null || true
  find . -name '*.sh' -exec chmod +x {} + 2>/dev/null || true

  echo "==> configure（--arch=$ff_arch ${cross_flag:-本机构建}）"

  # decoder/demuxer/parser 列表与 build_ffmpeg.sh / build_ffmpeg_cygwin.sh 逐条一致，
  # 保证三平台的视频格式支持范围相同。
  # 注意 macOS 这边**包含** --enable-demuxer=webm（Windows 版漏了这条，webm 靠
  # matroska 兜底；这里按 Linux 的完整列表来）。
  MACOSX_DEPLOYMENT_TARGET="$DEPLOY_TARGET" ./configure \
    --prefix="$INSTALL_DIR/$arch" \
    --target-os=darwin \
    --arch="$ff_arch" \
    --cc=clang --cxx=clang++ \
    $cross_flag \
    --install-name-dir=@rpath \
    --enable-shared \
    --disable-static \
    --enable-pic \
    --disable-programs \
    --disable-doc \
    --disable-autodetect \
    --disable-everything \
    --enable-avcodec \
    --enable-avformat \
    --enable-avutil \
    --enable-swscale \
    --enable-swresample \
    --enable-decoder=h264 \
    --enable-decoder=hevc \
    --enable-decoder=vp8 \
    --enable-decoder=vp9 \
    --enable-decoder=mjpeg \
    --enable-decoder=mpeg4 \
    --enable-decoder=mp3float \
    --enable-decoder=flac \
    --enable-decoder=vorbis \
    --enable-decoder=opus \
    --enable-decoder=aac \
    --enable-decoder=alac \
    --enable-decoder=pcm_s16le \
    --enable-decoder=pcm_s16be \
    --enable-decoder=pcm_u8 \
    --enable-decoder=pcm_f32le \
    --enable-decoder=pcm_alaw \
    --enable-decoder=pcm_mulaw \
    --enable-demuxer=mov \
    --enable-demuxer=matroska \
    --enable-demuxer=webm \
    --enable-demuxer=avi \
    --enable-demuxer=flv \
    --enable-demuxer=mp3 \
    --enable-demuxer=wav \
    --enable-demuxer=flac \
    --enable-demuxer=ogg \
    --enable-demuxer=aiff \
    --enable-demuxer=ape \
    --enable-parser=h264 \
    --enable-parser=hevc \
    --enable-parser=vp8 \
    --enable-parser=vp9 \
    --enable-parser=mpeg4video \
    --enable-parser=mpegaudio \
    --enable-parser=flac \
    --enable-parser=vorbis \
    --enable-parser=opus \
    --enable-parser=aac \
    --enable-protocol=file \
    $X86ASM_FLAG \
    --extra-cflags="-arch $arch -mmacosx-version-min=$DEPLOY_TARGET" \
    --extra-ldflags="-arch $arch -mmacosx-version-min=$DEPLOY_TARGET"

  echo "==> 编译 $arch（-j$JOBS）..."
  make -j"$JOBS"

  echo "==> 安装 $arch ..."
  make install
done

# ---- 合并为 universal ----
echo ""
echo "==================== lipo 合并 ===================="
mkdir -p "$INSTALL_DIR/lib"

for name in avcodec avformat avutil swscale swresample; do
  inputs=()
  for arch in $ARCHS; do
    # 取带版本号的**实体**文件（install 同时产出两级 symlink，别把 symlink 当实体 lipo）。
    real="$(cd "$INSTALL_DIR/$arch/lib" && ls lib${name}.*.dylib 2>/dev/null | head -1 || true)"
    if [ -z "$real" ]; then
      echo "!! $INSTALL_DIR/$arch/lib 下找不到 lib${name}.*.dylib" >&2
      exit 1
    fi
    inputs+=("$INSTALL_DIR/$arch/lib/$real")
  done

  # 产物名必须与库自身的 install_name 一致（@rpath/lib<name>.<MAJOR>.dylib），
  # 否则运行时 dyld 按 install_name 找不到文件。install_name 从 otool -D 读，
  # 不硬编码 61/59/8/5 这类版本号——FFmpeg 升级后这里不会静默失效。
  install_name="$(otool -D "${inputs[0]}" | tail -1)"
  base="$(basename "$install_name")"
  if [ "$base" = "${inputs[0]}" ] || [ -z "$base" ]; then
    echo "!! 读不到 ${inputs[0]} 的 install_name（otool -D 输出：$install_name）" >&2
    exit 1
  fi

  lipo -create "${inputs[@]}" -output "$INSTALL_DIR/lib/$base"
  # 供 CMake find_library(NAMES avcodec ...) 使用；只影响链接期查找，
  # 链接器记录的是 LC_ID_DYLIB（install_name），不会被这个 symlink 带偏。
  ln -sf "$base" "$INSTALL_DIR/lib/lib${name}.dylib"
  echo "  $base -> $(lipo -archs "$INSTALL_DIR/lib/$base")"
done

# ---- 头文件 ----
# 头文件与架构无关，从第一个架构的 install 目录取一份放到 $INSTALL_DIR/include，
# 给 CMake 的 find_path(FFMPEG_INCLUDE_DIR libavformat/avformat.h) 用。
# 必须用 install 出来的那份而不是源码树——libavutil/avconfig.h 是 configure
# 生成的，只在构建树里存在。
rm -rf "$INSTALL_DIR/include"
cp -a "$INSTALL_DIR/$first_arch/include" "$INSTALL_DIR/include"

# ---- 校验 ----
echo ""
echo "==> 产物校验"
fail=0
for f in "$INSTALL_DIR"/lib/*.dylib; do
  # 跳过 symlink，只看实体
  [ -L "$f" ] && continue
  a="$(lipo -archs "$f" 2>/dev/null)"
  m="$(otool -l "$f" 2>/dev/null | grep -A4 LC_BUILD_VERSION | grep minos | tr -d ' ' | head -1)"
  id="$(otool -D "$f" 2>/dev/null | tail -1)"
  printf "  %-30s %-16s %-12s %s\n" "$(basename "$f")" "$a" "$m" "$id"

  for arch in $ARCHS; do
    case "$a" in
      *"$arch"*) ;;
      *) echo "     !! 缺少 $arch 切片"; fail=1 ;;
    esac
  done
  # 部署目标必须 ≤ App 声明的 12.0，否则老系统上 dyld 直接拒绝加载。
  case "$m" in
    minos1[0-2].*|"") ;;
    *) echo "     !! 要求 $m，高于 App 声明的 macOS $DEPLOY_TARGET"; fail=1 ;;
  esac
  case "$id" in
    @rpath/*) ;;
    *) echo "     !! install_name 是 $id，不是 @rpath/...（发布到别人机器会找不到）"; fail=1 ;;
  esac
done

if [ "$fail" -ne 0 ]; then
  echo ""
  echo "!! 校验未通过，不要拿去打包" >&2
  exit 1
fi

echo ""
echo "==> 完成。接着跑 bash scripts/build_native_macos.sh（会把这里的 5 个 dylib"
echo "    一并带进 assets/native/，再由 Xcode 带进 App 的 Contents/Frameworks/）。"
echo "    构建树 $BUILD_TREE 可以删了，占空间。"
