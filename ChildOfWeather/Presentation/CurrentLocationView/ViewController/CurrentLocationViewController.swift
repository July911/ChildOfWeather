import UIKit
import RxSwift
import RxCocoa
import WebKit

final class CurrentLocationViewController: UIViewController {
// MARK: - Properties 
    var viewModel: CurrentLocationViewModel?
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
    
    private let refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("위치 새로고침", for: .focused)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
    }
// MARK: - Private Method
    private func bindViewModel() {
        let input = CurrentLocationViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            cachedImage: <#T##Observable<ImageCacheData>?#>,
            locationChange: <#T##Observable<Bool>#>,
            dismiss: <#T##Observable<Void>#>
        )
        
        let output = self.viewModel?.transform(input: input)
    }
    
    private func configureLayout() {
        self.addUIComponentsToStackView()
        self.view.addSubview(entireStackView)
        
        let stackViewLayout: [NSLayoutConstraint] = [
        
        ]
        
        NSLayoutConstraint.activate(stackViewLayout)
    }
    
    private func addUIComponentsToStackView() {
        self.entireStackView.addArrangedSubview(cityNameLabel)
        self.entireStackView.addArrangedSubview(webView)
        self.entireStackView.addArrangedSubview(weatherDescriptionTextView)
        self.entireStackView.addArrangedSubview(refreshButton)
    }
}
