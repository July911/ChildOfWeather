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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
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
        self.view.addSubview(imageView)

        let webViewLayout: [NSLayoutConstraint] = [
            self.WebView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6)
        ]
        
        let entireStackViewLayout: [NSLayoutConstraint] = [
            self.entireStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.entireStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.entireStackView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.entireStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        
        let imageViewLayout: [NSLayoutConstraint] = [
            self.imageView.leadingAnchor.constraint(equalTo: self.WebView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.WebView.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.WebView.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.WebView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(webViewLayout)
        NSLayoutConstraint.activate(entireStackViewLayout)
        NSLayoutConstraint.activate(imageViewLayout)
    }
    
    private func configureWeatherInformation() {
        
        guard let city = self.viewModel?.city
        else {
            return
        }
        
        _ = self.viewModel?.detailShowUseCase.extractWeather(data: city) { result in
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
        }
    }
    
    private func webviewSnapshot() {
        let configuration = WKSnapshotConfiguration()
        configuration.rect = CGRect(x: 0, y: 0, width: self.WebView.bounds.width, height: self.WebView.bounds.height)
        self.WebView.takeSnapshot(with: configuration) { [weak self] (image, error) in
            self?.viewModel?.imageCacheUseCase.cache(
                cityName: self?.viewModel?.city.name ?? "",
                image: image ?? UIImage()
            )
        }
    }
}

extension DetailShowUIViewController: DetailViewModelDelegate {
    
    func loadWebView(url: URL) {
       WebView.load(URLRequest(url: url))
    }
}
