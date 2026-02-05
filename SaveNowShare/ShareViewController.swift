import UIKit
import UniformTypeIdentifiers

@objc(ShareViewController)
class ShareViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        extractSharedURL()
    }

    private func extractSharedURL() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = extensionItem.attachments else {
            closeExtension()
            return
        }

        for provider in attachments {
            if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] (item, error) in
                    guard let self = self else { return }
                    if let shareURL = item as? URL {
                        self.openMainApp(for: shareURL)
                    } else {
                        self.closeExtension()
                    }
                }
                return
            }
        }

        closeExtension()
    }

    private func openMainApp(for url: URL) {
        let encoded = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let appURL = URL(string: "savenow://download?url=\(encoded)")!

        // 🔹 استفاده از responder chain برای باز کردن بی‌هشدار اپ اصلی
        var responder: UIResponder? = self
        let selector = NSSelectorFromString("openURL:")
        while responder != nil {
            if responder?.responds(to: selector) == true {
                responder?.perform(selector, with: appURL)
                break
            }
            responder = responder?.next
        }

        // همیشه Share Extension را ببند
        closeExtension()
    }

    private func closeExtension() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}

