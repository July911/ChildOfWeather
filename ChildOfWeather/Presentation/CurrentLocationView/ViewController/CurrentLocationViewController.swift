import UIKit
import RxSwift
import RxCocoa

final class CurrentLocationViewController: UIViewController {
    
    var viewModel: CurrentLocationViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        let input = CurrentLocationViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            cachedImage: <#T##Observable<ImageCacheData>?#>,
            locationChange: <#T##Observable<Bool>#>,
            dismiss: <#T##Observable<Void>#>
        )
        
        let output = self.viewModel?.transform(input: input)
    }
}
