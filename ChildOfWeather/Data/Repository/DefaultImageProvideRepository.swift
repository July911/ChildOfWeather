import Foundation

final class DefaultImageProvideRepository: ImageProvideRepository {
    
    private let service = CacheService()
    
    func setCache(object: ImageCacheData) {
        let key = object.key
        self.service.cache.setObject(object, forKey: key as NSString)
    }
    
    func fetchCache(key: String) -> ImageCacheData? {
        self.service.cache.object(forKey: key as NSString)
    }
}
