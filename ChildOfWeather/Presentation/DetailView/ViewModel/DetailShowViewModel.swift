import Foundation

final class DetailShowViewModel {
    
    let detailShowUseCase: DetailShowUseCase
    let coordinator: MainCoordinator
    weak var delegate: DetailViewModelDelegate?
    
    init(detailShowUseCase: DetailShowUseCase, coodinator: MainCoordinator) {
        self.detailShowUseCase = detailShowUseCase
        self.coordinator = coodinator
    }
}

protocol DetailViewModelDelegate: AnyObject {
    
}
