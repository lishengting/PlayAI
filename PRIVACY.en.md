# PlayAI Privacy Policy

**Effective date: 22 September 2026**
**Last updated: 27 October 2026**

This policy applies to all desktop and mobile versions of "PlayAI" (Chinese name
玩AI, hereinafter "this software"). This software is developed and published by
**Li Shengting** (an individual developer, hereinafter "the developer").

**In one sentence: this software has no server of its own and does not collect
your data.** Your conversations, attachments, API keys and logs are stored only
on your own device. Only when you enable a **cloud model** and explicitly agree
in the in-app dialog is the relevant content sent to the third-party AI service
you selected (see Section 4).

---

## 1. What we do not collect

This software **has no account system, no server backend, and no analytics or
crash-reporting components**. Specifically, it:

- does **not** collect device identifiers (IMEI, MAC address, advertising ID,
  etc.), phone numbers, location, or contacts;
- does **not** collect usage behaviour, feature clicks, or time-on-screen
  telemetry;
- does **not** upload your conversation content, attachments, generated output,
  or log files;
- does **not** share or trade any of your information with third parties — the
  **only exception** is when you enable a cloud model and explicitly agree in the
  in-app dialog, in which case the content is sent to the third-party AI service
  you selected (see Section 4);
- contains **no advertising** and no third-party advertising SDK.

---

## 2. Where data is stored

All of the following is stored in this software's **private application
directory on your own device**, which other applications cannot read:

| Data | Storage location | Notes |
|------|------------------|-------|
| Conversation history, attachment index, usage statistics | Local SQLite database | Stored separately per user |
| Original attachment files (image / audio / video / text) | Private application directory | Never uploaded |
| Cloud model API keys | Private application configuration | **Never** uploaded to the developer or any third party |
| Runtime logs | Private application directory | Used only for local troubleshooting; exported only when you choose to |
| Voice-cloning timbre samples | Private application directory | Never uploaded |

**Uninstalling this software deletes all of the above.** You can also delete any
single conversation, any single user, or all data at any time from within the
software.

---

## 3. Which system permissions are needed, and why

This software requests a permission only when the corresponding feature is used.
**Denying a permission does not affect the use of other features.**

| Permission | Platform | Purpose | Can be denied |
|------------|----------|---------|---------------|
| Microphone / audio recording | Android, iOS, HarmonyOS | Voice input, speech transcription, voice cloning | Yes |
| Speech recognition | iOS | Convert your speech to text | Yes |
| Photos / gallery | iOS | Select an image or video to send to a model | Yes |
| Camera | iOS | Capture a photo or video to send to a model | Yes |
| Network | All platforms | Download local models, call the cloud models you configure, check for updates | Required |
| Vibration | HarmonyOS | Operation feedback | Yes |

> **Note for Android**: this software reads images you select through the system
> photo picker, so it does **not** request gallery or camera permissions. It only
> gains access to the single file you actively choose.
>
> Everything recorded from the microphone, selected from the gallery, or captured
> with the camera is **processed on your device only** and does not leave it,
> except when you actively send it in "cloud model" mode.

---

## 4. When the software accesses the network

This software accesses the network in only three situations:

**1. Downloading local models (triggered by you)**

When you tap to download a model, the software downloads the model file from a
public model repository (ModelScope, hf-mirror, etc.). This sends an ordinary
HTTP request and **contains none of your personal information**.

**2. Using cloud models (optional; requires your explicit consent)**

Cloud models are an **optional feature**. When you select a cloud model, the app
first shows a dialog explaining:

- **What is sent** (depending on the features you use):
  - conversation text, system prompt, and message history;
  - images, video frames, audio, and text attachments you add;
  - recordings for speech-to-text, text for speech synthesis, and reference audio
    for voice cloning;
  - prompts and reference images for image/video generation.
- **Who it is sent to**: the dialog shows the provider name and endpoint domain.
  Providers come from the built-in list (Alibaba Cloud Bailian, Volcano Ark,
  Baidu Qianfan, Tencent Hunyuan, Zhipu AI, Moonshot Kimi, DeepSeek, MiniMax) or
  from a LAN/local address you add yourself.
- **Purpose**: solely to generate the reply, transcription, speech, image or video
  you requested.

**No content is sent unless you tap "Agree and continue"; tapping "Cancel" sends
nothing.** Consent is recorded per provider endpoint, so the same endpoint is not
asked again; changing the address (i.e. changing the recipient) triggers a new
request.

The content is processed and retained by the third-party provider under its own
privacy policy. **The developer does not receive, store, or access it.** Built-in
providers are publicly available commercial AI APIs, and data is transmitted over
HTTPS; the developer has confirmed that these providers offer data protection
consistent with their published privacy policies. Specific processing and
retention periods are governed by your agreement with the provider, so please
review its privacy policy before use. **Do not send sensitive personal
information such as ID numbers, bank card numbers, or medical records.**

If you do not configure or enable a cloud service, this software runs entirely
on your device.

**3. Checking for version updates (can be disabled in settings)**

This software queries the version number published on a public code hosting
platform (Gitee / GitHub) to determine whether a newer version exists. That
request **carries no** device or user information.

---

## 5. About AI-generated content

- This software is a **local inference tool**: model weights come from public
  open-source models, and the software neither operates nor hosts any generative
  AI service of its own.
- In cloud model mode, generation is provided by a **third-party provider that
  you choose and configure**.
- AI-generated content **may be inaccurate, biased or inappropriate, and is for
  reference only**. It does not constitute professional advice. You must exercise
  your own judgement and are responsible for how you use the results.
- Do not use generated content for unlawful purposes, or to infringe the lawful
  rights of others.

---

## 6. Protection of minors

This software is not designed specifically for minors and does not knowingly
collect personal information from minors. If you are a minor, please use it under
the guidance of a guardian.

---

## 7. Your rights

Because this software does not collect your data, there is nothing for you to
request access to, correct, or delete from the developer — **you have full
control at all times**:

- delete any single conversation, any single user, or all data from within the
  software;
- delete files directly from the application data directory on your device;
- uninstall this software to erase all data;
- for data retained by a cloud provider, request access or deletion from that
  provider as described in its privacy policy. You can clear the API key or delete
  the provider configuration in settings at any time to stop further sending.

---

## 8. Changes to this policy

If this policy changes, the update will be published on this page and the "Last
updated" date at the top will be revised. Significant changes will be highlighted
prominently within the software. Continued use constitutes acceptance of the
revised policy.

---

## 9. Contact us

If you have any questions, comments or complaints about this policy, please
contact:

**Email: playai@yeah.net**

We will respond within 15 working days.

---

*This software is proprietary. The behaviour of the software itself governs, in
all cases, over the descriptions on this page.*
