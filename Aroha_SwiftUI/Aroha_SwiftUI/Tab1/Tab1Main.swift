//
//  Tab1Main.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//
import Foundation
import SwiftUI
import MapKit
import Alamofire

struct Tab1MainView:View{
    @EnvironmentObject var settings:UserSettings
    var body:some View{
        NavigationView{
            Tab1ContentView()
                .navigationBarTitle(Text("현재 투어 상태").font(.subheadline), displayMode: .inline)
        }.onAppear(){
            self.LoadAllRecomendRoute()
        }
    }
    /*서버의 모든 루트를 가져오는 함수**/
    func LoadAllRecomendRoute(){
        AF.request(APIRoute.route.url(), method: .get).responseData{ response in
            switch response.result{
            case .success(let value):
                do{
                    self.settings.AllRouteInfo = try JSONDecoder().decode([RouteInfo].self, from: value)
                    for item in self.settings.AllRouteInfo{
                        print("AllRouteInfo : \(item)")
                    }
                }catch{
                    print("JSONDecoder().decode DecodingError")
                }
            case .failure(let error):
                print("failure \(error)")
            }
        }
    }
}

struct Tab1ContentView:View{
    @EnvironmentObject var settings:UserSettings
    //showSelectedRouteView : Route 선택 리스트 뷰 보일지 안보일지 결정하는 변수
    @State var showSelectedRouteView:Bool = true
    //currentBeaconList : 현재 선택한 루트의 모든 비콘 리스트
    @State var currentBeaconList:[BeaconInfo] = [BeaconInfo]()
    var body:some View{
        VStack{
            //route를 선택하는 뷰
            if showSelectedRouteView{SelectRouteView(showSelectedRouteView: $showSelectedRouteView, currentBeaconList: self.$currentBeaconList)}
            //루트의 비콘들을 캐로셀로 나열한 뷰
            else {SnapCarousel(UIState: UIStateModel(),items : $currentBeaconList)}
            HStack{
                //go to toure
                NavigationLink(destination: Tab1TourView()){
                    Text("투어 시작하기").padding().overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue, lineWidth: 4)
                    )
                }.buttonStyle(PlainButtonStyle()).padding()
                    .simultaneousGesture(TapGesture().onEnded{
                        // MARK: @하드코딩 되어 있는 부분
//                       self.settings.requestRoute(start: CLLocationCoordinate2D(latitude: 37.5424107, longitude: 127.0765058), dest: CLLocationCoordinate2D(latitude:37.531544, longitude: 127.0645193))
                        let first_beacon = self.currentBeaconList.first!
                        let last_beacon = self.currentBeaconList.last!
                        self.settings.requestRoute(start: CLLocationCoordinate2D(latitude: first_beacon.latitude, longitude: first_beacon.longitude), dest: CLLocationCoordinate2D(latitude:last_beacon.latitude, longitude: last_beacon.longitude))
                    })
                
                //cancel the tour
                NavigationLink(destination: Tab2MainView()){
                    Text("투어 취소하기").padding().overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue, lineWidth: 4)
                    )
                }.buttonStyle(PlainButtonStyle()).padding()
            }
        }
    }
    
    
}

struct SelectRouteView:View{
    @EnvironmentObject var settings:UserSettings
    @Binding var showSelectedRouteView:Bool
    @Binding var currentBeaconList:[BeaconInfo]
    var body:some View{
        List(self.settings.AllRouteInfo, id: \.self){ item in
            Text("\((item as RouteInfo).title)").onTapGesture {
                self.showSelectedRouteView.toggle()
                self.LoadOneRecommedRoute(id: (item as RouteInfo).id)
            }
        }
    }
    
    /*선택한 route의 비콘을 가져오는 함수*/
    func LoadOneRecommedRoute(id:Int){
        AF.request(APIRoute.selectroute(select: String(id)).url(), method: .get).responseData{ response in
            switch response.result{
            case .success(let value):
                do{
                    let route = try JSONDecoder().decode(ResponseRoute.self, from: value)
                    self.currentBeaconList = route.beacon_list
                }catch{
                    print("JSONDecoder().decode DecodingError")
                }
            case .failure(let error):
                print("failure \(error)")
            }
        }
    }
}




struct Tab1Main_Previews: PreviewProvider {
    @EnvironmentObject var settings:UserSettings
    static var previews: some View {
        Tab1MainView()
    }
}
