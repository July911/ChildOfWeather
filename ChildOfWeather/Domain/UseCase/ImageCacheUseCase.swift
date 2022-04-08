import Foundation
import UIKit

final class ImageCacheUseCase {
    
    let imageProvideRepository: ImageProvideRepository
    
    init(imageProvideRepository: ImageProvideRepository) {
        self.imageProvideRepository = imageProvideRepository
    }

    func cache(cityName: String, image: UIImage) {
        if self.checkCacheExist(cityName: cityName) {
            self.imageProvideRepository.setCache(text: cityName, image: image)
        }
    }
    
    func getImage(cityName: String) -> UIImage? {
        self.imageProvideRepository.getCache(text: cityName)
    }
    
    func checkCacheExist(cityName: String) -> Bool {
        self.imageProvideRepository.getCache(text: cityName) == nil ? false : true
    }
}
