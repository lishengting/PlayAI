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
| [mpv](https://mpv.io/)（`libmpv`） | `libmpv-win32-video-build` 2023-09-24，`-Dgpl=false` | **LGPL v2.1+** | 视频播放内核（见第三节） |
| [ANGLE](https://chromium.googlesource.com/angle/angle) | `flutter-windows-ANGLE-OpenGL-ES` v1.0.1（`libEGL.dll` / `libGLESv2.dll`） | BSD-3-Clause | OpenGL ES → Direct3D 转译（Windows 图形栈） |
| [SwiftShader](https://swiftshader.googlesource.com/SwiftShader) | 同上归档（`vk_swiftshader.dll`） | Apache-2.0 | Vulkan 软件光栅化回退（Windows） |
| [Vulkan Loader](https://github.com/KhronosGroup/Vulkan-Loader) | 同上归档（`vulkan-1.dll`） | Apache-2.0 | Vulkan 加载器（Windows） |
| [zlib](https://zlib.net/) | 同上归档（`zlib.dll`） | Zlib | 压缩（Windows） |
| [miniaudio](https://github.com/mackron/miniaudio) | — | Public Domain / MIT-0 | 音频录制与播放 |
| [SQLite](https://sqlite.org/) | — | Public Domain | 本地数据存储 |
| [Flutter](https://flutter.dev/) / [Dart](https://dart.dev/) | — | BSD-3-Clause | 应用框架与运行时 |

各组件许可协议全文见 [`licenses/`](licenses/) 目录。

### 一之补：其他随包二进制

- **`d3dcompiler_47.dll`**（Windows）：微软 DirectX 可再发行组件，
  **非开源软件**，依 Microsoft 软件许可条款随包分发，由 media_kit 的
  Windows 图形归档一并提供。不适用本声明所列的开源许可。
- **`*_plugin.dll` 与 `dartjni.dll`**（Windows）：各 Flutter 插件自身的
  编译产物，分别适用其对应 pub 包的许可协议（均为 MIT 或 BSD-3-Clause），
  著作权归各插件作者所有。

---

## 二、FFmpeg 特别声明（LGPL v2.1+）

本软件**动态链接**了 FFmpeg 的以下库：
`libavcodec`、`libavformat`、`libavutil`、`libswscale`、`libswresample`。

**动态链接（可替换机制）**：上述库以**独立的动态链接库**随包分发——
Windows 为 `avcodec-61.dll`、`avformat-61.dll`、`avutil-59.dll`、
`swscale-8.dll`、`swresample-5.dll`（与主程序同目录）；
Linux 为 `libavcodec.so.61`、`libavformat.so.61`、`libavutil.so.59`、
`libswscale.so.8`、`libswresample.so.5`（与主程序同目录）。
它们**未被静态链入本软件**，用户可以自行替换为兼容的、经过修改的 FFmpeg
构建版本——本软件**不校验、不签名、不锁定**这些库文件，也未设置任何
阻止替换的技术措施。这满足 LGPL v2.1 第 6 条对「可替换机制」的要求。

> 说明：macOS / iOS / Android / 鸿蒙版本**不包含 FFmpeg**（视频抽帧仅
> Windows 与 Linux 提供），故上述声明只对 Windows 与 Linux 发行包适用。

**许可模式**：本软件构建 FFmpeg 时**未启用** `--enable-gpl` 与
`--enable-nonfree`，也未启用 `libpostproc` 等 GPL 组件，
因此所链接的 FFmpeg 适用 **GNU Lesser General Public License v2.1 或更高版本**，
而非 GPL。

**可复现构建材料**（依 LGPL v2.1 第 6 条提供）：

- **源码**：FFmpeg 官方源码，tag `n7.1`
  <https://git.ffmpeg.org/ffmpeg.git> （镜像：<https://github.com/FFmpeg/FFmpeg>）
- **构建脚本**：见 [`licenses/ffmpeg-build/`](licenses/ffmpeg-build/)，
  即本软件使用的完整 configure 参数与构建流程
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

> 说明：**Linux 发行包不包含 libmpv**——media_kit 在 Linux 上不捆绑它，
> 由用户系统的软件包提供（如 Debian/Ubuntu 的 `libmpv2`）。
> macOS / iOS / Android / 鸿蒙版本同样不随包分发 libmpv。

---

## 四、关于 `libsixel.so.1`

Linux 发行包中的 `libsixel.so.1` **不是 libsixel 项目**，而是**本软件自研的
桩实现**（源码：`native/stub_sixel.c`）。它存在的唯一目的是：libmpv 会链接
真实 libsixel 以支持终端图形输出，而在非终端环境（本软件）下其分配器未被
正确初始化会触发断言崩溃；该桩把 libmpv 实际调用的那批符号替换为安全的空
操作。它由本软件自行编写，**不包含任何 libsixel 代码**，因此不适用第三方
许可，libsixel 本体亦未随本软件分发。

---

## 五、模型权重不在此列

本软件**不包含任何模型权重文件**。模型由用户自行从公开模型仓库下载，
其许可协议由各模型的权利人单独提供（常见为 Apache-2.0、MIT、
Llama 社区许可等），**不适用本声明**。用户使用某模型时须自行遵守该模型
的许可条款。

---

## 六、更新维护

本清单随版本发布更新。若发现遗漏或错误，请联系
**playai@yeah.net**。
