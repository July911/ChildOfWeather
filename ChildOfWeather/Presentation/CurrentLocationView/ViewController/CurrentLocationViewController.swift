import UIKit
import RxSwift
import RxCocoa
import WebKit

final class CurrentLocationViewController: UIViewController {
// MARK: - Properties 
    var viewModel: CurrentLocationViewModel?
    private var refreshNavigationButton: UIBarButtonItem?
    private let bag = DisposeBag()
// MARK: - UI Components
    private var cityNameLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .yellow
        label.font = .preferredFont(forTextStyle: .largeTitle, compatibleWith: .none)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true 
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        return webView
    }()
    
    private var weatherDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .headline)
        textView.textAlignment = .left
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
// MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationItem()
        self.configureLayout()
        self.bindViewModel()
    }
// MARK: - Private Method
    private func bindViewModel() {
        guard let leftBarButtonEvent = self.refreshNavigationButton?.rx.tap.asObservable()
        else {
            return
        }
        
        let imageCache = self.rx.viewWillDisappear
            .asObservable()
            .flatMap { (event) -> Observable<ImageCacheData> in
                self.webView.rx.takeSnapShot(name: "current")
            }
        
        let input = CurrentLocationViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            cachedImage: imageCache,
            locationChange: leftBarButtonEvent,
            dismiss: self.rx.viewWillDisappear.asObservable()
        )
        
        let output = self.viewModel?.transform(input: input)
        
        output?.weatherDescription
            .asDriver(onErrorJustReturn: "")
            .drive(self.weatherDescriptionTextView.rx.text)
            .disposed(by: self.bag)
        
        output?.currentAddressDescription
            .asDriver(onErrorJustReturn: "")
            .drive(self.cityNameLabel.rx.text)
            .disposed(by: self.bag)
        
        output?.isImageCached.subscribe { _ in }
        .disposed(by: self.bag)
        
        output?.currentAddressWebViewURL.subscribe(onNext: { [weak self] urlRequest in
            guard let urlRequest = urlRequest
            else {
                return
            }
                self?.webView.load(urlRequest)
            })
            .disposed(by: self.bag)
        
        output?.currentImage
            .asDriver(onErrorJustReturn: ImageCacheData(key: "", value: UIImage()))
            .filter { $0.value != UIImage() }
            .map { (imageCached) -> UIImage in
                return imageCached.value
            }
            .drive(self.imageView.rx.loadCacheView(webView: self.webView))
            .disposed(by: self.bag)
    }
    
    private func configureLayout() {
        self.addUIComponentsToStackView()
        let safeArea = view.safeAreaLayoutGuide
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.entireStackView)
        
        let webViewLayout: [NSLayoutConstraint] = [
            self.webView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 1.0),
            self.webView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.5)
        ]
        
        let cityNameLabelLayout: [NSLayoutConstraint] = [
            self.imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ]
        
        let descriptionLayout: [NSLayoutConstraint] = [
            self.weatherDescriptionTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.weatherDescriptionTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ]
        
        let imageViewLayout: [NSLayoutConstraint] = [
            self.imageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 1.0),
            self.imageView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.5),
            self.imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.imageView.topAnchor.constraint(
                equalTo: self.cityNameLabel.bottomAnchor,
                constant: 10
            ),
            self.imageView.bottomAnchor.constraint(
                equalTo: self.weatherDescriptionTextView.topAnchor,
                constant: 10
            )
        ]
        
        let stackViewLayout: [NSLayoutConstraint] = [
            self.entireStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.entireStackView.trailingAnchor.constraint(equalTo:safeArea.trailingAnchor),
            self.entireStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.entireStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ]
    
        NSLayoutConstraint.activate(webViewLayout)
        NSLayoutConstraint.activate(cityNameLabelLayout)
        NSLayoutConstraint.activate(descriptionLayout)
        NSLayoutConstraint.activate(imageViewLayout)
        NSLayoutConstraint.activate(stackViewLayout)
    }
    
    private func addUIComponentsToStackView() {
        self.entireStackView.addArrangedSubview(cityNameLabel)
        self.entireStackView.addArrangedSubview(webView)
        self.entireStackView.addArrangedSubview(weatherDescriptionTextView)
    }
    
    private func configureNavigationItem() {
        self.navigationItem.title = "?????? ??????"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: nil
        )
        self.refreshNavigationButton = self.navigationItem.leftBarButtonItem
        self.view.backgroundColor = .white
    }
}
