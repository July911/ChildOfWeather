import Foundation
import RxSwift

protocol ImageProvideRepository {
            
    func setCache(object: ImageCacheData)

    func fetchCache(key: String) -> ImageCacheData?
    
    func fetchAllCacheData() -> Observable<[ImageCacheData]>
}
