//
//  LoginView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI
import Alamofire
struct LoginView: View {
    @EnvironmentObject var setting:UserSettings
    @State var width:CGFloat = 0;
    @State var height:CGFloat = 0;
    var body: some View {
        ZStack{
            Image("konkuk").resizable().frame(width:screenWidth)
                .background(Color.black).opacity(0.5)
            VStack{
                VStack(alignment: .center){
                    Image("login-logo2").resizable().frame(width: width, height: height, alignment: .center)
                        .animation(.easeInOut(duration : 2))
                }.onAppear(){
                    self.LoadAllRecomendRoute()
                    self.LoadAllBeacon()
                    self.LoadAllUserInfo()
                    self.width = screenWidth - 50;
                    self.height = 200;
                }
                Button(action: {
                    self.setting.isLogin = true
                }){
                    HStack(spacing : 10){
                        Image("kakao-login").resizable()
                    }
                }.frame(width: 300, height: 50, alignment: .center)
            }.zIndex(1)
        }.edgesIgnoringSafeArea(.all)
        
    }
    //MARK: @사용자의 정보를 가져오는 함수
    func LoadAllUserInfo(){
        AF.request(APIRoute.id(uuid: "1").url(),method: .get).responseData{ response in
            switch response.result{
            case .success(let value):
                do{
                    self.setting.UserGetStamp = try JSONDecoder().decode(UsersStampInfo.self, from: value)
                    print("self.settings : \(self.setting.UserGetStamp)" )
                }catch{
                    print("JSONDecoder().decode DecodingError")
                }
            case .failure(let error):
                print("failure \(error)")
            }
        }
    }
    
    //MARK: @서버의 모든 루트를 가지고 오는 함수
    func LoadAllRecomendRoute(){
        AF.request(APIRoute.route.url(), method: .get).responseData{ response in
            switch response.result{
            case .success(let value):
                do{
                    AllRouteInfo = try JSONDecoder().decode([RouteInfo].self, from: value)
                }catch{
                    print("JSONDecoder().decode DecodingError")
                }
            case .failure(let error):
                print("failure \(error)")
            }
        }
    }
    //MARK: @서버의 모든 비콘을 가지고 오는 함수
    func LoadAllBeacon(){
        AF.request(APIRoute.beacon.url(), method: .get).responseData{ response in
            switch response.result{
            case .success(let value):
                do{
                    AllBeaconInfo = try JSONDecoder().decode([BeaconSummaryInfo].self, from: value)
                    self.setting.RouteAnnotations = convertBeaconSummary2Anno(beaconinfos: AllBeaconInfo)
                }catch{
                    print("JSONDecoder().decode DecodingError")
                }
            case .failure(let error):
                print("failure \(error)")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
