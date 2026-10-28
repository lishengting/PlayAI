# 第三方开源组件许可声明

玩AI（PlayAI）在构建产物中静态链接或随包分发了以下第三方开源组件。
各组件的著作权归其各自权利人所有，分别适用下列许可协议。

**本软件本身为专有软件**；本声明仅覆盖下列第三方组件。

---

## 一、随包分发的组件

| 组件 | 版本 / 来源 | 许可协议 | 用途 |
|------|------------|---------|------|
| [llama.cpp](https://github.com/ggml-org/llama.cpp) | tag `b9838` | MIT | 本地大语言模型推理 |
| [whisper.cpp](https://github.com/ggerganov/whisper.cpp) | v1.9.1 | MIT | 语音识别 |
| [stable-diffusion.cpp](https://github.com/leejet/stable-diffusion.cpp) | — | MIT | 本地文生图 |
| [ONNX Runtime](https://github.com/microsoft/onnxruntime) | 1.27.1 | MIT | 语音合成声码器推理 |
| [OuteTTS](https://github.com/edwko/OuteTTS) | 1.0 | Apache-2.0 | 语音合成 |
| [qwentts](https://github.com/omnivoice/omnivoice.cpp) | — | MIT | 语音克隆合成 |
| [FFmpeg](https://ffmpeg.org/) | tag `n7.1`（动态链接） | **LGPL v2.1+** | 视频解码抽帧（见第二节） |
| [media_kit](https://github.com/media-kit/media-kit) | 1.2.6 / 1.3.1 | MIT | 视频播放与媒体控制 |
| [mpv](https://mpv.io/)（`libmpv`） | Windows: `libmpv-win32-video-build` 2023-09-24；Linux: 自建 0.37.0；macOS: `libmpv-darwin-build` v0.6.0（mpv 0.36.0）（均 `-Dgpl=false`） | **LGPL v2.1+** | 视频播放内核（见第三节） |
| [libplacebo](https://code.videolan.org/videolan/libplacebo) | 6.338.2（Linux 随包） | **LGPL v2.1+** | mpv 的 GPU 渲染后端（见第三节） |
| [libass](https://github.com/libass/libass) | 0.17.1（Linux 随包） | ISC | 字幕渲染 |
| [Little CMS](https://www.littlecms.com/) | 2.14（Linux 随包） | MIT | 色彩管理（libplacebo 的依赖） |
| [ANGLE](https://chromium.googlesource.com/angle/angle) | `flutter-windows-ANGLE-OpenGL-ES` v1.0.1（`libEGL.dll` / `libGLESv2.dll`） | BSD-3-Clause | OpenGL ES → Direct3D 转译（Windows 图形栈） |
| [SwiftShader](https://swiftshader.googlesource.com/SwiftShader) | 同上归档（`vk_swiftshader.dll`） | Apache-2.0 | Vulkan 软件光栅化回退（Windows） |
| [Vulkan Loader](https://github.com/KhronosGroup/Vulkan-Loader) | 同上归档（`vulkan-1.dll`） | Apache-2.0 | Vulkan 加载器（Windows） |
| [zlib](https://zlib.net/) | 同上归档（`zlib.dll`） | Zlib | 压缩（Windows） |
| [miniaudio](https://github.com/mackron/miniaudio) | — | Public Domain / MIT-0 | 音频录制与播放 |
| [PortAudio](https://www.portaudio.com/) | 随 `sounddevice` 0.5.6 的预编译产物（`portaudio.dll`，x64；MME / DirectSound / WDM-KS / WASAPI，不含 ASIO） | MIT | Windows 录音采集后端（miniaudio 的 WASAPI 在部分机器上无法开流，见 `native/voice_bridge.cpp`） |
| [SQLite](https://sqlite.org/) | — | Public Domain | 本地数据存储 |
| [Flutter](https://flutter.dev/) / [Dart](https://dart.dev/) | — | BSD-3-Clause | 应用框架与运行时 |

各组件许可协议全文见 [`licenses/`](licenses/) 目录。

### 一之补：其他随包二进制

- **`d3dcompiler_47.dll`**（Windows）：微软 DirectX 可再发行组件，
  **非开源软件**，依 Microsoft 软件许可条款随包分发，由 media_kit 的
  Windows 图形归档一并提供。不适用本声明所列的开源许可。
- **`*_plugin.dll` / `*_plugin.so` 与 `dartjni.dll`**：各 Flutter 插件自身的
  编译产物。MIT 与 BSD-3-Clause **都要求二进制分发时复现版权声明与许可声明**，
  故逐个列明如下（Windows 12 个二进制、Linux 8 个，涉及 13 个 pub 包；著作权归
  各插件作者所有）：

| 插件（pub 包） | 版本 | 协议 | 随包的二进制 |
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

各插件许可全文见 [`licenses/`](licenses/) 目录（media_kit 家族四个包共用
`media_kit-LICENSE.txt`，其字节完全相同）。

---

## 二、FFmpeg 特别声明（LGPL v2.1+）

本软件**动态链接**了 FFmpeg 的以下库：
`libavcodec`、`libavformat`、`libavutil`、`libswscale`、`libswresample`。

**动态链接（可替换机制）**：上述库以**独立的动态链接库**随包分发——
Windows 为 `avcodec-61.dll`、`avformat-61.dll`、`avutil-59.dll`、
`swscale-8.dll`、`swresample-5.dll`（与主程序同目录）；
Linux 为 `libavcodec.so.61`、`libavformat.so.61`、`libavutil.so.59`、
`libswscale.so.8`、`libswresample.so.5`（与主程序同目录）；
macOS 为 `libavcodec.61.dylib`、`libavformat.61.dylib`、`libavutil.59.dylib`、
`libswscale.8.dylib`、`libswresample.5.dylib`
（位于 `PlayAI.app/Contents/Frameworks/`）。
它们**未被静态链入本软件**，用户可以自行替换为兼容的、经过修改的 FFmpeg
构建版本——本软件**不校验、不签名、不锁定**这些库文件，也未设置任何
阻止替换的技术措施。这满足 LGPL v2.1 第 6 条对「可替换机制」的要求。

> macOS 版随包的 FFmpeg 库**带有代码签名**——app bundle 内未被签名的动态库
> 无法被加载，这一点无法避免。为不使签名构成「阻止替换的技术措施」，App 在
> `Release.entitlements` 中关闭了强化运行时的库校验
> （`com.apple.security.cs.disable-library-validation`），因此替换为第三方
> 构建、签名身份不同的 FFmpeg 库仍可被正常加载。

> 另注：macOS 包里**还有第二套 FFmpeg**——media_kit 随包的
> `Avcodec.framework` / `Avformat.framework` / `Avutil.framework` /
> `Swscale.framework` / `Swresample.framework` / `Avfilter.framework`，是
> mpv 的内嵌 FFmpeg **6.1**（libavcodec `60.3.100`），与本软件自编的 7.1
> （上面列的 `libavcodec.61.dylib` 等）**并存**、互不干扰（macOS 默认
> two-level namespace，同名符号不冲突）。它们随 mpv 一同来自
> `libmpv-darwin-build` v0.6.0，来源、许可与替换机制见第三节。

> 说明：iOS / Android / 鸿蒙版本**不包含 FFmpeg**，故上述声明不适用于这三个平台的
> 发行包。视频抽帧在 iOS / 鸿蒙上另有实现且不涉及 FFmpeg 许可：iOS 用系统
> AVFoundation（`AVAssetImageGenerator`），鸿蒙用系统 `AVMetadataExtractor`；Android 暂不支持。

**许可模式**：本软件构建 FFmpeg 时**未启用** `--enable-gpl` 与
`--enable-nonfree`，也未启用 `libpostproc` 等 GPL 组件，
因此所链接的 FFmpeg 适用 **GNU Lesser General Public License v2.1 或更高版本**，
而非 GPL。

**可复现构建材料**（依 LGPL v2.1 第 6 条提供）：

- **源码**：FFmpeg 官方源码，tag `n7.1`
  <https://git.ffmpeg.org/ffmpeg.git> （镜像：<https://github.com/FFmpeg/FFmpeg>）
- **构建脚本**：见 [`licenses/ffmpeg-build/`](licenses/ffmpeg-build/)，
  即本软件使用的完整 configure 参数与构建流程
  （Windows / Linux / macOS 三份，分别对应三个平台的发行包）
- **修改**：本软件**未对 FFmpeg 源码做任何修改**

FFmpeg 许可全文见 [`licenses/FFmpeg-COPYING.LGPLv2.1`](licenses/FFmpeg-COPYING.LGPLv2.1)。

---

## 三、mpv / libmpv 特别声明（LGPL v2.1+）

Windows 发行包中的 `libmpv-2.dll` 来自 media_kit 维护的预编译归档
`libmpv-win32-video-build`（2023-09-24）。**它是 LGPL，不是 GPL**：

- mpv 本体以 **`-Dgpl=false`** 构建（meson 参数），即
  **GNU Lesser General Public License v2.1 或更高版本**；
- 其内嵌的 FFmpeg 以 `--disable-gpl --disable-nonfree --enable-version3`
  构建，该部分对应 **LGPL v3**。

**动态加载（可替换机制）**：`libmpv-2.dll` 是**与主程序同目录的独立动态库**，
由 media_kit 在运行时按需加载，**未被静态链入本软件**。用户可以自行替换为
兼容的、经过修改的 libmpv 构建版本——本软件**不校验、不签名、不锁定**该文件。

**可复现构建材料**（依 LGPL 第 6 条提供）：

- **源码**：mpv 官方源码 <https://github.com/mpv-player/mpv>
- **预编译归档**：<https://github.com/media-kit/libmpv-win32-video-build>
  （release `2023-09-24`）
- **修改**：本软件**未对 mpv 源码做任何修改**

libmpv 许可全文见 [`licenses/mpv-LICENSE.LGPL`](licenses/mpv-LICENSE.LGPL)。

**Linux 发行包自 2026-10-12 起包含自建的 libmpv**（`lib/libmpv.so.2.2.0`）。
原状是依赖用户系统的 libmpv，但两个 Ubuntu LTS 的 soname 互斥（22.04 只有
`libmpv.so.1`、24.04 只有 `libmpv.so.2`），无法同时支持，且缺失时程序**根本
起不来**（不是功能降级）。改为自建，构建方式与全部参数见
`scripts/build_libmpv.sh`（可复现：源码来自 Ubuntu 官方归档
`mpv_0.37.0.orig.tar.xz`，sha256 在脚本内钉死；FFmpeg 复用本仓库自建的 n7.1）。

- **修改**：仅一处 FFmpeg 7 兼容改动——`AV_OPT_TYPE_CHANNEL_LAYOUT` 在 FFmpeg 6.0
  更名为 `AV_OPT_TYPE_CHLAYOUT`，脚本以 `sed` 就地改名（全仓仅此一处）。
- **同节随包的 Linux 依赖**：`libplacebo.so.338`（LGPL v2.1+）、`libass.so.9`（ISC）、
  `liblcms2.so.2`（MIT）。三者均取自 Ubuntu 24.04 官方二进制包、**未做修改**；
  对应源码包可从 <https://archive.ubuntu.com/ubuntu/pool/> 获取。
  其余依赖（X11/Wayland/GL/Vulkan/alsa/pulse/pipewire/fontconfig 等）由系统提供。

**macOS 发行包同样随包分发 libmpv**（`Mpv.framework`，7.1 MB）——由 media_kit
的 macOS 依赖包带进来，`media_kit_video.framework` 在运行时加载。来源是
media-kit 维护的预编译归档 **`libmpv-darwin-build` release `v0.6.0`**
（`libmpv-xcframeworks_v0.6.0_macos-universal-video-default.tar.gz`，sha256 钉在
`media_kit_libs_macos_video-1.1.4/macos/Makefile` 里）。二进制内嵌的构建配置串
实测为 **mpv 0.36.0**，且带 **`-Dgpl=false -Dcplayer=false -Dlibmpv=true`**
——与 Windows 那份同性质，是 **LGPL v2.1+，不是 GPL**。

macOS 上 mpv 以一组 xcframework 分发：`Mpv.framework` 及其同级依赖
`Avcodec` / `Avformat` / `Avutil` / `Swscale` / `Swresample` / `Avfilter` /
`Ass` / `Freetype` / `Fribidi` / `Harfbuzz` / `Png16` / `Dav1d` /
`Mbedcrypto` / `Mbedtls` / `Mbedx509` / `Uchardet` / `Xml2`。它们全部来自同一个
归档，本软件**未做任何修改**，各组件许可随上游归档声明。注意该构建带
`-Dlibplacebo=disabled -Dvulkan=disabled`，故 macOS **不带** libplacebo
（与下面 Linux 的清单不同）。

- **源码**：mpv 官方源码 <https://github.com/mpv-player/mpv>（0.36.0）
- **预编译归档**：<https://github.com/media-kit/libmpv-darwin-build>
  （release `v0.6.0`，`-video-default` 变体）
- **修改**：本软件未对 mpv 源码做任何修改

> ⚠ 与 Windows 的 `libmpv-2.dll` 同理，本软件**不校验、不锁定**该 framework。
> 它位于 app bundle 内，同样必须带代码签名才能被加载，替换后需重签——第二节
> macOS 那段说明的 `disable-library-validation` 对本节的 framework 一并适用。

iOS / Android / 鸿蒙版本不随包分发 libmpv。

---

## 四、模型权重不在此列

本软件**不包含任何模型权重文件**。模型由用户自行从公开模型仓库下载，
其许可协议由各模型的权利人单独提供（常见为 Apache-2.0、MIT、
Llama 社区许可等），**不适用本声明**。用户使用某模型时须自行遵守该模型
的许可条款。

---

## 五、更新维护

本清单随版本发布更新。若发现遗漏或错误，请联系
**playai@yeah.net**。
