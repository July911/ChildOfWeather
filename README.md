# 🌈 ChildOfWeather 🌞 

0. 참여자:   July 

1. 프로젝트 기간: 2022.04.01 ~

2. 커밋 규칙

- 단위:
      기능 단위

- 커밋 스타일: 
      카르마 스타일


3. Steps
- Step1 

          외부 라이브러리 없이 모든 기능 구현 
          목표: 이전까지 진행했던 프로젝트와는 다르게 라이브러리없이 구현하여 라이브러리 의존성을 낮춘다    
- Step2 

          테스트 코드 구현 
          
- Step3 

          RxSwift를 import하여 단방향 바인딩 
          목표: RxSwift와 RxCocoa 사용, 클린아키텍쳐 규칙 준수 
          
- Step4 

        AppCoordinator를 사용해 의존성 주입 및 TabBarController 를 통한 화면전환
        Compositional Layout을 사용한 CollectionView 및 DiffableDataSource활용
        
4. 키워드 
        
        RxSwift, Clean Architecture MVVM, RxCocoa, Swift Package Manager
        Coordinator, WebView, Localization 
       
5. 사용 

### 기본화면 
<img src="https://user-images.githubusercontent.com/90888402/166178392-2bc5259f-74b3-420b-85c7-51aed551c44a.png" width="25%">

### 검색창 노출 
<img src="https://user-images.githubusercontent.com/90888402/166178405-b194b4c8-aa3e-4b0a-9b27-f375f559e021.png" width="25%">

### 검색 
<img src="https://user-images.githubusercontent.com/90888402/166178412-fb3d1b34-8b5b-4739-9d1d-b3503be1c4c0.png" width="25%">

### 도시 상세 정보 
<img src="https://user-images.githubusercontent.com/90888402/166178421-e33ad6fc-185b-47e9-a5c7-efd5ae83084a.png" width="25%">

# Step1 

### 🐥 API 통신 Generic 구현

```swift
final class APIService {
     func request<T: Decodable>(
      _ type: RequestType,
      completion: @escaping (Result<T, Error>) -> Void
    ) {
```

다른 URL로 서버에서 데이터를 받아올 상황을 대비하여 Generic으로 구현했습니다.

### 🐥 ViewModel Delegate 구현
```swift
protocol DetailViewModelDelegate: AnyObject {
   func loadWebView(url: URL)
   func loadTodayDescription(weather description: String)
   func loadImageView()
   func cacheImage()
}
```
ViewModel은 ViewController를 알지 못하기에 Delegate 패턴을 사용하였습니다.

### 🐥 Coordinator 구현
```swift
final class MainCoordinator {

    private let navigationController: UINavigationController
    private let imageCacheUseCase = ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository())
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
 ```
뷰와 뷰사이의 이동을 담당하는 Coordinator를 두어 더 이상 ViewController가 뷰를 띄어주는 역할을 하지 않게 구현했습니다.
또한 Coordinator 의 저장프로퍼티와 메서드 내부의 지역변수로 각 ViewController 와 ViewModel의 프로퍼티의 의존성을 주입해주었습니다. 
저장프로퍼티와 지역변수로 다르게 주입시켜주는 이유는 ViewModel 이 캐시처럼 같은 Repository의 인스턴스를 바라보아야 하는 경우와 다른 정보를 가지고 있어서 다른 인스턴스의 Repository를 바라보아야 하는 경우가 있어 생명주기를 다르게 해주었습니다.

### 🐥 이미지 캐싱 구현
```swift
final class DefaultImageProvideRepository: ImageProvideRepository {
   
   let service = CacheService()
   
   func setCache(object: ImageCacheData) {
       let key = object.key
       self.service.cache.setObject(object, forKey: key as NSString)
   }
   
   func getCache(key: String) -> ImageCacheData? {
       self.service.cache.object(forKey: key as NSString)
   }
}
```
WebView로 지도를 띄어주고 지역상세 페이지에 들어가면 캐싱되는 형태로 구현되어있어 NSCache를 사용하였습니다.

