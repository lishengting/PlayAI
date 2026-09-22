# 更新日志 · Changelog

本文件记录玩AI（PlayAI）各版本的变更。格式参考
[Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)。
版本号遵循[语义化版本](https://semver.org/lang/zh-CN/)。

1.0.0 之前的版本为内部开发版本，不对外发布，历史已合并为「内部版本」。

---

## [1.0.0] - 待发布

首个公开版本。

### 新增

- **本地大模型推理** —— 基于 llama.cpp，支持流式输出、思考链展示与
  上下文滑动窗口；全程离线，对话内容不出本机
- **云端模型接入** —— 兼容任意 OpenAI 协议接口，可配置多个服务商与密钥；
  图片、视频、音频可随消息提交，本地与云端操作方式一致
- **多智能体对话** —— 单个对话可挂载多个智能体，各自独立配置模型、
  提示词、推理参数、音色与字体；支持 @ 提及路由与多轮循环讨论
- **多模态交互** —— 图片理解、视频抽帧理解、语音转文字、文字转语音、
  语音克隆、本地与云端文生图、云端文生视频
- **提示词系统** —— 对话主题统一注入；系统提示词支持日期、用户名、
  智能体名、座位号、轮次等变量占位符
- **内容创作** —— 内置涂鸦与绘图面板，可绘制图形、添加文字并导出图片，
  可直接发送到对话继续处理
- **数据管理** —— 对话导出为 Markdown / JSON / 带图片的压缩包；
  口令加密备份与恢复；跨对话全局消息检索
- **多用户** —— 多用户独立数据空间，可选密码保护；用量统计不随对话删除丢失
- **跨平台** —— 同一套代码运行于 Windows、Linux、macOS、Android、
  iOS 与 HarmonyOS 六个平台
- **安装引导** —— 全新安装自动检测模型与智能体配置，提供一键下载本地模型
  或配置云端服务的引导

### 已知限制

- 鸿蒙版本需通过应用市场或开发者侧载安装，不提供公开直装包
- iOS 版本仅通过 App Store / TestFlight 分发
- macOS 版本要求 12.0 及以上

---

<!-- 发布后按此格式追加：

## [1.0.1] - 2026-XX-XX

### 修复
- …

### 变更
- …

-->

---

# Changelog (English)

Changes to PlayAI are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows
[Semantic Versioning](https://semver.org/).

Versions before 1.0.0 were internal development builds, never publicly
released, and are merged into "Internal".

## [1.0.0] - Unreleased

First public release.

### Added

- **Local LLM inference** — powered by llama.cpp, with streaming output,
  visible thinking chains and a sliding context window; fully offline, your
  conversations never leave your device
- **Cloud model support** — works with any OpenAI-compatible endpoint;
  configure multiple providers and keys; images, video and audio can be
  attached to messages, with identical UX to local models
- **Multi-agent conversations** — mount several agents in one conversation,
  each with its own model, prompt, inference parameters, voice and font;
  `@`-mention routing and multi-round discussion
- **Multimodal I/O** — image understanding, video frame extraction,
  speech-to-text, text-to-speech, voice cloning, local and cloud image
  generation, cloud video generation
- **Prompt system** — conversation topic injected globally; system prompts
  support placeholders for date, user name, agent name, seat and round
- **Content creation** — built-in scribble and drawing panel with shapes and
  text, exportable to images and sendable straight into a conversation
- **Data management** — export conversations as Markdown / JSON / a folder or
  archive with images; password-encrypted backup and restore; global
  cross-conversation message search
- **Multi-user** — isolated data spaces per user, optional password
  protection; usage statistics survive conversation deletion
- **Cross-platform** — one codebase for Windows, Linux, macOS, Android,
  iOS and HarmonyOS
- **First-run onboarding** — detects missing models or agents and offers
  one-click local model download or cloud service setup

### Known limitations

- HarmonyOS builds are distributed via AppGallery or developer sideloading;
  no public direct-install package
- iOS builds ship only through the App Store / TestFlight
- macOS builds require 12.0 or later
