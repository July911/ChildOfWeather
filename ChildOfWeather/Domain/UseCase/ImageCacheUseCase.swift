import Foundation

final class ImageCacheUseCase {
    
    private let imageProvideRepository: ImageProvideRepository
    
    init(imageProvideRepository: ImageProvideRepository) {
        self.imageProvideRepository = imageProvideRepository
    }

    func setCache(object: ImageCacheData) {
        self.imageProvideRepository.setCache(object: object)
    }
    
    func getImage(cityName: String) -> ImageCacheData? {
        self.imageProvideRepository.getCache(key: cityName)
    }
    
    func checkCacheExist(cityName: String) -> Bool {
        self.imageProvideRepository.getCache(key: cityName) == nil ? false : true
    }
}

