import Foundation

final class ImageCacheUseCase {
    
    private let imageProvideRepository: ImageProvideRepository
    
    init(imageProvideRepository: ImageProvideRepository) {
        self.imageProvideRepository = imageProvideRepository
    }

    func setCache(object: ImageCacheData) {
        self.imageProvideRepository.setCache(object: object)
    }
    
    func fetchImage(cityName: String) -> ImageCacheData? {
        guard hasCacheExist(cityName: cityName)
        else {
            return nil
        }
        return self.imageProvideRepository.fetchCache(key: cityName)
    }
    
    func hasCacheExist(cityName: String) -> Bool {
        self.imageProvideRepository.fetchCache(key: cityName) == nil ? false : true
    }
}

