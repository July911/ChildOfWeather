import Foundation
import RxSwift

final class DefaultImageProvideRepository: ImageProvideRepository {
    
    private let service = CacheService()
    private var cacheKeys = BehaviorSubject<[String]>(value: [])
    
    func setCache(object: ImageCacheData) {
        let key = object.key as String
        
        guard var currentValue = try? cacheKeys.value()
        else {
            return
        }
        
        currentValue.append(key)
        cacheKeys.onNext(currentValue)
        self.service.cache.setObject(object, forKey: key as NSString)
    }
    
    func fetchCache(key: String) -> ImageCacheData? {
        self.service.cache.object(forKey: key as NSString)
    }
    
    func fetchAllCacheData() -> Observable<[ImageCacheData]>? {
        
        guard let currentValue = try? cacheKeys.value()
        else {
            return nil
        }
        
        var cachedData: [ImageCacheData] = [] 
        currentValue.forEach { key in
            guard let data = service.cache.object(forKey: key as NSString)
            else {
                return
            }
            cachedData.append(data)
        }
        
        return Observable.of(cachedData)
    }
}
