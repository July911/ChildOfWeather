import UIKit
import WebKit

final class DetailShowUIViewController: UIViewController {
    
    var viewModel: DetailShowViewModel?

    private let WebView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModelDelegate()
        self.view.addSubview(WebView)
        let string = (self.viewModel?.createURL())!
        let url = URL(string: string)!
        WebView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        WebView.frame = view.bounds
    }
    
    private func configureViewModelDelegate() {
        self.viewModel?.delegate = self
    }
}

extension DetailShowUIViewController: DetailViewModelDelegate {
    
}
