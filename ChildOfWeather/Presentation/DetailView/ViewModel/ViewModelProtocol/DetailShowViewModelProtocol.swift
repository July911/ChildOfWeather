import Foundation

protocol DetailShowViewModelProtocol {
    
    associatedtype Input
    associatedtype Output
    
    var delegate: DetailViewModelDelegate? { get set }
    var city: City { get }
    
    func extractURLForMap()
    
    func cache(object: ImageCacheData)
    
    func extractCache(key: String) -> ImageCacheData?
    
    func extractWeatherDescription()
    
    func loadCacheImage()
    
    func occuredBackButtonTapEvent()
    
    func transform(input: Input) -> Output
}
