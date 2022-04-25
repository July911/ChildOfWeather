import UIKit
import WebKit
import RxSwift
import RxCocoa

final class DetailShowUIViewController: UIViewController {
    
    var viewModel: DetailShowViewModel?
    private var backButtonItem: UIBarButtonItem?
    private var snapshotButtonItem: UIBarButtonItem?
    private let bag = DisposeBag()
    
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
        self.configureLayout()
        self.bindViewModel()
    }
    
    private func configureNavigationItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self, action: nil
        )
        self.backButtonItem = self.navigationItem.leftBarButtonItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .camera,
            target: self, action: nil
        )
        self.snapshotButtonItem = self.navigationItem.rightBarButtonItem
        self.navigationItem.title = "지도와 날씨"
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
    
    private func bindViewModel() {
        guard let snapshotButtonEvent = self.snapshotButtonItem?.rx.tap,
              let backButtonEvent = self.backButtonItem?.rx.tap
        else {
            return
        }

        let input = DetailShowViewModel.Input(
            viewWillAppear: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map { _ in },
            didCaptureView: snapshotButtonEvent.asObservable(),
            capturedImage: self.webviewSnapshot(),
            touchUpbackButton: backButtonEvent.asObservable()
        )
        
        guard let output = self.viewModel?.transform(input: input)
        else {
            return
        }
    
        output.weatehrDescription.asDriver(onErrorJustReturn: "")
            .drive(self.weatherTextView.rx.text)
            .disposed(by: self.bag)
        
        output.cachedImage?.asDriver(onErrorJustReturn: ImageCacheData(key: "", value: UIImage()))
            .map { (imageCached) -> UIImage in
                return imageCached.value
            }
            .drive(self.imageView.rx.image)
            .disposed(by: self.bag)
        
        output.selectedURLForMap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (DetailviewController ,string) in
                let k = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL(string: k!)
                let request = URLRequest(url: url!)
                DetailviewController.webView.load(request)
            }).disposed(by: self.bag)
    }
    
    private func webviewSnapshot() -> Observable<ImageCacheData> {
        return Observable<ImageCacheData>.create { emitter in
            self.viewModel.cac
            emitter.onNext(<#T##element: ImageCacheData##ImageCacheData#>)
        }
    }
}

