import UIKit
import WebKit
import RxSwift
import RxCocoa

final class DetailWeatherViewController: UIViewController {
    // MARK: - Property
    var viewModel: DetailWeatherViewModel?
    private var backButtonItem: UIBarButtonItem?
    private let bag = DisposeBag()
    // MARK: - UI Components
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
    // MARK: - View Life Cycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureSuperView()
        self.configureNavigationItem()
        self.configureNavigationBarColor()
        self.configureLayout()
        self.bindViewModel()
    }
    // MARK: - Private Method
    private func configureSuperView() {
        self.view.backgroundColor = .white
    }
    
    private func configureNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self, action: nil
        )
        self.backButtonItem = self.navigationItem.leftBarButtonItem
        self.backButtonItem?.tintColor = .white
        
        self.navigationItem.title = "지도와 날씨"
    }
    
    private func configureNavigationBarColor() {
        self.navigationController?.navigationBar.backgroundColor = .systemMint
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func configureLayout() {
        self.view.addSubview(self.webView)
        self.view.addSubview(self.weatherTextView)
        self.view.addSubview(self.imageView)

        let webViewLayout: [NSLayoutConstraint] = [
            self.webView.heightAnchor.constraint(
                equalTo: self.view.heightAnchor,
                multiplier: 0.6
            ),
            self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor)
        ]
        
        let entireStackViewLayout: [NSLayoutConstraint] = [
            self.weatherTextView.heightAnchor.constraint(
                equalTo: self.view.heightAnchor,
                multiplier: 0.4
            ),
            self.weatherTextView.leadingAnchor.constraint(
                equalTo: self.view.leadingAnchor,
                constant: 10
            ),
            self.weatherTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.weatherTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        
        let imageViewLayout: [NSLayoutConstraint] = [
            self.imageView.heightAnchor.constraint(
                equalTo: self.view.heightAnchor,
                multiplier: 0.6
            ),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.weatherTextView.topAnchor)
        ]
        
        NSLayoutConstraint.activate(webViewLayout)
        NSLayoutConstraint.activate(entireStackViewLayout)
        NSLayoutConstraint.activate(imageViewLayout)
    }
    
    private func bindViewModel() {
        
        guard let backButtonEvent = self.backButtonItem?.rx.tap
        else {
            return
        }
        
        guard let city = viewModel?.extractCity()
        else {
            return
        }
        
        let imageCache = self.rx.viewWillDisappear.asObservable()
                .flatMap { (event) -> Observable<ImageCacheData> in
                    self.webView.rx.takeSnapShot(name: city.name)
            }
    
        let input = DetailWeatherViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            capturedImage: imageCache,
            touchUpbackButton: backButtonEvent.asObservable()
        )
        
        guard let output = self.viewModel?.transform(input: input)
        else {
            return
        }
    
        output.weatehrDescription.asDriver(onErrorJustReturn: "")
            .map { $0.toBoldFontForText }
            .drive(self.weatherTextView.rx.attributedText)
            .disposed(by: self.bag)
        
        output.cachedImage?.asDriver(
            onErrorJustReturn: ImageCacheData(key: "", value: UIImage())
        )
            .filter { $0.value != UIImage() }
            .map { (imageCached) -> UIImage in
                return imageCached.value
            }
            .drive(self.imageView.rx.loadCacheView(webView: self.webView))
            .disposed(by: self.bag)
        
        output.selectedURLForMap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (self ,urlRequest) in
                guard let urlRequest = urlRequest
                else {
                    return
                }
                self.webView.load(urlRequest)
            }).disposed(by: self.bag)
        
        output.capturedSuccess.asDriver(onErrorJustReturn: ())
            .drive()
            .disposed(by: self.bag)
        
        output.dismiss.asDriver(onErrorJustReturn: ())
            .drive()
            .disposed(by: self.bag)
    }
}


