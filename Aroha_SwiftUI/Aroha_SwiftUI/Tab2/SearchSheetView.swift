//
//  SearchSheetView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/29.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI
import Alamofire

class SearchViewModel: ObservableObject {
    
    @Published var searchTerm:String = ""{
        didSet{
            filterQuery()
        }
    }
    
    @Published var queryCandidate:[RouteInfo] = []
    
    func filterQuery() {
        
        if searchTerm.count > 1 {
            queryCandidate.removeAll()
            DispatchQueue.global(qos: .userInitiated).async {
                let temp = AllRouteInfo.filter {
                    self.searchTerm.isEmpty ? true : "\($0)".localizedStandardContains(self.searchTerm.trimmingCharacters(in: .whitespacesAndNewlines))
                }
                DispatchQueue.main.async {
                    self.queryCandidate = temp
                }
            }
        }
    }
}

struct SearchSheetView:View{
    @Binding var showSearchView: Bool
    @ObservedObject var viewmodel = SearchViewModel()
    @EnvironmentObject var settings:UserSettings

    var sheetTitle:String = "어디로 떠나시겠어요?"
    
    var body: some View{
        VStack{
            VStack {
                //상단 제목
                HStack{
                    Spacer()
                    Text(self.sheetTitle)
                        .font(Font.custom("BMJUA", size: 17))
                    Spacer().frame(width: 70)
                    Image("close").frame(width: 24, height: 24).onTapGesture { self.showSearchView = false }
                }.padding(.horizontal, 16.0)
                
                //검색창
                HStack {
                    ZStack(alignment: .leading) {
                        if viewmodel.searchTerm.isEmpty {
                            Text("여행지를 입력해주세요")
                                .foregroundColor(.gray)
                        }
                        TextField("", text: $viewmodel.searchTerm)
                            .foregroundColor(.black).font(Font.custom("SpoqaHanSans-Regular", size: 14))
                    }
                    Spacer()
                    Image("search")
                    
                } .padding(.horizontal, 14).padding(.vertical, 11)
                    .frame(width: 335, height: 42, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 5.0).foregroundColor(Color("blue150")))
                
                //최근 검색어 목록
                Spacer().frame(height : 21)
                Divider().foregroundColor(Color("blue300"))
                
                //검색 목록
                Spacer().frame(height : 20)
                HStack{
                    if self.viewmodel.searchTerm.count == 0 {
                        Image("pin")
                        Text("모든 루트")
                            .font(Font.custom("SpoqaHanSans-Regular", size: 14))
                    }
                    else{
                        Text("검색결과")
                            .font(Font.custom("SpoqaHanSans-Regular", size: 14))
                        
                        Text("\(self.viewmodel.queryCandidate.count)건")
                            .font(Font.custom("SpoqaHanSans-Bold", size: 14))
                    }
                    Spacer()
                }.padding(.leading, 20)
                
                //검색 결과
                if(self.viewmodel.searchTerm == ""){
                    NavigationView {
                        List(AllRouteInfo, id: \.self)  { item in
                            RouteRow(routeinfo: item, showSearchView: self.$showSearchView)
                                .environmentObject(self.settings)
                        }.hideNavigationBar()
                        
                    }
                }else{
                    NavigationView {
                        List(self.viewmodel.queryCandidate, id: \.self)  { item in
                            RouteRow(routeinfo: item, showSearchView: self.$showSearchView)
                                .environmentObject(self.settings)
                        }.hideNavigationBar()
                        
                    }
                }
            }
        }.padding(.top)
        
    }
}

struct RouteRow:View{
    var routeinfo:RouteInfo
    @Binding var showSearchView:Bool
    
    @EnvironmentObject var settings:UserSettings
    
    var body: some View {
        Button(action:{
            //이름 바꾸기
            self.settings.UserSelectedRoute = self.routeinfo.title
            //해당하는 정보 불러오기
            self.LoadOneRecommedRoute(id: self.routeinfo.id)
            //sheet 닫기
            self.showSearchView = false
        }){
            HStack {
                Image("loute")
                VStack(alignment: .leading) {
                    Text("\(routeinfo.title),")
                        .font(Font.custom("SpoqaHanSans-Regular", size: 15))
                    
                    HStack {
                        Text("\(routeinfo.estimated_time.toString()) 분,")
                        Text("\(routeinfo.total_distance.toString()) km,")
                    }.font(Font.custom("SpoqaHanSans-Regular", size: 12))
                        .foregroundColor(.gray)
                    
                }.layoutPriority(1)
                    .padding(.horizontal, 12)
                
                Spacer()
            }
        }.buttonStyle(PlainButtonStyle())
    }
    
    //MARK: @선택한 루트의 정보를 가져오는 함수
    func LoadOneRecommedRoute(id:Int){
        AF.request(APIRoute.selectroute(select: String(id)).url(), method: .get).responseData{ response in
            switch response.result{
            case .success(let value):
                do{
                    let route = try JSONDecoder().decode(ResponseRoute.self, from: value)
                    self.settings.RouteBeaconList = route.beacon_list
                    self.settings.RouteAnnotations = convertBeacon2Anno(beaconinfos: route.beacon_list)
                }catch{
                    print("JSONDecoder().decode DecodingError")
                }
            case .failure(let error):
                print("failure \(error)")
            }
        }
    }

    
}
