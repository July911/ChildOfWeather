import UIKit
import WebKit

final class DetailShowUIViewController: UIViewController {
    
    var viewModel: DetailShowViewModel?

    private let webView: WKWebView = {
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
        self.configureViewSettingUseViewModel()
    }
    
    private func configureNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self, action: #selector(didTapCancelButton)
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .camera,
            target: self,
            action: #selector(didTapAddButton)
        )
        self.navigationItem.title = "지도와 날씨"
    }
    
    @objc func didTapCancelButton() {
        self.viewModel?.occuredBackButtonTapEvent()
    }
    
    @objc func didTapAddButton() {
        self.webviewSnapshot { }
    }
    
    private func configureViewSettingUseViewModel() {
        self.viewModel?.extractURLForMap()
        self.viewModel?.loadCacheImage()
        self.viewModel?.extractWeatherDescription()
    }
    
    private func configureViewModelDelegate() {
        self.viewModel?.delegate = self
    }
    
    private func configureLayout() {
        self.view.addSubview(self.webView)
        self.view.addSubview(self.weatherTextView)
        self.view.addSubview(self.imageView)

        let webViewLayout: [NSLayoutConstraint] = [
            self.webView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.6),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor)
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
    
    private func webviewSnapshot(completion: @escaping () -> Void) {
        let configuration = WKSnapshotConfiguration()
        self.webView.takeSnapshot(with: configuration) { [weak self] (image, error) in
            
            guard let cityName = self?.viewModel?.city.name as? NSString
            else {
                return
            }
            
            guard let image = image else {
                return
            }

            let cacheObject = ImageCacheData(key: cityName, value: image)
            self?.viewModel?.cache(object: cacheObject)
        }
    }
}

extension DetailShowUIViewController: DetailViewModelDelegate {
    
    func loadWebView(url: URL) {
       webView.load(URLRequest(url: url))
    }
    
    func loadTodayDescription(weather description: String) {
        DispatchQueue.main.async {
            self.weatherTextView.text = "\(description)"
        }
    }

    func loadImageView() {

        guard let cacheObject = self.viewModel?.extractCache(
            key: self.viewModel?.city.name ?? ""
        )
        else {
            return
        }
        
        webView.isHidden = true
        imageView.isHidden = false
        
        self.imageView.image = cacheObject.value
    }
    
    func cacheImage() {
        self.webviewSnapshot { }
    }
}
