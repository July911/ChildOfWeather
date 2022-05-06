import UIKit

final class ImageCacheData: Hashable, Equatable {
    
    let key: NSString
    let value: UIImage
    
    init(key: NSString, value: UIImage) {
        self.key = key
        self.value = value
    }
    
    static func == (lhs: ImageCacheData, rhs: ImageCacheData) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(key)
            hasher.combine(value)
        }
    
}
