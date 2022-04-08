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
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    private let weatherTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private let entireStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationItem()
        self.configureViewModelDelegate()
        self.configureLayout()
        self.configureViewSetting()
    }
    
    private func configureNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
        self.navigationItem.title = "지도와 날씨"
    }
    
    @objc func didTapCancelButton() {
        self.viewModel?.coordinator.occuredViewEvent(with: .dismissDetailShowUIViewController)
    }
    
    private func configureViewSetting() {
        self.viewModel?.createURL()
        self.configureWeatherInformation()
    }
    
    private func configureViewModelDelegate() {
        self.viewModel?.delegate = self
    }
    
    private func configureLayout() {
        self.entireStackView.addArrangedSubview(self.WebView)
        self.entireStackView.addArrangedSubview(self.weatherTextView)
        self.view.addSubview(entireStackView)

        let webViewLayout: [NSLayoutConstraint] = [
            self.WebView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6)
        ]
        
        let entireStackViewLayout: [NSLayoutConstraint] = [
            self.entireStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.entireStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.entireStackView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.entireStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(webViewLayout)
        NSLayoutConstraint.activate(entireStackViewLayout)
    }
    
    private func configureWeatherInformation() {
        
        guard let city = self.viewModel?.city
        else {
            return
        }
        
        _ = self.viewModel?.detailShowUseCase.extractWeather(data: city, completion: { result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.weatherTextView.text = "\(weather)"
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.weatherTextView.text = "에러다아아아아아아"
                }
            }
        })
    }
}

extension DetailShowUIViewController: DetailViewModelDelegate {
    
    func loadWebView(url: URL) {
       WebView.load(URLRequest(url: url))
    }
}
