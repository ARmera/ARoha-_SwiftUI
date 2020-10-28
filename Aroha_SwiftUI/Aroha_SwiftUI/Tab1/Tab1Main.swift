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
                .navigationBarTitle(Text("캠퍼스 투어").font(.subheadline), displayMode: .inline)
        }
    }
    
}

struct Tab1ContentView:View{
    @EnvironmentObject var settings:UserSettings
    //showSelectedRouteView : Route 선택 리스트 뷰 보일지 안보일지 결정하는 변수
    @State var showSelectedRouteView:Bool = true
    var body:some View{
        VStack{
            //route를 선택하는 뷰
            if self.settings.UserSelectTourRoute == nil{
                SelectRouteView(showSelectedRouteView: $showSelectedRouteView)}
                //루트의 비콘들을 캐로셀로 나열한 뷰
            else {
                VStack{
                    SnapCarousel(UIState: UIStateModel())
                    HStack{
                        //go to tour
                        NavigationLink(destination: Tab1TourView()){
                            HStack {
                                Image(systemName: "forward.fill")
                                Text("투어 시작")
                                    .font(Font.custom("SpoqaHanSans-Bold", size: 20))
                            }
                            .padding()
                            .foregroundColor(.black)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.gray]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                        }.buttonStyle(PlainButtonStyle()).padding()
                            .simultaneousGesture(TapGesture().onEnded{
                                if(self.settings.tourVisitBeaconIndex == -1) {
                                    self.settings.tourVisitBeaconIndex = 0
                                }
                                if(self.settings.tourVisitBeaconIndex < self.settings.currentBeaconList.count - 1){
                                    let first_beacon = self.settings.currentBeaconList[self.settings.tourVisitBeaconIndex]
                                    let last_beacon = self.settings.currentBeaconList[self.settings.tourVisitBeaconIndex + 1]
                                    self.settings.requestRoute(start: CLLocationCoordinate2D(latitude: first_beacon.latitude, longitude: first_beacon.longitude), dest: CLLocationCoordinate2D(latitude:last_beacon.latitude, longitude: last_beacon.longitude))
                                }
                            })
                        
                        //cancel the tour
                        NavigationLink(destination: Tab2MainView()){
                            
                            HStack {
                                Image(systemName: "stop.fill")
                                Text("투어 중단")
                                    .font(Font.custom("SpoqaHanSans-Bold", size: 20))
                            }
                            .padding()
                            .foregroundColor(.black)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.gray]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                        }.buttonStyle(PlainButtonStyle()).padding()
                            .simultaneousGesture(TapGesture().onEnded{
                                self.settings.tourVisitBeaconIndex = 0
                                self.settings.UserSelectTourRoute = nil
                                self.settings.sign_num = 1
                            })
                        
                    }
                    TourInfoView()
                    Spacer()
                }
            }
            
        }
    }
}

struct TourInfoView:View{
    var body: some View{
        VStack(spacing : 16.0){
            HStack{
                Text("투어 진행률").font(Font.custom("BMJUA", size: 20))
                Spacer()
                Text("82%")
            }.padding()
            Divider().frame(height:5)
            HStack{
                Text("투어 진행률").font(Font.custom("BMJUA", size: 20))
                Spacer()
                Text("2개")
            }.padding()
            Divider().frame(height:5)
            HStack{
                VStack(){
                    Text("오늘의 날씨").font(Font.custom("BMJUA", size: 20))
                    Image(systemName : "cloud.sun.fill")
                }
                Spacer()
                Divider().frame(width:5)
                Spacer()
                VStack{
                    Text("오늘의 미세먼지").font(Font.custom("BMJUA", size: 20))
                    Text("\(TodaysWeather.dust)")
                }
            }.padding()
            Spacer()
            
        }
    }
}

struct Tab1Main_Previews: PreviewProvider {
    @EnvironmentObject var settings:UserSettings
    static var previews: some View {
        Tab1MainView()
    }
}
