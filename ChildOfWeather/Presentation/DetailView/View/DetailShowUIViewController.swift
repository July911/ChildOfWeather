import UIKit

final class DetailShowUIViewController: UIViewController {
    
    var viewModel: DetailShowViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViewModelDelegate()
    }
    
    private func configureViewModelDelegate() {
        self.viewModel?.delegate = self
    }
}

extension DetailShowUIViewController: DetailViewModelDelegate {
    
}
