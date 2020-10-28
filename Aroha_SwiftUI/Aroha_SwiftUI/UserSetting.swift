//
//  UserEnvironmetData.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import Alamofire
import ARCL

var test:Data? = nil
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

//AllRouteInfo : 서버에서 가져오는 모든 Route, Ex) 1번(),2번(자연 경로),3번 기타 등등
var AllRouteInfo:[RouteInfo] = [RouteInfo]()
//AllBeaconInfo : 서버에서 가져오는 모든 Beacon
var AllBeaconInfo:[BeaconSummaryInfo] = [BeaconSummaryInfo]()
//TodaysWeather : 서버에서 가지고 온 오늘의 날씨
var TodaysWeather:WeatherInfo = WeatherInfo(weather: "", dust: "")
//updateProperty : Property Update
var updateProperty:Bool = false
var updateUILabel:Bool = false
var UILabelString:String = ""
var LabelCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
class UserSettings:ObservableObject{
    //scene_instance : scene 관리
    @Published var scene_instance:SceneLocationView?;
    //isLogin : 로그인 여부
    @Published var isLogin = false;
    //tabselected : 탭 선택(1번 탭,2번탭,3번 탭,4번 탭)
    @Published var tabselected = 0;
    //currentRouteList : 현재 route의 Point의 coordinates 배열
    @Published var currentRouteList:[Pos] = [Pos](){
        didSet{
            
        }
    }
    @Published var sign_num:Int = 1
    //currentRouteProperties : 현재 route의 Point의 properties(turntype) 배열
    @Published var currentRouteProperties:[[String:Any]] = [[String:Any]](){
        didSet{
            updateProperty = true
            print("current : \(currentRouteProperties.count)")
        }
    }
    
    
    //UserSelected : 현재 선택된 route 혹은 beacon
    @Published var UserSelectedRoute:String = "건국대학교"
    //RouteBeaconList : 현재 선택된 route의 Beacon
    @Published var RouteBeaconList:[BeaconInfo] = [BeaconInfo]()
    //RouteAnnotations : 현재 선택된 route의 annotation
    @Published var RouteAnnotations:[CustomPointAnnotation] = [CustomPointAnnotation]()
    //UserGetStamp : 현재 선택된 User가 얻은 스탬프 목록
    @Published var UserGetStamp:UsersStampInfo = UsersStampInfo(stamp_status: [24,9,4], stamp_achievement: 0)
    //UserSelectTourRoute : 유저가 투어를 위해 선택한 루트
    @Published var UserSelectTourRoute:RouteInfo? = nil
    //currentBeaconList : 현재 선택한 루트의 모든 비콘 리스트
    @Published var currentBeaconList:[BeaconInfo] = [BeaconInfo]()
    //tourVisitBeaconIndex : 현재 투어중인 비콘의 Index
    @Published var tourVisitBeaconIndex:Int = -1{
        didSet{
            print("tourVisitBeaconIndex : \(tourVisitBeaconIndex)")
            if(tourVisitBeaconIndex < currentBeaconList.count - 1){
                let start_location = currentBeaconList[tourVisitBeaconIndex]
                let dest_location = currentBeaconList[tourVisitBeaconIndex+1]
                let start = CLLocationCoordinate2D(latitude: start_location.latitude, longitude: start_location.longitude)
                let dest = CLLocationCoordinate2D(latitude: dest_location.latitude, longitude: dest_location.longitude)
                requestRoute(start: start, dest: dest)
            }
        }
    }

    func requestRoute(start:CLLocationCoordinate2D,dest:CLLocationCoordinate2D){
        let appKey = "3b93e7ea-9bb4-4402-afdb-a96aaab9fa23"
        
        let header:HTTPHeaders = [
            "Accept" : "application/json",
            "appKey" : appKey
        ]
        
        let body:[String:String] = [
            "startX" : String(start.longitude),
            "startY" : String(start.latitude),
            "endX" : String(dest.longitude),
            "endY" : String(dest.latitude),
            "startName" : "출발지",
            "endName" : "도착지"
        ]
        
        AF.request(URLRoot.TMapRoute.rawValue,method: .post ,parameters: body,encoding: URLEncoding.default,headers: header)
            .responseData{ response in
                switch response.result{
                case .success(let value):
                    print(value)
                    test = value
                    let info = Data_to_CLLocation(data: value)
                    self.currentRouteList = info.0
                    self.currentRouteProperties = info.1
                case .failure(let error):
                    print(error)
                }
        }
    }
}

public struct NavigationBarHider: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }
}

extension View {
    public func hideNavigationBar() -> some View {
        modifier(NavigationBarHider())
    }
}
extension View{
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
           clipShape( RoundedCorner(radius: radius, corners: corners) )
       }
}

