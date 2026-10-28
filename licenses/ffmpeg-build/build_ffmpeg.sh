#!/usr/bin/env bash
# Build FFmpeg as minimal SHARED libraries for in-process video decoding.
# Replaces mtmd's subprocess-based (ffprobe + ffmpeg) video path.
# 动态链接是为满足 LGPL v2.1 第 6 条的「可替换机制」义务。
#
# Produces: $HOME/pllm-ffmpeg-build/lib/libav{codec,format,util}.so.*
#                                        libsw{scale,resample}.so.*
# Only includes decoders/demuxers/parsers for common video formats.
# Run:  bash scripts/build_ffmpeg.sh
set -euo pipefail

FFMPEG_VERSION="${FFMPEG_VERSION:-n7.1}"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
INSTALL_DIR="${PLLM_FFMPEG_BUILD:-$HOME/pllm-ffmpeg-build}"
JOBS="${JOBS:-$(nproc)}"

# 源码目录：优先用仓库内 vendored 的 native/src/ffmpeg（与 Windows 版
# build_ffmpeg.ps1 一致）。CI 是干净 clone，若默认去 git.ffmpeg.org 拉，
# 既慢，又会让构建源与仓库固定的版本脱钩（可复现性 / LGPL 合规都受影响）。
if [ -n "${PLLM_FFMPEG_SRC:-}" ]; then
  SRC_DIR="$PLLM_FFMPEG_SRC"
elif [ -f "$REPO_ROOT/native/src/ffmpeg/configure" ]; then
  SRC_DIR="$REPO_ROOT/native/src/ffmpeg"
else
  SRC_DIR="$HOME/pllm-ffmpeg-src"
fi

echo "==> building FFmpeg $FFMPEG_VERSION (shared, minimal)"
echo "    src:   $SRC_DIR"
echo "    install: $INSTALL_DIR"
echo "    jobs:  $JOBS"

# --- Clone source (skip if already present) ---
# 判据用 configure 而不是 .git：vendored 源码是平铺文件、没有 .git 目录，
# 用 .git 判断会对着一份完整源码去做 git clone 而失败。
if [ ! -f "$SRC_DIR/configure" ]; then
    echo "==> cloning FFmpeg $FFMPEG_VERSION..."
    git clone --depth 1 --branch "$FFMPEG_VERSION" \
        https://git.ffmpeg.org/ffmpeg.git "$SRC_DIR"
else
    echo "==> source already present, skipping clone"
fi

# --- Copy to a scratch build tree ---
# FFmpeg 的 configure/make 是**就地构建**，会往源码目录里写大量产物。
# 源码现在优先取仓库内的 native/src/ffmpeg，就地编会把工作树弄脏
# （Windows 版 build_ffmpeg.ps1 同样是先拷到 /tmp 再编）。
BUILD_TREE="${PLLM_FFMPEG_TREE:-$HOME/pllm-ffmpeg-buildtree}"
echo "==> copying source to $BUILD_TREE ..."
rm -rf "$BUILD_TREE"
cp -a "$SRC_DIR" "$BUILD_TREE"
cd "$BUILD_TREE"

# 恢复可执行位：git 里 vendored 的 configure / ffbuild/*.sh 是 100644（本仓库
# 实测 configure 与 10 个 .sh 都没有可执行位），cp -a 会把这个状态一起带过来，
# 直接 ./configure 会 "Permission denied"（CI 上实测，exit 126）。
# Windows 版 build_ffmpeg_cygwin.sh 出于同样原因也要做这一步。
chmod +x configure 2>/dev/null || true
chmod +x ffbuild/*.sh 2>/dev/null || true
find . -name '*.sh' -exec chmod +x {} + 2>/dev/null || true

# --- Configure ---
echo "==> configuring (video+audio: h264/hevc/vp8/vp9/mjpeg/mpeg4 + mp3/flac/vorbis/opus/aac)..."
./configure \
    --prefix="$INSTALL_DIR" \
    --enable-shared \
    --disable-static \
    --enable-pic \
    --disable-inline-asm \
    --disable-x86asm \
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

# --- Build ---
echo "==> building ($JOBS jobs)..."
make -j"$JOBS"

# --- Install ---
echo "==> installing to $INSTALL_DIR..."
make install

# --- Verify ---
# 共享构建产出「带版本号的实体 .so + 两个 symlink」。用通配匹配，
# 不硬编码 MAJOR 版本号（n7.1：avcodec 61 / avformat 61 / avutil 59 /
# swscale 8 / swresample 5）——FFmpeg 升级后这里不会静默失效。
echo ""
echo "==> built shared libraries:"
for lib in avcodec avformat avutil swscale swresample; do
    found=0
    for f in "$INSTALL_DIR"/lib/lib${lib}.so*; do
        [ -e "$f" ] || continue
        found=1
        echo "    $f ($(du -h "$f" | cut -f1))"
    done
    [ "$found" -eq 1 ] || echo "    !! MISSING: $INSTALL_DIR/lib/lib${lib}.so*"
done

echo ""
echo "==> done. CMake will find these via FFMPEG_ROOT=$INSTALL_DIR"