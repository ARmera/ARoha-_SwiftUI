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
    var body: some View {
        VStack{
            VStack(alignment: .center){
                Image("main-logo").resizable().frame(width: 100, height: 100, alignment: .center)
                Text("AroHa!").font(.footnote)
            }.onAppear(){
                self.LoadAllRecomendRoute()
                self.LoadAllBeacon()
            }
            Button(action: {
                self.setting.isLogin = true
            }){
                HStack(spacing : 10){
                    Image("kakao-login").resizable()
                }
            }.frame(width: 300, height: 50, alignment: .center)
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
