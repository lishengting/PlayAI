# 许可协议全文

本目录存放随发布分发的第三方开源许可协议全文。
组件清单与用途见 [../THIRD_PARTY_LICENSES.md](../THIRD_PARTY_LICENSES.md)（英文版
[../THIRD_PARTY_LICENSES.en.md](../THIRD_PARTY_LICENSES.en.md)）。

> ⚠ **两份清单各有两份拷贝**：`docs/release/` 的是发布材料真源，`assets/docs/`
> 的是 App 内「开源许可」子页读取的资源（Flutter 资源必须在包内）。改任一份
> 都要同步另一份，共四处：
> `docs/release/THIRD_PARTY_LICENSES{,.en}.md` → `assets/docs/THIRD_PARTY_LICENSES{,.en}.md`

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
| `media_kit-LICENSE.txt` | media_kit 1.2.6 / media_kit_video 1.3.1 / media_kit_libs_windows_video 1.0.11 / media_kit_libs_linux 1.2.1 | MIT |
| `mpv-LICENSE.LGPL` | mpv（`libmpv-2.dll`，`-Dgpl=false` 构建） | **LGPL v2.1+** |
| `ANGLE-LICENSE.BSD-3` | ANGLE（`libEGL.dll` / `libGLESv2.dll`） | BSD-3-Clause |
| `SwiftShader-LICENSE.Apache-2.0` | SwiftShader（`vk_swiftshader.dll`） | Apache-2.0 |
| `Vulkan-Loader-LICENSE.Apache-2.0` | Vulkan Loader（`vulkan-1.dll`） | Apache-2.0 |
| `zlib-LICENSE.txt` | zlib（`zlib.dll`） | Zlib |
| `jni-LICENSE.BSD-3` | jni 1.0.3（`dartjni.dll`） | BSD-3-Clause |
| `file_selector_windows-LICENSE.BSD-3` | file_selector_windows 0.9.3+6 | BSD-3-Clause |
| `flutter_tts-LICENSE.MIT` | flutter_tts 4.2.5 | MIT |
| `record_windows-LICENSE.BSD-3` | record_windows 1.0.7 | BSD-3-Clause |
| `screen_retriever_windows-LICENSE.MIT` | screen_retriever_windows 0.2.2 | MIT |
| `share_plus-LICENSE.BSD-3` | share_plus 12.0.2 | BSD-3-Clause |
| `speech_to_text-LICENSE.BSD-3` | speech_to_text 7.4.0 | BSD-3-Clause |
| `url_launcher_windows-LICENSE.BSD-3` | url_launcher_windows 3.1.6 | BSD-3-Clause |
| `volume_controller-LICENSE.MIT` | volume_controller 3.5.0 | MIT |
| `window_manager-LICENSE.MIT` | window_manager 0.4.3 | MIT |

> ⚠ **末 10 份（Flutter 插件）是 2026-10-07 补的。** 此前清单只用一句话概括
> 「各 Flutter 插件自身的编译产物，分别适用其对应 pub 包的许可协议」——**没点名、
> 版本未记、许可全文也没随包**。而 MIT 与 BSD-3-Clause **都要求二进制分发时
> 复现版权声明与许可声明**，随包的 `*_plugin.dll`（Windows）/`*_plugin.so`（Linux）
> 正属此列。现已逐个展开：Windows 12 个二进制、Linux 8 个，涉及 **13 个 pub 包**
> （不含早已列出的 media_kit 本体）。
>
> ⚠ `record_windows` 的 LICENSE 是标准 BSD-3 正文，但版权行写的是
> 「Copyright 2022 **openapi4j authors**」——看着像上游复制粘贴遗留。
> 此处**如实照录，未擅自改写**。
>
> ⚠ media_kit 家族四个包（`media_kit` / `media_kit_video` /
> `media_kit_libs_windows_video` / `media_kit_libs_linux`）的 LICENSE
> **字节完全相同**（同一 md5），故只放一份 `media_kit-LICENSE.txt`。
>
> ⚠ **后 6 份（media_kit 及其 Windows 图形栈）是 2026-10-06 补的。** 此前清单
> 只列了 10 个组件，而 media_kit 的 Windows 包会**固定塞进 7 个二进制**：
> `libmpv-2.dll`、`libEGL.dll`、`libGLESv2.dll`、`vk_swiftshader.dll`、
> `vulkan-1.dll`、`zlib.dll`、`d3dcompiler_47.dll`。其中 `d3dcompiler_47.dll`
> 是微软 DirectX 可再发行组件（**非开源**，依 Microsoft 条款分发），不在此目录。
>
> ⚠ **ANGLE 归档（`flutter-windows-ANGLE-OpenGL-ES` v1.0.1）里连许可文件都不带**，
> 必须从上游各仓库自行取，见下方「重新生成」。

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

