import Foundation

final class DefaultImageProvideRepository: ImageProvideRepository {
    
    let service = CacheService()
    
    func setCache(object: ImageCacheData) {
        let key = object.key
        self.service.cache.setObject(object, forKey: key as NSString)
    }
    
    func getCache(key: String) -> ImageCacheData? {
        self.service.cache.object(forKey: key as NSString)
    }
}
