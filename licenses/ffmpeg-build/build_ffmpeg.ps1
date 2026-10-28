<#
.SYNOPSIS
  Build FFmpeg as minimal shared libraries (DLLs) for Windows (MSVC).
.DESCRIPTION
  Uses a bash host (Cygwin or MSYS2, auto-detected) + VS Build Tools
  (cl.exe via --toolchain=msvc). Calls scripts/build_ffmpeg_cygwin.sh in bash
  after setting up the MSVC env.
  Output: native\ffmpeg\bin\avcodec-61.dll 等 5 个 DLL
        + native\ffmpeg\lib\avcodec.lib 等 5 个导入库（仅链接期需要）
  动态链接是为满足 FFmpeg LGPL v2.1 第 6 条的「可替换机制」义务——
  详见 docs/release/THIRD_PARTY_LICENSES.md 第二节。
.PARAMETER FfmpegVersion
  FFmpeg git tag (default: n7.1).
#>
param(
  [string]$FfmpegVersion = "n7.1"
)
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $ProjectRoot

$SrcDir     = Join-Path $ProjectRoot "native\src\ffmpeg"
$InstallDir = Join-Path $ProjectRoot "native\ffmpeg"

# 探测逻辑集中在 lib/find_vs.ps1（VS 走 vswhere，bash 走 MSYS2/Cygwin 候选）。
. "$PSScriptRoot\lib\find_vs.ps1"

# bash 宿主：Cygwin 与 MSYS2 都是「bash + make + cygpath」。**必须带 make**——
# Git for Windows 的 bash 有 cygpath/nproc/sh 但没有 make（实测），选中它
# FFmpeg 的 make 会直接 command-not-found，故 Find-BashWithMake 会把它筛掉。
$BashExe = Find-BashWithMake
if (-not $BashExe) {
  throw ("找不到带 make 的 bash 宿主（Cygwin 或 MSYS2）。`n" +
         "装 MSYS2（推荐，FFmpeg 官方 Windows/MSVC 构建环境）或 Cygwin，并确保 make 可用。")
}

$vs       = Find-VisualStudio
$Vcvars   = $vs.Vcvars
$ShScript = Join-Path $ProjectRoot "scripts\build_ffmpeg_cygwin.sh"

if (-not (Test-Path $ShScript)) { Write-Error "bash script not found at $ShScript"; exit 1 }

Write-Host "==> bash:  $BashExe"
Write-Host "==> VS:    $($vs.Root)"
Write-Host "==> building FFmpeg $FfmpegVersion (shared, minimal, MSVC)"
Write-Host "    src:     $SrcDir"
Write-Host "    install: $InstallDir"

# ---- 1. Clone source (reuse if already present; configure/make run in /tmp) ----
# FFmpeg 源码是完整的，变的只是 configure 参数；已 clone 过就跳过，省掉重复下载。
# （源码本身已入库 native/src/ffmpeg，正常路径下这里不会触发下载。）
$gitCmd = Find-GitCmd
$env:PATH = Remove-PosixHostFromPath $env:PATH
if ($gitCmd) { $env:PATH = "$gitCmd;$env:PATH" }
if (Test-Path "$SrcDir/configure") {
    Write-Host "==> FFmpeg source already present at $SrcDir, skipping clone (source unchanged)"
} else {
    if (Test-Path $SrcDir) { Remove-Item -Recurse -Force $SrcDir }
    Write-Host "==> cloning FFmpeg $FfmpegVersion (core.autocrlf=false)..."
    & git -c core.autocrlf=false clone --depth 1 --branch $FfmpegVersion https://git.ffmpeg.org/ffmpeg.git $SrcDir
    if ($LASTEXITCODE -ne 0) { Write-Error "git clone failed"; exit 1 }
}

# ---- 2. Set env vars for bash script ----
$env:PLLM_FFMPEG_SRC = $SrcDir
$env:PLLM_FFMPEG_INSTALL = $InstallDir

