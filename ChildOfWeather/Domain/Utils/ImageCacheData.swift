import UIKit

final class ImageCacheData {
    
    let key: NSString
    let value: UIImage
    
    init(key: NSString, value: UIImage) {
        self.key = key
        self.value = value
    }
}
