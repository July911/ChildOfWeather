import Foundation
import UIKit

final class DefaultImageProvideRepository: ImageProvideRepository {
    
    private let cache: NSCache = NSCache<NSString, UIImage>()
    
    func setCache(text: String, image: UIImage) {
        cache.setObject(image, forKey: text as NSString)
#if DEBUG
        print("\(text) 데이터 세팅함")
#endif
    }
    
    func getCache(text: String) -> UIImage? {
        guard let image = cache.object(forKey: text as NSString)
        else {
            return nil
        }
#if DEBUG
        print("\(text) 데이터 가져감")
#endif
        return image
    }
}
