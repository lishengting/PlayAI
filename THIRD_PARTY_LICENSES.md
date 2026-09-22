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
| [FFmpeg](https://ffmpeg.org/) | tag `n7.1` | **LGPL v2.1+** | 视频解码抽帧（见第二节） |
| [miniaudio](https://github.com/mackron/miniaudio) | — | Public Domain / MIT-0 | 音频录制与播放 |
| [SQLite](https://sqlite.org/) | — | Public Domain | 本地数据存储 |
| [Flutter](https://flutter.dev/) / [Dart](https://dart.dev/) | — | BSD-3-Clause | 应用框架与运行时 |

各组件许可协议全文见 [`licenses/`](licenses/) 目录。

---

## 二、FFmpeg 特别声明（LGPL v2.1+）

本软件**静态链接**了 FFmpeg 的以下库：
`libavcodec`、`libavformat`、`libavutil`、`libswscale`、`libswresample`。

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

> ⚠ **待办（发布前须落实）**：
> LGPL v2.1 第 6 条对**静态链接**的场景，还要求提供"可重新链接"的材料
> （即让用户能用修改后的 FFmpeg 重新链接本软件）。
> 常见做法有二：① 随附本软件的目标文件（`.obj`/`.lib`）；
> ② 改为动态链接 FFmpeg。当前两者都未做。
> 是否必须做到这一层，建议咨询专业人士后再定；
> 若暂不处理，至少应确保上述源码与构建脚本材料完整可获取。

---

## 三、模型权重不在此列

本软件**不包含任何模型权重文件**。模型由用户自行从公开模型仓库下载，
其许可协议由各模型的权利人单独提供（常见为 Apache-2.0、MIT、
Llama 社区许可等），**不适用本声明**。用户使用某模型时须自行遵守该模型
的许可条款。

---

## 四、更新维护

本清单随版本发布更新。若发现遗漏或错误，请联系
**playai@yeah.net**。
