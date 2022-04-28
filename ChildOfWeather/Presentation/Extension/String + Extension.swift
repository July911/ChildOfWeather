import UIKit
// MARK: - AttributedString
extension String {
    
    var toBoldFontForTitle: NSMutableAttributedString {
        let attribute = NSMutableAttributedString(string: self)
        attribute.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .title3), range: NSMakeRange(0, attribute.length))
        return attribute
    }
    
    var toBoldFontForText: NSMutableAttributedString {
        let attribute = NSMutableAttributedString(string: self)
        attribute.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: NSMakeRange(0, attribute.length))
        return attribute
    }
}
// MARK: - Localization
extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