# ---- 3. Write .bat wrapper (vcvars + bash) ----
# 盘符路径格式随 bash 宿主而变：Cygwin 用 /cygdrive/d/...，MSYS2 用 /d/...
# （ConvertTo-BashPath 按宿主运行时 DLL 判断，不靠安装目录名猜）
$ShBashPath = ConvertTo-BashPath -BashExe $BashExe -WindowsPath $ShScript

$BashBin = Split-Path $BashExe -Parent
Write-Host "==> bash bin: $BashBin"

# 宿主自己的 bin 必须以 **POSIX 形式**传给 .sh，由 bash 内部 export PATH。
# 为什么不能只靠 .bat 里的 set PATH：从 cmd 直接启动的 bash 不保证 PATH 里有它。
# GitHub Actions 的 MSYS2 上实测就如此——configure 能跑通（sed/grep/nproc 有），
# 但 `make: command not found`：那些工具命中的是 Git for Windows 的 usr\bin
# （有 sed/nproc，**没有 make**），MSYS2 自己的 usr\bin 没真正进 PATH。
$env:PLLM_MSYS_BIN = ConvertTo-BashPath -BashExe $BashExe -WindowsPath $BashBin
$makeExe = Join-Path $BashBin 'make.exe'
if (Test-Path $makeExe) {
  # 绝对路径兜底：即使 PATH 拼接仍出问题，make 本身也一定起得来
  $env:PLLM_MAKE = ConvertTo-BashPath -BashExe $BashExe -WindowsPath $makeExe
  Write-Host "==> make:     $makeExe"
} else {
  Write-Warning "宿主目录下没有 make.exe：$makeExe"
}

$batFile = Join-Path $env:TEMP "pllm_build_ffmpeg.bat"
# 不用 -l（login 会重置 PATH 丢 cl.exe）；先 prepend bash 自己的 bin 让 make/cygpath 可用，
# bash 非 login 继承 vcvars 的 Windows PATH（含 cl.exe）。
# ⚠ 这个 prepend 不只是方便：PATH 里若混有另一个 POSIX 宿主（Git for Windows 的
#   usr\bin 常在里面），bash 会解析到**对方**的 make/cygpath，行为完全错乱。
$batContent = "@echo off`r`ncall `"$Vcvars`"`r`nset `"PATH=$BashBin;%PATH%`"`r`n`"$BashExe`" `"$ShBashPath`""
Set-Content -Path $batFile -Value $batContent -Encoding ASCII

Write-Host "==> building (MSVC + bash)..."
cmd /c "`"$batFile`""
$exitCode = $LASTEXITCODE
Remove-Item $batFile -ErrorAction SilentlyContinue
if ($exitCode -ne 0) { Write-Error "Build failed (exit $exitCode)"; exit 1 }

# ---- 4. Verify ----
# 共享构建的产物是「bin\*.dll + lib\*.lib（导入库）」。DLL 名带 MAJOR 版本号
# （n7.1：avcodec-61/avformat-61/avutil-59/swscale-8/swresample-5），故按通配校验，
# 不硬编码版本号——FFmpeg 升级后这里不会静默失效。
Write-Host ""
Write-Host "==> built shared libraries:"
$dlls = @(Get-ChildItem (Join-Path $InstallDir "bin\*.dll") -ErrorAction SilentlyContinue)
if ($dlls.Count -eq 0) {
    Write-Host "    !! MISSING: $InstallDir\bin\*.dll（共享构建应产出 5 个 DLL）"
} else {
    foreach ($d in $dlls) {
        Write-Host ("    {0} ({1:N1} MB)" -f $d.FullName, ($d.Length / 1MB))
    }
}
Write-Host ""
Write-Host "==> import libraries (link-time; MSVC 布局：.lib 与 .dll 同在 bin\):"
$libs = @("avcodec", "avformat", "avutil", "swscale", "swresample")
foreach ($lib in $libs) {
    $f = Join-Path $InstallDir "bin\$lib.lib"
    if (Test-Path $f) {
        Write-Host "    $f"
    } else {
        Write-Host "    !! MISSING: bin\$lib.lib"
    }
}
Write-Host ""
Write-Host "==> done. CMake FFMPEG_ROOT: $InstallDir"