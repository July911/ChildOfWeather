import Foundation

final class DetailShowViewModel {
    
    let detailShowUseCase: DetailShowUseCase
    let coordinator: MainCoordinator
    
    init(detailShowUseCase: DetailShowUseCase, coodinator: MainCoordinator) {
        self.detailShowUseCase = detailShowUseCase
        self.coordinator = coodinator
    }
}
