# ARoHa! with SwiftUI
> 건국대학교 증강현실 투어 iOS 어플리케이션 


![Pod Platform](https://img.shields.io/badge/Platform-iOS_13.0-brightgreen)
![Pod License](https://img.shields.io/badge/License-MIT-blue)
![Swift Version](https://img.shields.io/badge/Swift-5.1-blueviolet)

## 프로젝트 목표

#### 증강현실 기술을 활용하여 사용자에게 다양한 시각적인 정보를 제공하는 캠퍼스 탐방 및 스탬프 투어 어플리케이션 개발한다

## 개발 환경
- macOS Catalina 10.15.7
- Xcode 12.0.1
- iOS 14.0

## 사용한 프레임워크
- SwiftUI
- Combine

## 설치 및 사용법
- Cocoapod이 설치 되어 있지 않다면
```
# gem을 이용한 cocoapod 설치
$ sudo gem install cocoapods
```
- Cocoapod이 설치 되어 있을 경우
```
# Github 저장소에서 로컬에 소스코드 내려받기
$ git clone https://github.com/ARmera/ARoha_SwiftUI

# 내려받은 소스코드가 담긴 폴더로 이동
$ cd ARoha_SwiftUI

# cocoapod을 이용한 의존성 라이브러리 추가
$ pod install

# xcworkspace open 후 build
$ open Aroha_SwiftUI.xcworkspace
```

## dependency 

#### CocoaPods 1.9.3

```ruby
platform :ios, '9.0'

target 'SampleTarget' do
  use_frameworks!
  pod 'CocoaLumberjack/Swift'
  pod 'ARCL'
  pod 'AlamoFire'
end
```
