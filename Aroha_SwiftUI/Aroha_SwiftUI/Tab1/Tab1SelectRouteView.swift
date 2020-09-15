//
//  Tab1SelectRouteView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/09/15.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI
import Alamofire


struct SelectRouteView:View{
    @EnvironmentObject var settings:UserSettings
    @Binding var showSelectedRouteView:Bool
    @State var copy_AllRoute = AllRouteInfo
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(copy_AllRoute.count - 1 - id) * 10
        return geometry.size.width - offset
    }
    
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(copy_AllRoute.count - 1 - id) * 10
    }
    
    private var maxID: Int {
        return copy_AllRoute.map { $0.id }.max() ?? 0
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                
                VStack(spacing: 24) {
                    DateWeatherView()
                    ZStack {
                        ForEach(self.copy_AllRoute, id: \.self) { route in
                            Group {
                                // Range Operator
                                    CardView(route: route, onRemove: { removedUser in
                                        self.copy_AllRoute.removeAll { $0.id == removedUser.id }
                                        if(self.copy_AllRoute.count == 0) {self.copy_AllRoute = AllRouteInfo}
                                    })
                                        .animation(.spring())
                                        .frame(width: self.getCardWidth(geometry, id: route.id), height: 400)
                                        .offset(x: 0, y: self.getCardOffset(geometry, id: route.id))
                                        .onTapGesture {
                                            self.settings.UserSelectTourRoute = route as RouteInfo
                                            self.LoadOneRecommedRoute(id: (route as RouteInfo).id)
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
        }.padding()
    }
    
    /*선택한 route의 비콘을 가져오는 함수*/
    func LoadOneRecommedRoute(id:Int){
        AF.request(APIRoute.selectroute(select: String(id)).url(), method: .get).responseData{ response in
            switch response.result{
            case .success(let value):
                do{
                    print(id)
                    print(self.settings.currentBeaconList.count)
                    self.settings.currentBeaconList.removeAll()
                    let route = try JSONDecoder().decode(ResponseRoute.self, from: value)
                    print(route.beacon_list)
                    self.settings.currentBeaconList = route.beacon_list
                    print(self.settings.currentBeaconList.count)

                }catch{
                    print("JSONDecoder().decode DecodingError")
                }
            case .failure(let error):
                print("failure \(error)")
            }
        }
    }
}

struct DateWeatherView:View{
    @State var day = "";
    @State var month = "";
    @State var date = "";
    var body: some View {
      // Container to add background and corner radius to
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(self.day), \(self.date)th \(self.month)")
                        .font(Font.custom("SpoqaHanSans-Regular", size: 20))
                        .bold()
                    Text("\(TodaysWeather.weather)")
                        .font(Font.custom("SpoqaHanSans-Regular", size: 15))
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "cloud.sun.fill").resizable().frame(width:30,height: 30).foregroundColor(Color.gray)
            }.padding()
        }.onAppear(){
            let formatter_year = DateFormatter()
            formatter_year.dateFormat = "MM"
            print()
            self.month = convertomonth(str: formatter_year.string(from: Date()))
            formatter_year.dateFormat = "dd"
            self.date = formatter_year.string(from: Date())
            self.day = getWeekDay(month: Int(atoi(self.month)),day : Int(atoi(self.date)))
            formatter_year.dateFormat = "yyyy"
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
