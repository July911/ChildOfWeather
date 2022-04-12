import Foundation

protocol ImageProvideRepository {
        
    var service: CacheService { get }
    
    func setCache(object: ImageCacheData)

    func getCache(key: String) -> ImageCacheData?
}
