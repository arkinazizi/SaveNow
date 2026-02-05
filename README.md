<p align="center">
  <img src="https://cdn-icons-png.flaticon.com/512/732/732250.png" alt="SaveNow Banner" />
</p>

<h1 align="center">SaveNow</h1>

<p align="center">
  Capture links from anywhere. Send to your app. Save instantly. 🔗➡️📲
</p>

<p align="center">
  <a href="https://developer.apple.com/xcode/"><img alt="Xcode" src="https://img.shields.io/badge/Xcode-15%2B-147EFB?logo=xcode&logoColor=white"></a>
  <a href="#requirements"><img alt="iOS" src="https://img.shields.io/badge/iOS-17%2B-black?logo=apple"></a>
  <a href="#license"><img alt="License" src="https://img.shields.io/badge/License-MIT-green"></a>
  <img alt="Swift" src="https://img.shields.io/badge/Swift-5.9%2B-FA7343?logo=swift&logoColor=white">
</p>

---

## ✨ Overview

SaveNow is an iOS app with a Share Extension that captures URLs from other apps (like Safari) and forwards them to the main app using a custom URL scheme. The main app can then process the URL (e.g., save or download content). The project uses SwiftData to persist model data such as timestamps for saved items.

## 🔧 Features

- 📨 Share Extension to receive URLs from other apps via the system share sheet.
- 🧭 Custom URL scheme (`savenow://`) to route shared URLs into the main app.
- 🗂️ SwiftData model (`Item`) for simple persistence.
- ⚡ Minimal, fast, UI-less share workflow: grab the URL, open the app, and finish.

## 🧩 Architecture

