<#
.SYNOPSIS
  Build FFmpeg as a minimal static library for Windows (MSVC).
.DESCRIPTION
  Uses Cygwin (bash + make) + VS Build Tools (cl.exe via --toolchain=msvc).
  Calls scripts/build_ffmpeg_cygwin.sh in Cygwin bash after setting up MSVC env.
  Output: build\ffmpeg\lib\{avcodec,avformat,avutil,swscale}.lib
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
$CygwinBash = "D:\msys64\usr\bin\bash.exe"
$VsRoot     = "D:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools"
$Vcvars     = Join-Path $VsRoot "VC\Auxiliary\Build\vcvars64.bat"
$ShScript   = Join-Path $ProjectRoot "scripts\build_ffmpeg_cygwin.sh"

if (-not (Test-Path $CygwinBash)) { Write-Error "Cygwin bash not found at $CygwinBash"; exit 1 }
if (-not (Test-Path $Vcvars))     { Write-Error "vcvars64.bat not found at $Vcvars"; exit 1 }
if (-not (Test-Path $ShScript))   { Write-Error "bash script not found at $ShScript"; exit 1 }

Write-Host "==> building FFmpeg $FfmpegVersion (static, minimal, MSVC)"
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
# MSYS2 路径格式（/d/... 而非 Cygwin 的 /cygdrive/d/...）
$ShCygwin = "/" + $ShScript.Substring(0,1).ToLower() + $ShScript.Substring(2).Replace("\","/")

$MsysUsrBin = Split-Path $CygwinBash -Parent
$batFile = Join-Path $env:TEMP "pllm_build_ffmpeg.bat"
# 不用 -l（login 会重置 PATH 丢 cl.exe）；先 prepend MSYS2 usr\bin 让 make/cygpath 可用，
# bash 非 login 继承 vcvars 的 Windows PATH（含 cl.exe）。
$batContent = "@echo off`r`ncall `"$Vcvars`"`r`nset `"PATH=$MsysUsrBin;%PATH%`"`r`n`"$CygwinBash`" `"$ShCygwin`""
Set-Content -Path $batFile -Value $batContent -Encoding ASCII

Write-Host "==> building (MSVC + Cygwin)..."
cmd /c "`"$batFile`""
$exitCode = $LASTEXITCODE
Remove-Item $batFile -ErrorAction SilentlyContinue
if ($exitCode -ne 0) { Write-Error "Build failed (exit $exitCode)"; exit 1 }

# ---- 4. Verify ----
Write-Host ""
Write-Host "==> built static libraries:"
$libs = @("avcodec", "avformat", "avutil", "swscale", "swresample")
foreach ($lib in $libs) {
    $f = Join-Path $InstallDir "lib\$lib.lib"
    if (Test-Path $f) {
        $size = (Get-Item $f).Length / 1MB
        Write-Host "    $f ($('{0:N1}' -f $size) MB)"
    } else {
        $f2 = Join-Path $InstallDir "lib\lib$lib.a"
        if (Test-Path $f2) {
            $size = (Get-Item $f2).Length / 1MB
            Write-Host "    $f2 ($('{0:N1}' -f $size) MB)"
        } else {
            Write-Host "    !! MISSING: $lib"
        }
    }
}
Write-Host ""
Write-Host "==> done. CMake FFMPEG_ROOT: $InstallDir"