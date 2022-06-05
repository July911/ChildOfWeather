import RxSwift
import UIKit
import RxCocoa
import WebKit

extension Reactive where Base: UIViewController {
    
    var viewWillAppear: ControlEvent<Void> {
        let viewWillAppearEvent = self.methodInvoked(#selector(base.viewWillAppear(_:))).map { _ in }
        
        return ControlEvent(events: viewWillAppearEvent)
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        let viewWillDisappear = self.methodInvoked(#selector(base.viewWillDisappear(_:))).map { _ in }
        
        return ControlEvent(events: viewWillDisappear)
    }
    
    var viewDidLoad: ControlEvent<Void> {
        let viewDidLoad = self.methodInvoked(#selector(base.viewDidLoad)).map { _ in }
        
        return ControlEvent(events: viewDidLoad)
    }
    
    var viewWillDisspear: ControlEvent<Void> {
        let viewWillDissapear = self.methodInvoked(#selector(base.viewWillDisappear(_:))).map { _ in }
        
        return ControlEvent(events: viewWillDissapear)
    }
}

extension Reactive where Base: WKWebView {
    
    func takeSnapShot(name: String) -> Observable<ImageCacheData> {
        return Observable<ImageCacheData>.create { emitter in
            let configuration = WKSnapshotConfiguration()
            base.takeSnapshot(with: configuration) { image, error in
                guard error == nil
                else {
                    emitter.onError(APICallError.dataNotfetched)
                    return
                }
                
                guard let image = image
                else {
                    emitter.onError(APICallError.errorExist)
                    return
                }
                let imageCacheData = ImageCacheData(key: name as NSString, value: image)
                emitter.onNext(imageCacheData)
                emitter.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}

extension Reactive where Base: UIImageView {
    
    func loadCacheView(webView: WKWebView) -> Binder<UIImage> {
        return Binder(self.base) { ImageView, image in
            webView.isHidden = true
            base.isHidden = false
            ImageView.image = image
        }
    }
}
