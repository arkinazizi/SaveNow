# SaveNow

SaveNow is an iOS app with a Share Extension that captures URLs from other apps (like Safari) and forwards them to the main app using a custom URL scheme. The main app can then process the URL (e.g., save or download content). The project uses SwiftData to persist model data such as timestamps for saved items.

## Features

- Share Extension to receive URLs from other apps via the system share sheet.
- Custom URL scheme (`savenow://`) to route shared URLs into the main app.
- SwiftData model (`Item`) for simple persistence.
- Minimal, fast, UI-less share workflow: grab the URL, open the app, and finish.

## Architecture

- Share Extension target:
  - `ShareViewController.swift`: Extracts a shared URL using `UniformTypeIdentifiers` and `NSExtensionItem` attachments, constructs a `savenow://download?url=<...>` URL, and opens the host app using the responder chain (`openURL:`).
- Main App target:
  - Handles incoming URLs via the custom scheme and processes them (e.g., begins a save/download flow).
  - Uses SwiftData with the `Item` model to store data such as timestamps.

## Requirements

- Xcode 15 or later (Xcode 16+ recommended).
- iOS 17.0+ if using SwiftData and `@Model`.
- Swift 5.9+ (Swift 6 compatible).
- Ensure your project has a custom URL scheme configured (`savenow`).

## Setup

1. Clone the repository:
