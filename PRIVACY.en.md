# PlayAI Privacy Policy

**Effective date: 22 September 2026**
**Last updated: 22 September 2026**

This policy applies to all desktop and mobile versions of "PlayAI" (Chinese name
玩AI, hereinafter "this software"). This software is developed and published by
**Li Shengting** (an individual developer, hereinafter "the developer").

**In one sentence: this software has no server of its own, and does not collect
or upload any of your data.** Your conversations, attachments, API keys and logs
are stored only on your own device.

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
- does **not** share or trade any of your information with third parties;
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

**2. Using cloud models (configured and triggered by you)**

If you enter an endpoint URL and API key for a cloud model service yourself, then
when you send a message, **the content of that conversation (including any images,
audio or video you attached) is sent to the provider you specified**. This is a
feature you enabled deliberately; the data is handled by that provider under its
own privacy policy, **independently of this software and its developer**. If you
do not configure a cloud service, this software runs entirely offline.

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
- uninstall this software to erase all data.

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
