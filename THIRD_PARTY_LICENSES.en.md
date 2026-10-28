# Third-Party Open Source License Notices

PlayAI statically links or redistributes the following third-party open source
components in its build artifacts. Copyright in each component belongs to its
respective owners, and each is governed by the license listed below.

**PlayAI itself is proprietary software.** This notice covers only the
third-party components listed below.

---

## 1. Components distributed with the application

| Component | Version / Source | License | Purpose |
|-----------|------------------|---------|---------|
| [llama.cpp](https://github.com/ggml-org/llama.cpp) | tag `b9838` | MIT | Local large language model inference |
| [whisper.cpp](https://github.com/ggerganov/whisper.cpp) | v1.9.1 | MIT | Speech recognition |
| [stable-diffusion.cpp](https://github.com/leejet/stable-diffusion.cpp) | — | MIT | Local text-to-image |
| [ONNX Runtime](https://github.com/microsoft/onnxruntime) | 1.27.1 | MIT | Vocoder inference for speech synthesis |
| [OuteTTS](https://github.com/edwko/OuteTTS) | 1.0 | Apache-2.0 | Speech synthesis |
| [qwentts](https://github.com/omnivoice/omnivoice.cpp) | — | MIT | Voice cloning synthesis |
| [FFmpeg](https://ffmpeg.org/) | tag `n7.1` (dynamic linking) | **LGPL v2.1+** | Video decoding / frame extraction (see section 2) |
| [media_kit](https://github.com/media-kit/media-kit) | 1.2.6 / 1.3.1 | MIT | Video playback and media control |
| [mpv](https://mpv.io/) (`libmpv`) | Windows: `libmpv-win32-video-build` 2023-09-24; Linux: self-built 0.37.0; macOS: `libmpv-darwin-build` v0.6.0 (mpv 0.36.0) (all `-Dgpl=false`) | **LGPL v2.1+** | Video playback core (see section 3) |
| [libplacebo](https://code.videolan.org/videolan/libplacebo) | 6.338.2 (bundled on Linux) | **LGPL v2.1+** | mpv's GPU rendering backend (see section 3) |
| [libass](https://github.com/libass/libass) | 0.17.1 (bundled on Linux) | ISC | Subtitle rendering |
| [Little CMS](https://www.littlecms.com/) | 2.14 (bundled on Linux) | MIT | Color management (dependency of libplacebo) |
| [ANGLE](https://chromium.googlesource.com/angle/angle) | `flutter-windows-ANGLE-OpenGL-ES` v1.0.1 (`libEGL.dll` / `libGLESv2.dll`) | BSD-3-Clause | OpenGL ES → Direct3D translation (Windows graphics stack) |
| [SwiftShader](https://swiftshader.googlesource.com/SwiftShader) | same archive (`vk_swiftshader.dll`) | Apache-2.0 | Vulkan software rasterizer fallback (Windows) |
| [Vulkan Loader](https://github.com/KhronosGroup/Vulkan-Loader) | same archive (`vulkan-1.dll`) | Apache-2.0 | Vulkan loader (Windows) |
| [zlib](https://zlib.net/) | same archive (`zlib.dll`) | Zlib | Compression (Windows) |
| [miniaudio](https://github.com/mackron/miniaudio) | — | Public Domain / MIT-0 | Audio recording and playback |
| [PortAudio](https://www.portaudio.com/) | Prebuilt binaries shipped with `sounddevice` 0.5.6 (`portaudio.dll`, x64; MME / DirectSound / WDM-KS / WASAPI, no ASIO) | MIT | Windows capture backend (miniaudio's WASAPI cannot open a capture stream on some machines; see `native/voice_bridge.cpp`) |
| [SQLite](https://sqlite.org/) | — | Public Domain | Local data storage |
| [Flutter](https://flutter.dev/) / [Dart](https://dart.dev/) | — | BSD-3-Clause | Application framework and runtime |

Full license texts for these components are in the [`licenses/`](licenses/)
directory.

### 1a. Other binaries distributed with the application

- **`d3dcompiler_47.dll`** (Windows): a Microsoft DirectX redistributable. It is
  **not open source software** and is distributed under the Microsoft software
  license terms, shipped as part of media_kit's Windows graphics archive. The
  open source licenses listed in this notice do not apply to it.
- **`*_plugin.dll` / `*_plugin.so` and `dartjni.dll`**: compiled artifacts of the
  individual Flutter plugins. Both MIT and BSD-3-Clause **require the copyright
  notice and permission notice to be reproduced when distributing binaries**, so
  each is listed individually below (12 binaries on Windows, 8 on Linux, across
  13 pub packages; copyright is held by the respective plugin authors):

| Plugin (pub package) | Version | License | Shipped binary |
|---|---|---|---|
| [jni](https://pub.dev/packages/jni) | 1.0.3 | BSD-3-Clause | `dartjni.dll` |
| [file_selector_windows](https://pub.dev/packages/file_selector_windows) | 0.9.3+6 | BSD-3-Clause | `file_selector_windows_plugin.dll` / `libfile_selector_linux_plugin.so` |
| [flutter_tts](https://pub.dev/packages/flutter_tts) | 4.2.5 | MIT | `flutter_tts_plugin.dll` |
| [media_kit_video](https://pub.dev/packages/media_kit_video) | 1.3.1 | MIT | `media_kit_video_plugin.dll` / `libmedia_kit_video_plugin.so` |
| [media_kit_libs_windows_video](https://pub.dev/packages/media_kit_libs_windows_video) | 1.0.11 | MIT | `media_kit_libs_windows_video_plugin.dll` |
| [media_kit_libs_linux](https://pub.dev/packages/media_kit_libs_linux) | 1.2.1 | MIT | `libmedia_kit_libs_linux_plugin.so` |
| [record_windows](https://pub.dev/packages/record_windows) | 1.0.7 | BSD-3-Clause | `record_windows_plugin.dll` / `librecord_linux_plugin.so` |
| [screen_retriever_windows](https://pub.dev/packages/screen_retriever_windows) | 0.2.2 | MIT | `screen_retriever_windows_plugin.dll` / `libscreen_retriever_linux_plugin.so` |
| [share_plus](https://pub.dev/packages/share_plus) | 12.0.2 | BSD-3-Clause | `share_plus_plugin.dll` |
| [speech_to_text](https://pub.dev/packages/speech_to_text) | 7.4.0 | BSD-3-Clause | `speech_to_text_windows_plugin.dll` |
| [url_launcher_windows](https://pub.dev/packages/url_launcher_windows) | 3.1.6 | BSD-3-Clause | `url_launcher_windows_plugin.dll` / `liburl_launcher_linux_plugin.so` |
| [volume_controller](https://pub.dev/packages/volume_controller) | 3.5.0 | MIT | `volume_controller_plugin.dll` / `libvolume_controller_plugin.so` |
| [window_manager](https://pub.dev/packages/window_manager) | 0.4.3 | MIT | `window_manager_plugin.dll` / `libwindow_manager_plugin.so` |

Full license texts are in the [`licenses/`](licenses/) directory (the four
media_kit-family packages share `media_kit-LICENSE.txt`, byte-identical).

---

## 2. Special notice for FFmpeg (LGPL v2.1+)

PlayAI **dynamically links** the following FFmpeg libraries:
`libavcodec`, `libavformat`, `libavutil`, `libswscale`, `libswresample`.

**Dynamic linking (replacement mechanism)**: these libraries are distributed as
**separate dynamic libraries** alongside the application — on Windows
`avcodec-61.dll`, `avformat-61.dll`, `avutil-59.dll`, `swscale-8.dll`,
`swresample-5.dll` (in the same directory as the main executable); on Linux
`libavcodec.so.61`, `libavformat.so.61`, `libavutil.so.59`, `libswscale.so.8`,
`libswresample.so.5` (in the same directory as the main executable); on macOS
`libavcodec.61.dylib`, `libavformat.61.dylib`, `libavutil.59.dylib`,
`libswscale.8.dylib`, `libswresample.5.dylib` (in
`PlayAI.app/Contents/Frameworks/`). They are **not statically linked into this
software**, so you may replace them with a compatible, modified build of FFmpeg.
This software **does not verify, sign or lock** these library files, and applies
no technical measures that would prevent replacement. This satisfies the
"replacement mechanism" requirement of LGPL v2.1, section 6.

> The FFmpeg libraries shipped with the macOS build **are code-signed** — an
> unsigned dynamic library inside an app bundle cannot be loaded, and there is
> no way around that. So that this signing does not amount to a technical
> measure preventing replacement, the app disables the hardened runtime's
> library validation (`com.apple.security.cs.disable-library-validation`) in
> `Release.entitlements`. A third-party FFmpeg build signed with a different
> identity can therefore still be loaded.

> Also note: the macOS bundle contains a **second set of FFmpeg libraries** —
> `Avcodec.framework` / `Avformat.framework` / `Avutil.framework` /
> `Swscale.framework` / `Swresample.framework` / `Avfilter.framework`, shipped
> by media_kit. These are the FFmpeg **6.1** embedded in mpv (libavcodec
> `60.3.100`), and they **coexist** with the 7.1 build made by this software
> (`libavcodec.61.dylib` and friends, listed above) without interfering —
> macOS uses a two-level namespace by default, so identically named symbols do
> not clash. They come from `libmpv-darwin-build` v0.6.0 along with mpv; see
> section 3 for their provenance, licensing and replacement mechanism.

> Note: the iOS / Android / HarmonyOS builds **do not include FFmpeg** (video
> frame extraction is provided on Windows, Linux and macOS), so the statement
> above does not apply to those three distributions.

**License mode**: FFmpeg was built **without** `--enable-gpl` or
`--enable-nonfree`, and without GPL components such as `libpostproc`.
The linked FFmpeg is therefore covered by the **GNU Lesser General Public
License v2.1 or later**, not the GPL.

**Reproducible build materials** (provided under LGPL v2.1, section 6):

- **Source**: official FFmpeg source, tag `n7.1`
  <https://git.ffmpeg.org/ffmpeg.git> (mirror: <https://github.com/FFmpeg/FFmpeg>)
- **Build scripts**: see [`licenses/ffmpeg-build/`](licenses/ffmpeg-build/),
  which contains the exact configure options and build procedure used
  (three files, one per platform distribution: Windows, Linux, macOS)
- **Modifications**: this software **makes no modifications to the FFmpeg source**

The full FFmpeg license text is in
[`licenses/FFmpeg-COPYING.LGPLv2.1`](licenses/FFmpeg-COPYING.LGPLv2.1).

---

## 3. Special notice for mpv / libmpv (LGPL v2.1+)

`libmpv-2.dll` in the Windows distribution comes from the prebuilt archive
`libmpv-win32-video-build` (2023-09-24) maintained by media_kit. **It is LGPL,
not GPL**:

- mpv itself is built with **`-Dgpl=false`** (a meson option), i.e. under the
  **GNU Lesser General Public License v2.1 or later**;
- its bundled FFmpeg is built with
  `--disable-gpl --disable-nonfree --enable-version3`, which corresponds to
  **LGPL v3** for that part.

**Dynamic loading (replacement mechanism)**: `libmpv-2.dll` is a **separate
dynamic library in the same directory as the main executable**, loaded on demand
at runtime by media_kit. It is **not statically linked into this software**, so
you may replace it with a compatible, modified build of libmpv. This software
**does not verify, sign or lock** that file.

**Reproducible build materials** (provided under LGPL, section 6):

- **Source**: official mpv source <https://github.com/mpv-player/mpv>
- **Prebuilt archive**: <https://github.com/media-kit/libmpv-win32-video-build>
  (release `2023-09-24`)
- **Modifications**: this software **makes no modifications to the mpv source**

The full libmpv license text is in
[`licenses/mpv-LICENSE.LGPL`](licenses/mpv-LICENSE.LGPL).

**As of 2026-10-12 the Linux distribution includes a self-built libmpv**
(`lib/libmpv.so.2.2.0`). Previously it relied on the user's system libmpv, but the
sonames of the two Ubuntu LTS releases are mutually exclusive (22.04 only has
`libmpv.so.1`, 24.04 only has `libmpv.so.2`), so both cannot be supported at once —
and when libmpv is missing the application **does not start at all** (this is not a
graceful degradation). Build method and all flags: `scripts/build_libmpv.sh`
(reproducible: source is the official Ubuntu archive tarball
`mpv_0.37.0.orig.tar.xz` with its sha256 pinned in the script; FFmpeg is this
repository's own n7.1 build).

- **Modifications**: a single FFmpeg 7 compatibility change —
  `AV_OPT_TYPE_CHANNEL_LAYOUT` was renamed to `AV_OPT_TYPE_CHLAYOUT` in FFmpeg 6.0;
  the script renames it in place with `sed` (the only occurrence in the tree).
- **Linux dependencies bundled alongside**: `libplacebo.so.338` (LGPL v2.1+),
  `libass.so.9` (ISC), `liblcms2.so.2` (MIT). All three are taken unmodified from
  official Ubuntu 24.04 binary packages; corresponding source packages are available
  from <https://archive.ubuntu.com/ubuntu/pool/>. Remaining dependencies
  (X11/Wayland/GL/Vulkan/alsa/pulse/pipewire/fontconfig, …) come from the system.

**The macOS build also ships libmpv** (`Mpv.framework`, 7.1 MB), brought in by
media_kit's macOS dependency package and loaded at runtime by
`media_kit_video.framework`. It comes from the prebuilt archive maintained by
media-kit, **`libmpv-darwin-build` release `v0.6.0`**
(`libmpv-xcframeworks_v0.6.0_macos-universal-video-default.tar.gz`, sha256 pinned
in `media_kit_libs_macos_video-1.1.4/macos/Makefile`). The build configuration
string embedded in the binary shows **mpv 0.36.0** with
**`-Dgpl=false -Dcplayer=false -Dlibmpv=true`** — the same nature as the Windows
build, i.e. **LGPL v2.1+, not GPL**.

On macOS, mpv is distributed as a set of xcframeworks: `Mpv.framework` plus its
sibling dependencies `Avcodec` / `Avformat` / `Avutil` / `Swscale` /
`Swresample` / `Avfilter` / `Ass` / `Freetype` / `Fribidi` / `Harfbuzz` /
`Png16` / `Dav1d` / `Mbedcrypto` / `Mbedtls` / `Mbedx509` / `Uchardet` /
`Xml2`. They all come from the same archive, this software **makes no
modifications** to them, and each component's license is as declared by the
upstream archive. Note that this build uses
`-Dlibplacebo=disabled -Dvulkan=disabled`, so macOS **does not** ship
libplacebo (unlike the Linux list below).

- **Source**: official mpv source <https://github.com/mpv-player/mpv> (0.36.0)
- **Prebuilt archive**: <https://github.com/media-kit/libmpv-darwin-build>
  (release `v0.6.0`, `-video-default` variant)
- **Modifications**: this software makes no modifications to the mpv source

> ⚠ As with `libmpv-2.dll` on Windows, this software **does not verify or lock**
> the framework. It lives inside the app bundle, so it must be code-signed to be
> loaded and a replacement has to be re-signed — the
> `disable-library-validation` described in section 2 for macOS applies to the
> frameworks in this section as well.

The iOS / Android / HarmonyOS builds do not ship libmpv.

---

## 4. Model weights are not covered

This software **does not include any model weight files**. Models are downloaded
by the user from public model repositories; their licenses are provided
separately by each model's rights holder (commonly Apache-2.0, MIT, the Llama
Community License, and so on) and are **not covered by this notice**. Users must
comply with the license terms of any model they use.

---

## 5. Updates

This list is updated with each release. If you find an omission or error, please
contact **playai@yeah.net**.