### 🐥 CoreLocation 사용
```swift
import CoreLocation

final class LocationSearchUseCase {
    
    func searchLocation(
        latitude: Double,
        longitude: Double,
        completion: @escaping (String?) -> Void
    ) {
        let findLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "en-US")
        
        geocoder.reverseGeocodeLocation(
                findLocation,
                preferredLocale: locale) { (place, error) in
                    let city = place?.last?.name
                    completion(city)
            }
    }
}
```
CoreLocation의 CLLocation을 사용하여 위경도를 받아와 현재 위치를 결과로 받아왔습니다.

### 🐥 웹뷰 구현 및 구글 지도 띄어주기
```swift
private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
 ```
WebView를 WKWebView를 사용하여 띄어주었습니다. 위의 위경도를 통해 받은 주소를 통해 구글에서 주소를 검색한 결과를 보여주게 했습니다. 또한 takeSnapShot 메서드를 통해 UIImage로 변환하여 이 이미지를 캐싱했습니다.

## 😂 트러블슈팅
### 🐣 SearchController

SearchController의 SearchResultsUpdater = self 로 해주지 않으면 ViewController에 채택을 하더라도 Delegate처럼 메서드가 적용되지 않았습니다.
SearchResultsController를 통하여 결과를 나타내주는 ViewController를 따로 지정해 줄 수 있다는 사실도 알게 되었습니다.

### 🐣 UseCase의 Import UIKit
```swift
final class ImageCacheData {
  
  let key: NSString
  let value: UIImage
  
  init(key: NSString, value: UIImage) {
      self.key = key
      self.value = value
  }
}
```

UseCase 단에서 UIKit이 Import 되어있으면 안된다고 생각하여 ImageCacheData 라는 객체로 캐싱해주었습니다.

캐싱을 도와주는 라이브러리인 KingFisher 의 구현코드 에서도 객체 자체를 캐싱해주는 것을 참고하였습니다.

## 🐣 PR후 수정사항

### 🐣 Class Generic -> Method Generic
```swift
final class APIService {
       
   func request<T: Decodable>(
       _ type: RequestType,
       completion: @escaping (Result<T, Error>) -> Void
   ) {
```

하나의 APIService 인스턴스로 여러가지 Decodable 타입을 디코딩 할 수 있게 변경하였습니다.

# Step2 테스트 코드

### 🐣 SystemUnderTest와 setUpWithError/ tearDownWithError 메서드로 테스트 사용성 개선

매번 인스턴스를 생성해주며 테스트하기 보다는 파일 분리와 sut의 활용으로
```swift
 var sut: DetailShowUseCase?

    override func setUpWithError() throws {
        let repository = DefaultWeatherRepository(service: MockAPIService())
        sut = DetailShowUseCase(weatherRepository: repository)
    }

    override func tearDownWithError() throws {
        sut = nil 
    }
```
각 테스트마다 새로 인스턴스 생성과 deinit을 해주어 테스트가 편해지게 구현하였습니다.

### 🐣 비동기 메서드 테스트
```swift
 func test_AddressSearchUseCase_이매동_위경도를_입력했을때_이매동_주소가_나온다() {
        let imaelatitude = 37.39508700000
        let imaelongitude = 127.12415500000
     
        let promise = expectation(description: "")
        self.sut?.searchLocation(latitude: imaelatitude, longitude: imaelongitude) { (address) in
            XCTAssertEqual(address!, "153-2 Imae-dong")
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 3)
    }
```  
promised와 fulfill 그리고 wait 을 사용하여 비동기 메서드를 테스트하였습니다.

## 🐣 PR후 개선사항

### 🐣네트워크와 무관한 테스트
```swift
  var sut: DetailShowUseCase?

    override func setUpWithError() throws {
        let repository = DefaultWeatherRepository(service: APIService()
``` 
네트워크의 상황에 맞춰서 테스트 하던 부분을
```swift
@testable import ChildOfWeather

final class MockAPIService: URLSessionNetworkService {
   
   func request<T>(decodedType: T.Type, requestType: RequestType, completion: @escaping (Result<T, APICallError>) -> Void) where T : Decodable {
       
       guard let mockObject = try? JSONDecoder().decode(T.self, from: Data())
       else {
           return completion(.failure(APICallError.failureDecoding))
       }
       
       completion(.success(mockObject))
   }
}
```
TestDouble을 사용하여 네트워크와 무관한 테스트로 만들었습니다.

