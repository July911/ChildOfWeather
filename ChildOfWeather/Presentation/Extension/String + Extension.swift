import UIKit

extension String {
    var toBoldFont: NSMutableAttributedString {
        let attribute = NSMutableAttributedString(string: self)
        attribute.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 30), range: NSMakeRange(0, attribute.length))
        return attribute
    }
}
