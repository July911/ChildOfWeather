import RxSwift
import UIKit
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var viewWillAppear: ControlEvent<Void> {
        let viewWillAppearEvent = self.methodInvoked(#selector(base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: viewWillAppearEvent)
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        let viewWillDisappear = self.methodInvoked(#selector(base.viewWillDisappear(_:))).map { _ in }
        return ControlEvent(events: viewWillDisappear)
    }
}