### 🐣 LocationManager 공용 인스턴스 생성
```swift 
final class LocationManager {
    
    static let shared = LocationManager()
    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    private init() {
        
    }
```

기존 Repository -> UseCase -> ViewModel 까지 이어지던 흐름으로 CLGeocoder를 구현하였는데 , 데이터를 보관할 필요 없다는 점과 앱 전역적으로 매번 쓰이는 기능이라 생각이들어 CLGeocoder 인스턴스 생성비용이 데이터 영역에 계속 남아있는 싱글톤의 비용보다 크다 생각이 들어 LocationManager라는 공용 인스턴스를 두게 되었습니다. 이와 마찬가지로 Dateformatter 역시 인스턴스 생성 비용이 커서 공용 인스턴스로 만들어 성능과 편의성을 개선시켰습니다.

# 🐣 Step3 RxSwift 적용

### 🐣 Reactive Extension 으로 필요한 부분 구현
```swift
private extension Reactive where Base: UIImageView {
    func loadCacheView(webView: WKWebView) -> Binder<UIImage> {
        return Binder(self.base) { ImageView, image in
            webView.isHidden = true
            base.isHidden = false
            ImageView.image = image
        }
    }
}
```
RxCocoa를 사용하면서, 있는 메서드만 사용하는 것이 아니라 Reactive Extension을 통해 원하는 기능을 담은 메서드를 만들어서 사용해보았습니다. 이러한 과정에서 ControlProperty와 ControlEvent 그리고 Binder의 차이에 대해 고민해보았습니다.

### 🐣 Input & Output 모델링
```swift
 struct Input {
        let viewWillAppear: Observable<Void>
        let capturedImage: Observable<ImageCacheData>
        let touchUpbackButton: Observable<Void>
    }
    
    struct Output {
        let selectedURLForMap: Observable<URLRequest?>
        let cachedImage: Observable<ImageCacheData>?
        let weatehrDescription: Observable<String>
        let capturedSuccess: Observable<Void>
        let dismiss: Observable<Void>
    }
```
이전 RxSwift 없이 구현했을때와는 다르게 Input 이벤트와 Output의 정보를 Nested Type으로 구현하여 코드의 직관성을 개선하고 하나의 인터페이스로 ViewController와 소통할 수 있게 구현했습니다.

### 🐣 함수형 프로그래밍 적용
```swift 
 func search(name: String?) -> Observable<[City]> {
        
        guard let name = name, name != ""
        else {
            self.fetchCityList()
            return self.assetData.asObservable()
        }
        let filteredCity = assetData.value.filter { $0.name.hasPrefix(name) }
        
        return Observable<[City]>.just(filteredCity)
    }
```
원본 데이터는 유지한상태로 SearchBar의 Search를 리턴값이 있는 상태로 구현하여 몇번을 시도해도 값이 변하지 않게 구현했습니다.

## 🐣 PR후 개선사항

### 🐣 Input에서부터 이어지는 스트림
```swift
  let capturedSuccess = input.capturedImage
            .withUnretained(self)
            .filter { _ in
                self.imageCacheUseCase.hasCacheExist(cityName: self.extractCity().name) == false }
            .do(onNext: { (self, image) in
                self.imageCacheUseCase.setCache(object: image)
            }).map { _ in }
 ```
Output으로 보내주는 스트림이 Input의 이벤트부터 시작하게 하였습니다. 이를 통해서 사용자 이벤트 -> 처리 -> 구독 의 자연스러운 흐름을 만들었습니다.

### 🐣 모든 구독은 ViewController에서 실행
```swift
  let dismiss = input.touchUpbackButton
      .withUnretained(self)
      .observe(on: MainScheduler.instance)
      .do(onNext: { _ in
          self.coordinator.occuredViewEvent(with: .dismissDetailShowUIViewController)
      }).map { _ in }
```
do(onNext:) 메서드를 사용하여, 구독이 되었을 때 실행할 메서드만 내부에 정의하고 모든 구독은 ViewController가 하게 구현했습니다. 개선 후 단방향으로 모든 메서드가 바인딩 되어 조금 더 RxSwift스럽게 코드가 개선되었습니다.
