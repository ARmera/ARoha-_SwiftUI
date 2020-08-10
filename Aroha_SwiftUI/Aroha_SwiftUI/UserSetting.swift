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

class UserSettings:ObservableObject{
    @Published var isLogin = false;
    @Published var tabselected = 0;
    @Published var test:UIImage = UIImage()
    @Published var currentRouteList:[Pos] = [Pos](){
        didSet{
            print(currentRouteList)
        }
    }
    @Published var currentRouteProperties:[[String:Any]] = [[String:Any]](){
        didSet{
            print(currentRouteProperties)
        }
    }
    
    func requestRoute(start:CLLocationCoordinate2D,dest:CLLocationCoordinate2D){
        let url = "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result"
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
        
        AF.request(url,method: .post,parameters: body,encoding: URLEncoding.default,headers: header)
            .responseData{ response in
                switch response.result{
                case .success(let value):
                    let info = Data_to_CLLocation(data: value)
                    self.currentRouteList = info.0
                    self.currentRouteProperties = info.1
                case .failure(let error):
                    print(error)
                }
        }
    }
}

enum tabMenu:Int{
    case CamputTourTab1 = 0
    case TourLocationTab2 = 1
    case StampTab3 = 2
    case MyPageTab4 = 3
}

