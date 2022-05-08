import UIKit
import RxSwift
import RxCocoa
import WebKit

final class CurrentLocationViewController: UIViewController {
// MARK: - Properties 
    var viewModel: CurrentLocationViewModel?
    private var refreshNavigationButton: UIBarButtonItem?
// MARK: - UI Components
    private let cityNameLabel: UILabel = {
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
    
    private let weatherDescriptionTextView: UITextView = {
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
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
// MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.configureLayout()
        self.configureNavigationItem()
    }
// MARK: - Private Method
    private func bindViewModel() {
        guard let leftBarButtonEvent = self.refreshNavigationButton?.rx.tap.asObservable()
        else {
            return
        }
        let input = CurrentLocationViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            cachedImage: nil,
            locationChange: leftBarButtonEvent,
            dismiss: self.rx.viewWillDisappear.asObservable()
        )
        
        let output = self.viewModel?.transform(input: input)
    }
    
    private func configureLayout() {
        self.addUIComponentsToStackView()
        let safeArea = view.safeAreaLayoutGuide
        self.view.addSubview(entireStackView)
        
        let webViewLayout: [NSLayoutConstraint] = [
            self.webView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4),
            self.webView.heightAnchor.constraint(equalTo: self.webView.widthAnchor)
        ]
        
        let imageViewLayout: [NSLayoutConstraint] = [
            self.imageView.widthAnchor.constraint(equalTo: self.webView.widthAnchor, multiplier: 1.0),
            self.imageView.heightAnchor.constraint(equalTo: self.webView.heightAnchor)
        ]
        
        let stackViewLayout: [NSLayoutConstraint] = [
            self.entireStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.entireStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.entireStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.entireStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(webViewLayout)
        NSLayoutConstraint.activate(imageViewLayout)
        NSLayoutConstraint.activate(stackViewLayout)
    }
    
    private func addUIComponentsToStackView() {
        self.entireStackView.addArrangedSubview(cityNameLabel)
        self.entireStackView.addArrangedSubview(webView)
        self.entireStackView.addArrangedSubview(weatherDescriptionTextView)
    }
    
    private func configureNavigationItem() {
        self.navigationController?.navigationItem.title = "현재 위치"
        self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        self.refreshNavigationButton = self.navigationController?.navigationItem.leftBarButtonItem
    }
}
