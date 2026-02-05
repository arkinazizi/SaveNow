import SwiftUI

@main
struct SaveNowApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    handleDeepLink(url)
                }
        }
    }

    private func handleDeepLink(_ url: URL) {
        guard
            url.scheme == "savenow",
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let reelString = components.queryItems?
                .first(where: { $0.name == "url" })?.value,
            let reelURL = URL(string: reelString)
        else {
            return
        }

        InstagramDownloader.shared.startDownload(from: reelURL) { result in
            switch result {
            case .success(let videoURL):
                print("🎉 VIDEO URL:", videoURL)

            case .failure(let error):
                print("❌ FAILED:", error)
            }
        }
    }
}

