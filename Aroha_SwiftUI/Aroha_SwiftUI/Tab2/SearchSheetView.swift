//
//  SearchSheetView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/29.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI

//class SearchViewModel: ObservableObject {
//
//    @Published var searchTerm:String = ""{
//        didSet{
//            filterQuery()
//        }
//    }
//
//    @Published var queryCandidate:[CityItem] = []
//
//    func filterQuery() {
//
//        if searchTerm.count > 1 {
//            queryCandidate.removeAll()
//            DispatchQueue.global(qos: .userInitiated).async {
//                let temp = self.cities.filter {
//                    self.searchTerm.isEmpty ? true : "\($0)".localizedStandardContains(self.searchTerm.trimmingCharacters(in: .whitespacesAndNewlines))
//                }
//                DispatchQueue.main.async {
//                    self.queryCandidate = temp
//                }
//            }
//        }
//    }
//
//    //최근 검색어 보여주는 함수
//    func showRecentSearch() {
//
//        let recentSearch = Array(realm.objects(RealmSearchCity.self))
//        queryCandidate.removeAll()
//        var temp_cityitem = [CityItem]()
//
//        for item in recentSearch{
//            let cityitem = CityItem(en_country:item.national_eng , ko_country: item.national_kr, en_city: item.city_eng, ko_city: item.city_kr)
//            temp_cityitem.append(cityitem)
//        }
//        queryCandidate = temp_cityitem
//    }
//
//    init(){
//        cities = Bundle.main.decode([CityItem].self, from: "country_city_mapping.json")
//    }
//}

struct SearchSheetView:View{
    @Binding var showSearchView: Bool
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
                   Text("여행지를 입력해주세요").font(Font.custom("SpoqaHanSans-Regular", size: 14))
                    Spacer()
                    Image("search")

                } .padding(.horizontal, 14).padding(.vertical, 11)
                    .frame(width: 335, height: 42, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 5.0).foregroundColor(Color("blue150")))

                //최근 검색어 목록
                Spacer().frame(height : 21)
                Divider().foregroundColor(Color("blue300"))

                //검색 목록
//                Spacer().frame(height : 20)
//                HStack{
//                    if self.viewModel.searchTerm.count == 0 {
//                        Image("pin")
//                        Text("모든 루트와 비콘")
//                            .font(Font.custom("SpoqaHanSans-Regular", size: 14))
//                            .onAppear() {
//                                self.viewModel.showRecentSearch()
//                        }
//                    }
//                    else{
//                        Text("검색결과")
//                            .font(Font.custom("SpoqaHanSans-Regular", size: 14))
//                            .foregroundColor(colorScheme == .dark ? .white : .black)
//
//                        Text("\(self.viewModel.queryCandidate.count)건")
//                            .font(Font.custom("SpoqaHanSans-Bold", size: 14))
//                            .foregroundColor(Color.blue)
//                    }
//                    Spacer()
//                }.padding(.leading, 20)
//
//                //검색 결과
//
//                NavigationView {
//                    List(self.viewModel.queryCandidate, id: \.self)  { item in
//                    }.hideNavigationBar()
//
//                }
            }
        }.padding(.top)
        
    }
}
