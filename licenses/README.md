# 许可协议全文

本目录存放随发布分发的第三方开源许可协议全文。
组件清单与用途见 [../THIRD_PARTY_LICENSES.md](../THIRD_PARTY_LICENSES.md)。

## 组件许可

| 文件 | 组件 | 协议 |
|------|------|------|
| `FFmpeg-COPYING.LGPLv2.1` | FFmpeg n7.1 | **LGPL v2.1+** |
| `llama.cpp-LICENSE` | llama.cpp b9838 | MIT |
| `whisper.cpp-LICENSE` | whisper.cpp v1.9.1 | MIT |
| `stable-diffusion.cpp-LICENSE` | stable-diffusion.cpp | MIT |
| `OuteTTS-LICENSE` | OuteTTS 1.0 | Apache-2.0 |
| `qwentts-LICENSE` | qwentts | MIT |
| `ONNXRuntime-LICENSE` | ONNX Runtime 1.27.1 | MIT |
| `ONNXRuntime-ThirdPartyNotices.txt` | 同上，其内部第三方组件 | 各自协议 |
| `miniaudio-LICENSE.txt` | miniaudio v0.11.25 | Public Domain / MIT-0 |
| `SQLite-LICENSE.txt` | SQLite 3.50.2 | Public Domain |

> Flutter / Dart（BSD-3-Clause）的许可全文由 Flutter SDK 随附，
> 应用内「开源许可」页（`LicenseRegistry`）会自动列出，不在此目录重复。

## ffmpeg-build/

FFmpeg 的**可复现构建材料**（LGPL v2.1 第 6 条要求）：

| 文件 | 说明 |
|------|------|
| `build_ffmpeg_cygwin.sh` | Windows 构建（configure 参数在此） |
| `build_ffmpeg.ps1` | Windows 构建入口 |
| `build_ffmpeg.sh` | Linux 构建 |

⚠️ 这三个是**本项目自己写的构建脚本**，不含玩AI 的应用源码，
公开它们不构成源码泄露——LGPL 要求公开的正是这部分。
**本软件未对 FFmpeg 源码做任何修改。**

⚠️ 仍待落实：LGPL v2.1 第 6 条对**静态链接**场景还要求提供"可重新链接"
的材料。详见 [../THIRD_PARTY_LICENSES.md](../THIRD_PARTY_LICENSES.md) 第二节。

## 重新生成

```powershell
# 原生组件许可（从 native/src 复制）
Copy-Item native\src\ffmpeg\COPYING.LGPLv2.1       docs\release\licenses\FFmpeg-COPYING.LGPLv2.1
Copy-Item native\src\llama-cpp\LICENSE             docs\release\licenses\llama.cpp-LICENSE
Copy-Item native\src\whisper-cpp\LICENSE           docs\release\licenses\whisper.cpp-LICENSE
Copy-Item native\src\stable-diffusion.cpp\LICENSE  docs\release\licenses\stable-diffusion.cpp-LICENSE
Copy-Item native\src\OuteTTS\LICENSE               docs\release\licenses\OuteTTS-LICENSE
Copy-Item native\src\qwentts\LICENSE               docs\release\licenses\qwentts-LICENSE

# ONNX Runtime（从 zip 解出）
Expand-Archive assets\native\onnxruntime-win-x64-1.27.1.zip -DestinationPath $env:TEMP\ort
Copy-Item $env:TEMP\ort\onnxruntime-win-x64-1.27.1\LICENSE                docs\release\licenses\ONNXRuntime-LICENSE
Copy-Item $env:TEMP\ort\onnxruntime-win-x64-1.27.1\ThirdPartyNotices.txt docs\release\licenses\ONNXRuntime-ThirdPartyNotices.txt

# FFmpeg 构建脚本
Copy-Item scripts\build_ffmpeg_cygwin.sh,scripts\build_ffmpeg.ps1,scripts\build_ffmpeg.sh docs\release\licenses\ffmpeg-build\
```
