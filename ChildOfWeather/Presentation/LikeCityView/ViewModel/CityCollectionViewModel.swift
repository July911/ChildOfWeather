import UIKit

struct CityCellViewModel: Hashable {
    
    let cityName: String
    let image: ImageCacheData
    let highTemperature: Double
    let lowTemperature: Double
    let identifier = UUID()
}
