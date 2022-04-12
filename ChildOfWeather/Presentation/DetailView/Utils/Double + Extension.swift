import Foundation

extension Int {
    
    func toKoreanTime() -> String {
        let time = Date(timeIntervalSince1970: TimeInterval(self))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH: mm"
        return formatter.string(from: time)
    }
}
