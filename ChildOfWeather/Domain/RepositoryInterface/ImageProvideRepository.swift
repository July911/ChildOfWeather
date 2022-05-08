import Foundation

protocol ImageProvideRepository {
            
    func setCache(object: ImageCacheData)

    func fetchCache(key: String) -> ImageCacheData?
    
    func fetchAllCacheData() -> [ImageCacheData] 
}
