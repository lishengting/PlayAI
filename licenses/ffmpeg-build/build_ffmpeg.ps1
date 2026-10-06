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
# bash 宿主：Cygwin 与 MSYS2 都是「bash + make + cygpath」，但对本脚本有两点差异——
# 盘符路径格式（/cygdrive/d vs /d）与 bash.exe 位置。按存在性探测，Cygwin 优先
# （本机 D:\cygwin64 是正经 Cygwin；2026-08-02 那版写死的 D:\msys64 已不存在）。
$bashCandidates = @(
  "D:\cygwin64\bin\bash.exe",
  "D:\msys64\usr\bin\bash.exe"
)
$CygwinBash = $bashCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $CygwinBash) { Write-Error "bash not found in any candidate: $($bashCandidates -join ', ')"; exit 1 }

# VS Build Tools：与 build_native.ps1 用同一套候选（作者环境 + 标准安装路径）。
$vsRootCandidates = @(
  "D:\cygwin64\App\MicrosoftVisualStudio\18\BuildTools",
  "D:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools"
)
$VsRoot = $vsRootCandidates |
  Where-Object { Test-Path (Join-Path $_ "VC\Auxiliary\Build\vcvars64.bat") } |
  Select-Object -First 1
if (-not $VsRoot) { Write-Error "vcvars64.bat not found in any candidate: $($vsRootCandidates -join ', ')"; exit 1 }
$Vcvars     = Join-Path $VsRoot "VC\Auxiliary\Build\vcvars64.bat"
$ShScript   = Join-Path $ProjectRoot "scripts\build_ffmpeg_cygwin.sh"

if (-not (Test-Path $Vcvars))     { Write-Error "vcvars64.bat not found at $Vcvars"; exit 1 }
if (-not (Test-Path $ShScript))   { Write-Error "bash script not found at $ShScript"; exit 1 }

Write-Host "==> bash:  $CygwinBash"
Write-Host "==> VS:    $VsRoot"
Write-Host "==> building FFmpeg $FfmpegVersion (shared, minimal, MSVC)"
Write-Host "    src:     $SrcDir"
Write-Host "    install: $InstallDir"

# ---- 1. Clone source (reuse if already present; configure/make run in /tmp) ----
# FFmpeg 源码是完整的，变的只是 configure 参数；已 clone 过就跳过，省掉重复下载。
$gitCmd = "D:\cygwin64\App\Git\cmd"
$env:PATH = ($env:PATH -split ';' | Where-Object { $_ -ne '' -and $_ -notmatch 'cygwin64\\bin' }) -join ';'
$env:PATH = "$gitCmd;$env:PATH"
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
$drive = $ShScript.Substring(0,1).ToLower()
$rest  = $ShScript.Substring(2).Replace("\","/")
$ShCygwin = if ($CygwinBash -match 'msys64') { "/$drive$rest" } else { "/cygdrive/$drive$rest" }

$MsysUsrBin = Split-Path $CygwinBash -Parent
$batFile = Join-Path $env:TEMP "pllm_build_ffmpeg.bat"
# 不用 -l（login 会重置 PATH 丢 cl.exe）；先 prepend bash 自己的 bin 让 make/cygpath 可用，
# bash 非 login 继承 vcvars 的 Windows PATH（含 cl.exe）。
$batContent = "@echo off`r`ncall `"$Vcvars`"`r`nset `"PATH=$MsysUsrBin;%PATH%`"`r`n`"$CygwinBash`" `"$ShCygwin`""
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