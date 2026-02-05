import UIKit
import WebKit

final class InstagramDownloader: NSObject {

    static let shared = InstagramDownloader()

    private var window: UIWindow?
    private var webView: WKWebView?
    private var timeoutTask: DispatchWorkItem?
    private var pollTimer: Timer?

    private var completion: ((Result<URL, DownloadError>) -> Void)?

    private let timeout: TimeInterval = 45

    private override init() {
        super.init()
    }

    // MARK: - Public API

    func startDownload(from reelURL: URL,
                       completion: @escaping (Result<URL, DownloadError>) -> Void) {

        cleanup()

        self.completion = completion

        setupHiddenWindow()
        setupWebView()
        load(url: reelURL)
        startTimeout()
    }

    // MARK: - Hidden Window

    private func setupHiddenWindow() {
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else { return }

        let window = UIWindow(windowScene: scene)
        window.frame = CGRect(x: -3000, y: -3000, width: 1, height: 1)
        window.alpha = 0.01
        window.isHidden = false

        let vc = UIViewController()
        vc.view.backgroundColor = .clear

        window.rootViewController = vc
        window.makeKeyAndVisible()

        self.window = window
    }

    // MARK: - WebView

    private func setupWebView() {
        let config = WKWebViewConfiguration()

        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = prefs

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self

        webView.customUserAgent =
        "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) " +
        "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 " +
        "Mobile/15E148 Safari/604.1"

        webView.isOpaque = false
        webView.backgroundColor = .clear

        self.webView = webView
        window?.rootViewController?.view.addSubview(webView)
    }

    // MARK: - Load

    private func load(url: URL) {
        let request = URLRequest(url: url)
        webView?.load(request)
    }

    // MARK: - Timeout

    private func startTimeout() {
        let task = DispatchWorkItem { [weak self] in
            self?.fail(.timeout)
        }
        timeoutTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: task)
    }

    // MARK: - Polling

    private func startPollingForVideo() {
        pollTimer?.invalidate()

        pollTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.tryExtractVideoURL { url in
                if let url {
                    self?.pollTimer?.invalidate()
                    self?.pollTimer = nil
                    self?.succeed(url)
                }
            }
        }
    }

    // MARK: - JS Extract

    private func tryExtractVideoURL(completion: @escaping (URL?) -> Void) {

        let js = """
        (function() {
            const video = document.querySelector('video');
            if (video && video.src) return video.src;
            const meta = document.querySelector('meta[property="og:video"]');
            return meta ? meta.content : null;
        })();
        """

        webView?.evaluateJavaScript(js) { result, _ in
            if let urlString = result as? String,
               let url = URL(string: urlString) {
                completion(url)
            } else {
                completion(nil)
            }
        }
    }

    // MARK: - Finish

    private func succeed(_ url: URL) {
        completion?(.success(url))
        cleanup()
    }

    private func fail(_ error: DownloadError) {
        completion?(.failure(error))
        cleanup()
    }

    private func cleanup() {
        timeoutTask?.cancel()
        timeoutTask = nil

        pollTimer?.invalidate()
        pollTimer = nil

        webView?.stopLoading()
        webView?.navigationDelegate = nil
        webView?.removeFromSuperview()
        webView = nil

        window?.isHidden = true
        window = nil

        completion = nil
    }
}

// MARK: - WKNavigationDelegate

extension InstagramDownloader: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        // trigger lazy load
        webView.evaluateJavaScript("window.scrollTo(0, 400);", completionHandler: nil)

        startPollingForVideo()
    }
}

// MARK: - Error

extension InstagramDownloader {
    enum DownloadError: Error {
        case timeout
    }
}

