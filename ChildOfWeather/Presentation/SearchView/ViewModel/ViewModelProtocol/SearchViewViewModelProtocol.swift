import Foundation

protocol SearchViewViewModelProtocol {
    
    associatedtype Input
    associatedtype Output
    
    var filterdResults: [City]? { get set }
    var delegate: SearchViewModelDelegate? { get set }
    
    func configureLoactionLists(_ text: String?)
    
    func occuredCellTapEvent(city: City)
    
    func transform(input: Input) -> Output 
}
