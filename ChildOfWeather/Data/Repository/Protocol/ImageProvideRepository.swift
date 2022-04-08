import Foundation
import UIKit

protocol ImageProvideRepository {
    
    func setCache(text: String, image: UIImage) 

    func getCache(text: String) -> UIImage?

}
