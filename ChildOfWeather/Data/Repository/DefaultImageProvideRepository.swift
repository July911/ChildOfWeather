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
    
    func fetchAllCacheData() -> Observable<[ImageCacheData]> {
        let cachedData = cacheKeys.asObservable().map { strings in
            strings.compactMap { self.fetchCache(key: $0) }
        }.debug()
        
        return cachedData
    }
}
