import Foundation

protocol SearchViewViewModelProtocol {
    
    var filterdResults: [City]? { get set }
    var delegate: SearchViewModelDelegate? { get set }
    
    func configureLoactionLists(_ text: String?)
    
    func occuredCellTapEvent(city: City)
}
