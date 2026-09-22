#!/usr/bin/env bash
# FFmpeg minimal static build for Windows (MSVC via --toolchain=msvc).
# Called by build_ffmpeg.ps1 which sets PLLM_FFMPEG_SRC / PLLM_FFMPEG_INSTALL.
#
# Source is copied to /tmp/ (Cygwin root, supports posix permissions)
# because /cygdrive/d has posix=0 and chmod +x doesn't work there.
set -euo pipefail

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
    --enable-static \
    --enable-pic \
    --disable-shared \
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
make -j$(nproc)

echo "==> installing to $INSTALL_DIR..."
make install
echo "==> FFmpeg build complete"