import Foundation

enum Country {
    
    case kr
    case eu
    case us
    
    var description: String {
        switch self {
        case .kr:
            return "KR"
        case .eu:
            return "EU"
        case .us:
            return "US"
        }
    }
}
