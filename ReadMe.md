- Model

  - Swift에서는 CamelCase가 컨벤션입니다. [참고](https://swift.org/documentation/api-design-guidelines/)

    - Names of types and protocols are `UpperCamelCase`. Everything else is `lowerCamelCase`. 

  - ~~(지극히 **개인적인** 제안)~~ 기현님이 정의한 방향에 더불어 ImageURLs 구조체를 열거형으로 정의해보는 방향도 있을 듯 합니다. 이 방식으로 정의하면  `urls[.regular]` 로 활용 가능합니다. 

    ```swift
    let urls: [Size: URL]
    
    enum Size: String, Decodable {
      case raw
      case full
      case regular
      case small
      case thumb
    }
    ```

  - ViewModel 파일 상단에  `UIImage` 를 `ImageForCell` 로 감싸서 사용한 이유가 불분명합니다.  

- Network

  - 공통적인 API 통신 레이어를 설계해보는 것도 좋을 듯 합니다.
  - `getImageData()` 내부에 정의한 `noDataAvailable` 외에 나머지 에러는 핸들링이 되고 있지 않은데, 만약 디버그 용도의 catch였다면 (차후의) 과제 제출 시에는 삭제하거나 ` #if DEBUG` 등의 플래그로 구분해준다면 좋은 인상을 줄 것 같습니다.
  - Configurations 디렉토리 하위 파일들의 명확한 용도가 드러나지 않아 아쉬웠습니다. 이 내용을 네트워킹 레이어에 녹여서 활용할 수 있도록 설계하면 좋을 것 같습니다.

- Library

  - `PinterestLayout` 를 프로젝트 내에 인소스해서 사용하셨는데, CocoaPods이나 SPM(Swift Package Manager) 등을 사용해서 외부 라이브러리 의존성을 관리하는 방향이 버전 관리나 의도치 않은 코드 수정을 막을 수 있어 좋습니다.

- View

  - 프로젝트 생성 초기에 `ViewController`가 기본으로 생성되지만 역할을 알 수 있도록 네이밍을 변경해주면 더 명확해보일 듯 합니다. 
  - 뷰 컨트롤러 내부의 프로퍼티나 메소드에 대해 적절한 접근제어자를 명시해주면 좋습니다.
  - viewModel의 `reloadData`나 `showLoading` 등의 클로저에 self를 캡쳐해서 넘겨줄 때, 순환 참조 관계를 파악하여 `weak` 키워드를 사용해 햇지해주도록 합니다. (PinterestLayout 내부 delegate 선언 부 참고)
  - `fetchNextPage()` 내부에서 옵셔널 값인 searchText에 접근할 때 옵셔널 값을 언래핑해서 사용하는 것이 안전합니다.

- 추천 공부 자료

  - [Swift](https://swift.org/documentation/)

  - [모바일 개발자 로드맵](https://github.com/godrm/mobile-developer-roadmap)
  - [부스트코스](https://www.edwith.org/boostcourse-ios)
  - [Raywenderlich](https://www.raywenderlich.com/)