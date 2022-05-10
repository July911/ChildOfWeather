import Foundation

final class DefaultImageProvideRepository: ImageProvideRepository {
    
    private let service = CacheService()
    private var cacheKeys: [NSString] = []
    
    func setCache(object: ImageCacheData) {
        let key = object.key
        cacheKeys.append(key)
        self.service.cache.setObject(object, forKey: key as NSString)
    }
    
    func fetchCache(key: String) -> ImageCacheData? {
        self.service.cache.object(forKey: key as NSString)
    }
    
    func fetchAllCacheData() -> [ImageCacheData] {
        var cachedData: [ImageCacheData] = [] 
        cacheKeys.forEach { key in
            guard let data = service.cache.object(forKey: key)
            else {
                return
            }
            cachedData.append(data)
        }
        
        return cachedData
    }
}
