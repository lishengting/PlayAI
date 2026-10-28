#!/usr/bin/env bash
# FFmpeg minimal SHARED build for Windows (MSVC via --toolchain=msvc).
# 动态链接是为满足 LGPL v2.1 第 6 条的「可替换机制」义务；产物是
# bin\avcodec-61.dll 等 5 个 DLL + lib\*.lib 导入库。
# Called by build_ffmpeg.ps1 which sets PLLM_FFMPEG_SRC / PLLM_FFMPEG_INSTALL.
#
# Source is copied to /tmp/ (Cygwin root, supports posix permissions)
# because /cygdrive/d has posix=0 and chmod +x doesn't work there.
set -euo pipefail

# 宿主自己的 bin 必须在 PATH 里。从 cmd 直接启动的 bash 不保证继承到它——
# GitHub Actions 的 MSYS2 上实测：configure 能跑通（sed/grep/nproc 都在），
# 但 `make: command not found`。原因是那些工具命中了 Git for Windows 的
# usr\bin（有 sed/nproc，**没有 make**），MSYS2 自己的 usr\bin 没进 PATH。
# .ps1 以 POSIX 形式传入，这里在 bash 内部前置最可靠。
if [ -n "${PLLM_MSYS_BIN:-}" ]; then
  export PATH="$PLLM_MSYS_BIN:$PATH"
fi
MAKE_BIN="${PLLM_MAKE:-make}"

WIN_SRC=$(cygpath -u "$PLLM_FFMPEG_SRC")
INSTALL_DIR=$(cygpath -u "$PLLM_FFMPEG_INSTALL")
BUILD_DIR=/tmp/pllm-ffmpeg-build

# Copy source to /tmp/ (Cygwin root has posix permissions)
echo "==> copying source to $BUILD_DIR ..."
rm -rf "$BUILD_DIR"
cp -r "$WIN_SRC" "$BUILD_DIR"
cd "$BUILD_DIR"

# Set execute permissions (works on Cygwin root, not on /cygdrive/d)
chmod +x configure ffbuild/*.sh 2>/dev/null || true
find . -name '*.sh' -exec chmod +x {} + 2>/dev/null || true

echo "==> configuring FFmpeg (toolchain=msvc, video+audio decoders)..."
bash ./configure \
    --toolchain=msvc \
    --prefix="$INSTALL_DIR" \
    --enable-shared \
    --enable-pic \
    --disable-static \
    --disable-programs \
    --disable-doc \
    --disable-autodetect \
    --disable-everything \
    --disable-inline-asm \
    --disable-x86asm \
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
    --enable-protocol=file

echo "==> building ($(nproc) jobs)..."
"$MAKE_BIN" -j$(nproc)

echo "==> installing to $INSTALL_DIR..."
make install
echo "==> FFmpeg build complete"