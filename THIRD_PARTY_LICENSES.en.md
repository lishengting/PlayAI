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
| [mpv](https://mpv.io/) (`libmpv`) | `libmpv-win32-video-build` 2023-09-24, `-Dgpl=false` | **LGPL v2.1+** | Video playback core (see section 3) |
| [ANGLE](https://chromium.googlesource.com/angle/angle) | `flutter-windows-ANGLE-OpenGL-ES` v1.0.1 (`libEGL.dll` / `libGLESv2.dll`) | BSD-3-Clause | OpenGL ES → Direct3D translation (Windows graphics stack) |
| [SwiftShader](https://swiftshader.googlesource.com/SwiftShader) | same archive (`vk_swiftshader.dll`) | Apache-2.0 | Vulkan software rasterizer fallback (Windows) |
| [Vulkan Loader](https://github.com/KhronosGroup/Vulkan-Loader) | same archive (`vulkan-1.dll`) | Apache-2.0 | Vulkan loader (Windows) |
| [zlib](https://zlib.net/) | same archive (`zlib.dll`) | Zlib | Compression (Windows) |
| [miniaudio](https://github.com/mackron/miniaudio) | — | Public Domain / MIT-0 | Audio recording and playback |
| [SQLite](https://sqlite.org/) | — | Public Domain | Local data storage |
| [Flutter](https://flutter.dev/) / [Dart](https://dart.dev/) | — | BSD-3-Clause | Application framework and runtime |

Full license texts for these components are in the [`licenses/`](licenses/)
directory.

### 1a. Other binaries distributed with the application

- **`d3dcompiler_47.dll`** (Windows): a Microsoft DirectX redistributable. It is
  **not open source software** and is distributed under the Microsoft software
  license terms, shipped as part of media_kit's Windows graphics archive. The
  open source licenses listed in this notice do not apply to it.
- **`*_plugin.dll` and `dartjni.dll`** (Windows): compiled artifacts of the
  individual Flutter plugins, each governed by the license of its own pub
  package (all MIT or BSD-3-Clause), with copyright held by the respective
  plugin authors.

---

## 2. Special notice for FFmpeg (LGPL v2.1+)

PlayAI **dynamically links** the following FFmpeg libraries:
`libavcodec`, `libavformat`, `libavutil`, `libswscale`, `libswresample`.

**Dynamic linking (replacement mechanism)**: these libraries are distributed as
**separate dynamic libraries** alongside the application — on Windows
`avcodec-61.dll`, `avformat-61.dll`, `avutil-59.dll`, `swscale-8.dll`,
`swresample-5.dll` (in the same directory as the main executable); on Linux
`libavcodec.so.61`, `libavformat.so.61`, `libavutil.so.59`, `libswscale.so.8`,
`libswresample.so.5` (in the same directory as the main executable). They are
**not statically linked into this software**, so you may replace them with a
compatible, modified build of FFmpeg. This software **does not verify, sign or
lock** these library files, and applies no technical measures that would prevent
replacement. This satisfies the "replacement mechanism" requirement of LGPL
v2.1, section 6.

> Note: the macOS / iOS / Android / HarmonyOS builds **do not include FFmpeg**
> (video frame extraction is provided on Windows and Linux only), so the
> statement above applies only to the Windows and Linux distributions.

**License mode**: FFmpeg was built **without** `--enable-gpl` or
`--enable-nonfree`, and without GPL components such as `libpostproc`.
The linked FFmpeg is therefore covered by the **GNU Lesser General Public
License v2.1 or later**, not the GPL.

**Reproducible build materials** (provided under LGPL v2.1, section 6):

- **Source**: official FFmpeg source, tag `n7.1`
  <https://git.ffmpeg.org/ffmpeg.git> (mirror: <https://github.com/FFmpeg/FFmpeg>)
- **Build scripts**: see [`licenses/ffmpeg-build/`](licenses/ffmpeg-build/),
  which contains the exact configure options and build procedure used
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

> Note: the **Linux distribution does not include libmpv** — media_kit does not
> bundle it on Linux; it is provided by the user's system packages (e.g.
> `libmpv2` on Debian/Ubuntu). The macOS / iOS / Android / HarmonyOS builds do
> not ship libmpv either.

---

## 4. About `libsixel.so.1`

`libsixel.so.1` in the Linux distribution is **not the libsixel project**; it is
a **stub written by this project** (source: `native/stub_sixel.c`). Its only
purpose is this: libmpv links against real libsixel for terminal graphics
output, but in a non-terminal environment (this application) libsixel's
allocator is not properly initialised and triggers a fatal assertion. The stub
replaces the handful of symbols libmpv actually calls with safe no-ops. It was
written by this project, **contains no libsixel code**, and therefore falls
under no third-party license; libsixel itself is not distributed with this
software.

---

## 5. Model weights are not covered

This software **does not include any model weight files**. Models are downloaded
by the user from public model repositories; their licenses are provided
separately by each model's rights holder (commonly Apache-2.0, MIT, the Llama
Community License, and so on) and are **not covered by this notice**. Users must
comply with the license terms of any model they use.

---

## 6. Updates

This list is updated with each release. If you find an omission or error, please
contact **playai@yeah.net**.
