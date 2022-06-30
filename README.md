# ChildOfWeather 

## 1. 프로젝트 기간: 2022.04.01 ~
## 2. 커밋 규칙
- 단위: 기능 단위
- 커밋 스타일: 카르마 스타일
## 3. Steps
- Step1 
>외부 라이브러리 없이 모든 기능 구현<br>
>목표: 이전까지 진행했던 프로젝트와는 다르게 라이브러리없이 구현하여 라이브러리 의존성을 낮춘다 
   
- Step2 
>테스트 코드 구현
          
- Step3 
>RxSwift를 import하여 단방향 바인딩<br>
>목표: RxSwift와 RxCocoa 사용, 클린아키텍쳐 규칙 준수 
          
- Step4 
>AppCoordinator를 사용해 의존성 주입 및 TabBarController 를 통한 화면전환<br>
>Compositional Layout을 사용한 CollectionView 및 DiffableDataSource활용<br>
>RxNimble을 활용한 ViewModel, UseCase 테스트 
        
## 4. 키워드      
`RxSwift`, `Clean Architecture MVVM`, `RxCocoa`, `Swift Package Manager` 
`Coordinator`, `WebView`, `Localization`

## 5. 목차 
- [Step1 라이브러리 없이 기본 구현](#step1-라이브러리-없이-기본-구현)
  * [Step1 PR후 개선사항](#step1-pr후-개선사항) 
  
- [Step2 테스트 코드](#step2-테스트-코드)
  * [Step2 PR후 개선사항](#step2-pr후-개선사항)
  
- [Step3 RxSwift 적용](#step3-rxswift-적용)
  * [Step3 PR후 개선사항](#step3-pr후-개선사항)

- [Step4 RxNimble을 통한 ViewModel 테스트](#step4-rxnimble을-통한-viewmodel-테스트)

- [트러블슈팅](#트러블슈팅)
  
## 6. 사용 
|도시 검색|검색창노출|
|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/90888402/175020931-6a8f8c4b-dd30-4523-99ec-5e1f0c714c91.gif" width="70%">|<img src="https://user-images.githubusercontent.com/90888402/175021189-bac1d416-d1b2-4597-bd82-55ac399ba58b.gif" width="70%">|

|날씨 정보|현재 위치 표시|
|:---:|:---:|
|<img src="https://user-images.githubusercontent.com/90888402/175023793-14a7cc2b-5051-4752-b5fe-bc25c6d7c8a7.gif" width="70%">|<img src="https://user-images.githubusercontent.com/90888402/175023653-06d7f182-d1b5-4676-bc4f-f7cabc08679e.gif" width="70%">|




----
# Step1 라이브러리 없이 기본 구현 

### API 통신 Generic 구현

```swift
final class APIService {
     func request<T: Decodable>(
      _ type: RequestType,
      completion: @escaping (Result<T, Error>) -> Void
    ) {
```

다른 URL로 서버에서 데이터를 받아올 상황을 대비하여 Generic으로 구현했습니다.

### ViewModel Delegate 구현
```swift
protocol DetailViewModelDelegate: AnyObject {
   func loadWebView(url: URL)
   func loadTodayDescription(weather description: String)
   func loadImageView()
   func cacheImage()
}
```
ViewModel은 ViewController를 알지 못하기에 Delegate 패턴을 사용하였습니다.

### Coordinator 구현
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

### 이미지 캐싱 구현
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


### CoreLocation 사용
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

### 웹뷰 구현 및 구글 지도 띄어주기
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

---

## 트러블슈팅
### SearchController

SearchController의 SearchResultsUpdater = self 로 해주지 않으면 ViewController에 채택을 하더라도 Delegate처럼 메서드가 적용되지 않았습니다.
SearchResultsController를 통하여 결과를 나타내주는 ViewController를 따로 지정해 줄 수 있다는 사실도 알게 되었습니다.

### UseCase의 Import UIKit
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

---

## Step1 PR후 개선사항

### Class Generic -> Method Generic
```swift
final class APIService {
       
   func request<T: Decodable>(
       _ type: RequestType,
       completion: @escaping (Result<T, Error>) -> Void
   ) {
```

하나의 APIService 인스턴스로 여러가지 Decodable 타입을 디코딩 할 수 있게 변경하였습니다.

---
# Step2 테스트 코드

### SystemUnderTest와 setUpWithError/ tearDownWithError 메서드로 테스트 사용성 개선

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

### 비동기 메서드 테스트
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

---
## Step2 PR후 개선사항

### 네트워크와 무관한 테스트
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

### LocationManager 공용 인스턴스 생성
```swift 
final class LocationManager {
    
    static let shared = LocationManager()
    let geocoder = CLGeocoder()
    let locationManager = CLLocationManager()
    
    private init() {
        
    }
```

기존 Repository -> UseCase -> ViewModel 까지 이어지던 흐름으로 CLGeocoder를 구현하였는데 , 데이터를 보관할 필요 없다는 점과 앱 전역적으로 매번 쓰이는 기능이라 생각이들어 CLGeocoder 인스턴스 생성비용이 데이터 영역에 계속 남아있는 싱글톤의 비용보다 크다 생각이 들어 LocationManager라는 공용 인스턴스를 두게 되었습니다. 이와 마찬가지로 Dateformatter 역시 인스턴스 생성 비용이 커서 공용 인스턴스로 만들어 성능과 편의성을 개선시켰습니다.

---
# Step3 RxSwift 적용

### Reactive Extension 으로 필요한 부분 구현
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

### Input & Output 모델링
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

### 함수형 프로그래밍 적용
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

---
## Step3 PR후 개선사항

### Input에서부터 이어지는 스트림
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

### 모든 구독은 ViewController에서 실행
```swift
  let dismiss = input.touchUpbackButton
      .withUnretained(self)
      .observe(on: MainScheduler.instance)
      .do(onNext: { _ in
          self.coordinator.occuredViewEvent(with: .dismissDetailShowUIViewController)
      }).map { _ in }
```
do(onNext:) 메서드를 사용하여, 구독이 되었을 때 실행할 메서드만 내부에 정의하고 모든 구독은 ViewController가 하게 구현했습니다. 개선 후 단방향으로 모든 메서드가 바인딩 되어 조금 더 RxSwift스럽게 코드가 개선되었습니다.

---
# Step4 RxNimble을 통한 ViewModel 테스트 

### 각 ViewModel 별로 setUp 메서드를 통한 독립적 테스트 

```swift
override func setUp() {
        self.schduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
        self.capturedPublish = PublishSubject<ImageCacheData>()
        self.viewWillAppearPusblish = PublishSubject<Void>()
        self.touchUpbackButtonPublish = PublishSubject<Void>()
        self.schduler = TestScheduler(initialClock: 0)
        self.viewModel = DetailWeatherViewModel(
            detailShowUseCase: DetailWeatherFetchUseCase(weatherRepository: DefaultWeatherRepository(service: MockAPIService())),
            imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository()),
            coodinator: SearchViewCoordinator(
                imageCacheUseCase: ImageCacheUseCase(imageProvideRepository: DefaultImageProvideRepository())),
                city: City.EMPTY
            )
            
        self.output = viewModel.transform(input: .init(viewWillAppear: self.viewWillAppearPusblish.asObserver(), capturedImage: self.capturedPublish.asObserver(), touchUpbackButton: self.touchUpbackButtonPublish.asObserver()))
    }
``` 
### Void 비교를 위한 메서드 추가 

```swift
public func equal<Void>(_ expectedValue: Void?) -> Predicate<Void> {
    return Predicate.define("equal <\(stringify(expectedValue))>") { actualExpression, msg in
        let actualValue = try actualExpression.evaluate()
        switch (expectedValue, actualValue) {
        case (nil, _?):
            return PredicateResult(status: .fail, message: msg.appendedBeNilHint())
        case (nil, nil), (_, nil):
            return PredicateResult(status: .fail, message: msg)
        default:
            var isEqual = false

            if String(describing: expectedValue).count != 0, String(describing: expectedValue) == String(describing: actualValue) {
                isEqual = true
            }
            return PredicateResult(bool: isEqual, message: msg)
        }
    }
```

### 각 상황별로 Test하여 ViewModel이 정상적으로 동작하는지 테스트 

```swift 
func testCapturedImage() {
        let imageCachedData = ImageCacheData(key: "123", value: UIImage())
        schduler.createColdObservable([
            .next(3, imageCachedData)
        ]).bind(to: self.capturedPublish).disposed(by: self.disposeBag)
        
        expect(self.output.cachedImage).events(scheduler: scheduler, disposeBag: self.disposeBag).to(equal([
            .next(4, imageCachedData)
        ]))
    }
```

```swift
 func testBackButtonRunDismiss() {
        scheduler.createColdObservable([
            .next(5, ())
        ]).bind(to: self.touchUpbackButtonPublish).disposed(by: self.disposeBag)
        
        expect(self.output.dismiss).events(scheduler: self.scheduler, disposeBag: self.disposeBag).to(equal([
            .next(5, ())
        ]))
    }
```

---

# 트러블슈팅 

## **<첫번째 문제: Domain Layer와 ViewModel에서 UIkit 을 import 하던 문제 >**

### **문제 상황**

- 한번 들어간 Cell의 DetailView의 화면을 매번 WebView로 띄어주게 된다면 사용자 경험이 좋지 않고 매번 URLRequest를 통해 불러와야해서 성능상의 불이익이 있습니다. WebView의 기능 중 ‘takeSnapshot’ 이라는 기능이 있는 것을 공식문서를 통해 찾아보고 UIImage로 변환하여 캐싱을 해주려고 했습니다.
- Dataformatter 처럼 인스턴스 생성 비용이 커 Singleton으로 메모리에 계속 남아있게 하는 것이 더 유리한 상황도 아니여서 Data Layer에 있는 Repository에 NSCache를 사용 할 수 있는 기능을 추가하였습니다.
- DataLayer → DomainLayer (UseCase) → ViewModel 모두 UIImage를 가지고 있어 모든 Layer가 import UIkit을 해야하는 상황이 생겼고 이는 클린아키텍쳐를 위반 할 뿐 아니라 테스트 시 불리하다는 판단을 하였습니다.

### **문제 해결 과정**

1. **UIImage의 Data만 받아서 전달하는 방법** 

      처음 생각했던 방법은 UIImage의 데이터만 ViewModel에서 받아오는 방법이었습니다. 

하지만 캐싱이 제대로 되지 않는 문제가 생겼고, ViewController에서 결국 이 데이터를 변환해서 UIImage로 사용해야 했습니다. 클린아키텍쳐 그리고 MVVM에서  ViewController는 최대한 수동적인 역할을 해야한다고 생각했기에 WebView처럼 부득이하게 load를 ViewController에서 해주는 경우가 아니면 지향해야 한다고 생각했습니다. 

2. **하나의 타입으로 묶는 방법** 

      그 다음으로 떠올린 방법은 현업에서 자주 사용하는 라이브러리 Kingfisher를 보고 참고하였는데, 하나의 타입 내부에 Key, Value 쌍을 두어 Value 값에 UIImage를 가지게 하는 방법이었습니다. 이 타입은 Domain Layer의 Model로 두어 클린아키텍쳐에 위반되지도 않은 뿐더러 캐싱이 잘 작동하는 지 역시도 테스트를 통해 확인 할 수 있었습니다. 

 또한 Data만 받아서 전달하던 이전과는 다르게 ViewModel이 보낸 타입의 value를 ViewController 내부에서 꺼내쓰기만 하면 되서 변환하지 않고 최대한 **수동적이게 ViewController를 유지**할 수 있었습니다. 

다른 사람의 코드를 보고 이해하는 연습을 해둔 이전까지의 경험이 이러한 문제를 빠르게 해결 할 수 있게 해주었던 것 같습니다. 

이러한 방법으로 사용자는 WebView가 로드되는 시간을 기다리지 않고 자주 들어가는 Cell의 지도를 UIImage로 바로 받아 볼 수 있게 되었습니다. 

## **< 두번째 문제: 이미지를 캐싱한 후 WebView를 UIImage로 대체하는 문제>**

### 문제 상황

- ViewModel의 Input & Output Modeling 중 Output은 Relay면 안된다라고 생각했습니다. 뷰를 그리는 작업이니 끊이지 않는 스트림인 Relay여도 되는 것 이라고 생각이 들었지만 그렇다면 ViewController는 ViewModel에서 온 Relay에 이벤트가 이닌 데이터를 전달 할 수 있게 됩니다. 이러한 접근은 MVVM과는 어울리지 않을 뿐더러 반응형 프로그래밍 답지 않은 접근이라고 생각했습니다.
- 위의 이유로 ViewModel의 Output을 Observable로 만들어 전달 한 후 ViewController가 asDriver 오퍼레이터를 통해 스트림을 Driver로 변경 한 후 drive를 통해 UIComponents에 데이터를 전달해주었습니다.
    
    이러한 상황에서 오퍼레이터 drive는 하나의 일 밖에 수행하지 않는다는 사실을 알게 되었고 drive(onNext:) 클로저를 사용하면 순환참조 문제를 일으킬 수 있어서 최대한 클로저를 지향하며 구현하고 싶었습니다. 하나의 스트림에서 WebView를 hide시켜주는 작업과 hide된 상태인 UIImageView를 화면에 띄어주어야 했습니다. 
    
    두번 subscribe하면 되지만, 이렇게 된다면 두개의 스트림이 생기고 캐싱된 이미지를 받아오는 과정이 2번 일어나게 됩니다. 
    

### 문제 해결 과정

1. **ViewModel에서 Share Operator를 사용하고 두번 구독하는 방법** 

     가장 먼저 떠올린 방법은 2번의 구독으로 인한 2개의 스트림이 생기는 것을 막아주는 것이었습니다. 하지만 매번 이러한 방식으로 하게 된다면 추후에 더 큰 프로젝트를 맡거나 진행하게 될 경우 데이터의 흐름을 추적하는 것이 어렵다고 생각이 들어 다른 방향으로 생각을 해보기로 했습니다. 

1. **Reactive Extension 활용** 

     RxSwift, RxCocoa를 사용하면서 ControlProperty, ControlEvent 그리고 Binder의 차이를 모른다면 안된다고 생각했습니다. 단순한 기능을 구현하는 것이 아니라 반응형 프로그래밍을 이해하고 사용한다면 개발자 본인의 라이브러리 의존성이 줄어드는 일이라고 생각하였고 이러한 생각을 기반으로 Reactive Extension을 통해 원하는 기능을 만들어보기로 했습니다. 

WebView를 hidden 상태로, ImageView의 Image에 ViewModel에서 오는 이미지를 넣어주고 화면에 표시해주는 커스텀 메서드를 구현하여 한번의 구독으로 모든 작업이 일어나게 했습니다.

이러한 경험을 바탕으로 ViewWillAppear 이벤트나 ViewWillDisappear 이벤트 역시도 스스로 ControlEvent로 구현하여 코드의 가독성을 향상시켰습니다. 

## **<세번째 문제: 초당 횟수제한이 걸린 API를 사용하여 TableView를 띄어주는 문제>**

### 문제상황

- API를 통해 네트워크 통신을 하여 100개의 TableView를 띄어주어야 하는데 초당 10건 제한이 걸려있어 이미지가 로딩중일때 화면이 표현되지 않았습니다.
- 커스텀 스케줄러를 만들어서 Semaphore Signal과 wait을 이용해 스케줄링을 해주었지만 실패했습니다.
- Cell의 이미지만 늦게 로드되는 문제를 해결하기 위해 cell에게 Observable<Data>를 전달해주고 Cell에서 구독을 해서 이미지를 받아오게 했습니다.

### 문제 해결 과정

- 초당 10건 제한이라 100개를 띄우려면 총 10초가 필요한 상황입니다. 네트워크 통신을 하는 Observable에 retry Operator를 통해서 flatMap으로 Observable<Int> 형인 Timer로 바꿔주었습니다. 그리고 타이머의 period를 0.1초로 두어 네트워크 통신을 해주었습니다.
- 이미지가 뒤섞이는 문제가 발생하여 DispatchQueue를 사용한 IndexPath 검증으로 해당하는 index일 때만 Cell에 content를 주게 하였습니다.
- Cell의 PrepareForReuse 안에서 dispose를 해주어 이미지가 로딩중인데 스크롤을 내려서 더 이상 Observable한 Data를 받아오지 않아도 될 경우에 메모리 누수를 개선시켰습니다.
