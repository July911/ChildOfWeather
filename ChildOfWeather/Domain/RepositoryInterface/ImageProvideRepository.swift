import Foundation

protocol ImageProvideRepository {
        
    var service: CacheService { get }
    
    func setCache(object: ImageCacheData)

    func fetchCache(key: String) -> ImageCacheData?
}
