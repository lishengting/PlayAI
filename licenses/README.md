# 许可协议全文

本目录存放随发布分发的第三方开源许可协议全文。

## 需要放入的文件

| 文件名 | 来源 | 获取方式 |
|--------|------|---------|
| `FFmpeg-COPYING.LGPLv2.1` | FFmpeg 源码根目录 | `native/src/ffmpeg/COPYING.LGPLv2.1` |
| `llama.cpp-LICENSE` | llama.cpp | `native/src/llama-cpp/LICENSE` |
| `whisper.cpp-LICENSE` | whisper.cpp | `native/src/whisper-cpp/LICENSE` |
| `stable-diffusion.cpp-LICENSE` | stable-diffusion.cpp | `native/src/stable-diffusion.cpp/LICENSE` |
| `OuteTTS-LICENSE` | OuteTTS（Apache-2.0） | `native/src/OuteTTS/LICENSE` |
| `qwentts-LICENSE` | qwentts | `native/src/qwentts/LICENSE` |
| `ONNXRuntime-LICENSE` | ONNX Runtime | 解压 `assets/native/onnxruntime-win-x64-*.zip` 取 `LICENSE` |
| `ONNXRuntime-ThirdPartyNotices.txt` | ONNX Runtime | 同上，取 `ThirdPartyNotices.txt` |

> 可用 `scripts/collect_release_licenses.ps1` 一次性复制（待补）。
> 在此之前手动 `Copy-Item` 即可。

## ffmpeg-build/

存放 FFmpeg 的**可复现构建材料**（LGPL v2.1 第 6 条要求）：

| 文件 | 来源 |
|------|------|
| `build_ffmpeg_cygwin.sh` | `scripts/build_ffmpeg_cygwin.sh` |
| `build_ffmpeg.ps1` | `scripts/build_ffmpeg.ps1` |
| `build_ffmpeg.sh` | `scripts/build_ffmpeg.sh`（Linux） |

⚠️ 这三个脚本是**本项目自己写的构建脚本**，不包含玩AI 的应用源码，
公开它们不构成源码泄露。LGPL 要求公开的正是这部分。

详见 [../THIRD_PARTY_LICENSES.md](../THIRD_PARTY_LICENSES.md) 第二节。
