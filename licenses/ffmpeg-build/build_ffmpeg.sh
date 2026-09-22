#!/usr/bin/env bash
# Build FFmpeg as a minimal static library for in-process video decoding.
# Replaces mtmd's subprocess-based (ffprobe + ffmpeg) video path.
#
# Produces: $HOME/pllm-ffmpeg-build/lib/{libavcodec,libavformat,libavutil,libswscale}.a
# Only includes decoders/demuxers/parsers for common video formats.
# Run:  bash scripts/build_ffmpeg.sh
set -euo pipefail

FFMPEG_VERSION="${FFMPEG_VERSION:-n7.1}"
SRC_DIR="${PLLM_FFMPEG_SRC:-$HOME/pllm-ffmpeg-src}"
INSTALL_DIR="${PLLM_FFMPEG_BUILD:-$HOME/pllm-ffmpeg-build}"
JOBS="${JOBS:-$(nproc)}"

echo "==> building FFmpeg $FFMPEG_VERSION (static, minimal)"
echo "    src:   $SRC_DIR"
echo "    install: $INSTALL_DIR"
echo "    jobs:  $JOBS"

# --- Clone source (skip if already present) ---
if [ ! -d "$SRC_DIR/.git" ]; then
    echo "==> cloning FFmpeg $FFMPEG_VERSION..."
    git clone --depth 1 --branch "$FFMPEG_VERSION" \
        https://git.ffmpeg.org/ffmpeg.git "$SRC_DIR"
else
    echo "==> source already exists, skipping clone"
fi

cd "$SRC_DIR"

# --- Configure ---
echo "==> configuring (video+audio: h264/hevc/vp8/vp9/mjpeg/mpeg4 + mp3/flac/vorbis/opus/aac)..."
./configure \
    --prefix="$INSTALL_DIR" \
    --enable-static \
    --disable-shared \
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
echo ""
echo "==> built static libraries:"
for lib in avcodec avformat avutil swscale swresample; do
    f="$INSTALL_DIR/lib/lib${lib}.a"
    if [ -f "$f" ]; then
        size=$(du -h "$f" | cut -f1)
        echo "    $f ($size)"
    else
        echo "    !! MISSING: $f"
    fi
done

echo ""
echo "==> done. CMake will find these via FFMPEG_ROOT=$INSTALL_DIR"