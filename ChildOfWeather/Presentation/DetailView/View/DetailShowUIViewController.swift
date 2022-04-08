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
        imageView.isHidden = true
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationItem()
        self.configureViewModelDelegate()
        self.configureLayout()
        self.configureViewSetting()
        self.viewModel?.loadCacheImage()
    }
    
    private func configureNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(didTapAddButton))
        self.navigationItem.title = "지도와 날씨"
    }
    
    @objc func didTapCancelButton() {
        self.viewModel?.coordinator.occuredViewEvent(with: .dismissDetailShowUIViewController)
    }
    
    @objc func didTapAddButton() {
        self.webviewSnapshot { }
    }
    
    private func configureViewSetting() {
        self.viewModel?.createURL()
        self.configureWeatherInformation()
    }
    
    private func configureViewModelDelegate() {
        self.viewModel?.delegate = self
    }
    
    private func configureLayout() {
        self.view.addSubview(self.WebView)
        self.view.addSubview(self.weatherTextView)
        self.view.addSubview(self.imageView)

        let webViewLayout: [NSLayoutConstraint] = [
            self.WebView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6),
            self.WebView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.WebView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.WebView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ]
        
        let entireStackViewLayout: [NSLayoutConstraint] = [
            self.weatherTextView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4),
            self.weatherTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.weatherTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.weatherTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        
        let imageViewLayout: [NSLayoutConstraint] = [
            self.imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.weatherTextView.topAnchor)
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
            case .failure(let _):
                DispatchQueue.main.async {
                    self.weatherTextView.text = "에러다아아아아아아"
                }
            }
        }
    }
    
    private func webviewSnapshot(completion: @escaping () -> Void) {
        let configuration = WKSnapshotConfiguration()
        self.WebView.takeSnapshot(with: configuration) { [weak self] (image, error) in
            self?.viewModel?.imageCacheUseCase.setCache(cityName: self?.viewModel?.city.name ?? "",
                image: image ?? UIImage()
            )
        }
    }
}

extension DetailShowUIViewController: DetailViewModelDelegate {
    
    func loadWebView(url: URL) {
       WebView.load(URLRequest(url: url))
    }
    
    func loadImageView() {

        guard let image = self.viewModel?.imageCacheUseCase.getImage(cityName: self.viewModel?.city.name ?? "")
        else {
            return
        }
        WebView.isHidden = true
        imageView.isHidden = false
        
        self.imageView.image = image
    }
    
    func cacheImage() {
        self.webviewSnapshot { }
    }
}