✅ **动态链接已落实**（2026-10-05）：FFmpeg 以独立动态库随包分发
（Windows `avcodec-61.dll` 等 / Linux `libavcodec.so.61` 等），用户可自行替换，
满足 LGPL v2.1 第 6 条的「可替换机制」。详见
[../THIRD_PARTY_LICENSES.md](../THIRD_PARTY_LICENSES.md) 第二节。

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

```powershell
# media_kit 及其 Windows 图形栈（2026-10-06 补）
# media_kit 本体：从 pub 缓存取（$env:PUB_CACHE 见 `flutter pub cache` 的位置）
Copy-Item "$env:PUB_CACHE\hosted\pub.flutter-io.cn\media_kit-1.2.6\LICENSE" docs\release\licenses\media_kit-LICENSE.txt

# 其余五份必须联网从**上游仓库**取——ANGLE 归档自己不带许可文件
# ⚠ 本机 github.com 被墙，但 raw.githubusercontent.com 与 jsdelivr 可达
curl.exe -sSL -o docs\release\licenses\mpv-LICENSE.LGPL                 https://raw.githubusercontent.com/mpv-player/mpv/master/LICENSE.LGPL
curl.exe -sSL -o docs\release\licenses\ANGLE-LICENSE.BSD-3              https://cdn.jsdelivr.net/gh/google/angle@main/LICENSE
curl.exe -sSL -o docs\release\licenses\SwiftShader-LICENSE.Apache-2.0   https://raw.githubusercontent.com/google/swiftshader/master/LICENSE.txt
curl.exe -sSL -o docs\release\licenses\Vulkan-Loader-LICENSE.Apache-2.0 https://raw.githubusercontent.com/KhronosGroup/Vulkan-Loader/main/LICENSE.txt
curl.exe -sSL -o docs\release\licenses\zlib-LICENSE.txt                 https://raw.githubusercontent.com/madler/zlib/master/LICENSE
```

```powershell
# Flutter 插件许可（2026-10-07 补）——全部来自 pub 缓存，无需联网。
# $env:PUB_CACHE 见 `flutter pub cache` 的输出（本机为 D:\cygwin64\Tool\pub_cache）。
# 版本号必须与 pubspec.lock 一致；升包后照此重取。
$C = "$env:PUB_CACHE\hosted\pub.flutter-io.cn"
Copy-Item "$C\jni-1.0.3\LICENSE"                      docs\release\licenses\jni-LICENSE.BSD-3
Copy-Item "$C\file_selector_windows-0.9.3+6\LICENSE"  docs\release\licenses\file_selector_windows-LICENSE.BSD-3
Copy-Item "$C\flutter_tts-4.2.5\LICENSE"              docs\release\licenses\flutter_tts-LICENSE.MIT
Copy-Item "$C\record_windows-1.0.7\LICENSE"           docs\release\licenses\record_windows-LICENSE.BSD-3
Copy-Item "$C\screen_retriever_windows-0.2.2\LICENSE" docs\release\licenses\screen_retriever_windows-LICENSE.MIT
Copy-Item "$C\share_plus-12.0.2\LICENSE"              docs\release\licenses\share_plus-LICENSE.BSD-3
Copy-Item "$C\speech_to_text-7.4.0\LICENSE"           docs\release\licenses\speech_to_text-LICENSE.BSD-3
Copy-Item "$C\url_launcher_windows-3.1.6\LICENSE"     docs\release\licenses\url_launcher_windows-LICENSE.BSD-3
Copy-Item "$C\volume_controller-3.5.0\LICENSE"        docs\release\licenses\volume_controller-LICENSE.MIT
Copy-Item "$C\window_manager-0.4.3\LICENSE"           docs\release\licenses\window_manager-LICENSE.MIT
# media_kit 家族另三个包（media_kit_video / media_kit_libs_windows_video /
# media_kit_libs_linux）与 media_kit-LICENSE.txt 字节相同，不重复取。
```

> 插件 DLL/SO 与包的对应关系可随时复核：
> `ls build/windows/x64/runner/Release/*_plugin.dll`（Windows）、
> `ls build/linux/x64/release/bundle/lib/*plugin*.so`（Linux）。
