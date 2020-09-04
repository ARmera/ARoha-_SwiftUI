//
//  DragContentView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/29.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI
import Mapbox

final class DragContentViewModel: ObservableObject {
    //Observable Variable
    @Published var searchQureyResult:Bool = false
    @Published var search:String = ""{
        didSet{
            self.searchQureyResult = true
        }
    }
    @Published var currentBeaconName = ""
    
}

struct DragContentView:View{
    
    @Binding var position:CGFloat
    @Binding var showSearchRouteView:Bool
    @ObservedObject var viewmodel = DragContentViewModel()
    
    var body: some View {
        
        VStack {
            SearchTitleView(showSearchRouteView: self.$showSearchRouteView)
            BeaconSearchView(position : $position)
            Spacer()
        }.frame(width: screenWidth)
    }
}

struct SearchTitleView: View{
    @Binding var showSearchRouteView:Bool
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings:UserSettings
    var body:some View{
        HStack {
            Button(action: {
                self.settings.RouteAnnotations = convertBeacon2Anno(beaconinfos: self.settings.RouteBeaconList)
            })
            {
                Image(systemName:"arrowshape.turn.up.left.2.fill").foregroundColor(Color("Primary"))
                    .padding(.trailing,10)
            }
            Spacer();
            Button(action:{
                self.showSearchRouteView.toggle()
            }){
                Text("\(self.settings.UserSelectedRoute)")
                    .font(Font.custom("BMJUA", size: 20))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                Image(systemName: "square.and.pencil")
            }
            Spacer();
            
        }.padding(.horizontal,20).padding(.top, 10)
    }
}

struct BeaconSearchView:View{
    @ObservedObject var viewmodel = DragContentViewModel()
    @Binding var position:CGFloat
    
    var body:some View{
        VStack{
            HStack{
                //검색 박스
                HStack {
                    TextField("건물이름을 입력해주세요!", text: $viewmodel.search)
                        .foregroundColor(viewmodel.search == "" ? Color("blue500") : Color.black)
                        .font(Font.custom("SpoqaHanSans-Regular", size: 14))
                    Spacer()
                    Image("search")
                    
                } .padding(.horizontal, 14).padding(.vertical, 11)
                    .frame(width: 335, height: 42, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 5.0).foregroundColor(Color("blue150")))
                    .onTapGesture {
                        self.position = screenHeight/3;
                }
                
            }
            .padding(.horizontal,20)
            
            
            Spacer().frame(height:20)
            Divider()
            Spacer().frame(height:20)
            
            SearchQueryResultView(query: self.$viewmodel.search, position: self.$position)
            
        }.foregroundColor(Color.gray)
    }
}

// 검색 결과가 표기되는 검색 결과 뷰
struct SearchQueryResultView: View {
    
    @Binding var query:String
    @Binding var position:CGFloat
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    @EnvironmentObject var settings: UserSettings
    @ObservedObject var viewmodel = DragContentViewModel()
    
    var body: some View {
        
        //검색 결과
        VStack{
            
            HStack{
                if self.query.count == 0 {
                    Image("pin")
                    Text("루트 내 모든 비콘 리스트")
                        .font(Font.custom("SpoqaHanSans-Regular", size: 14))
                }
                else{
                    Text("검색결과 ")
                        .font(Font.custom("SpoqaHanSans-Regular", size: 14))
                        .foregroundColor(Color.black)
                    Text("""
                        \(self.settings.RouteBeaconList.filter{ "\($0)".localizedCaseInsensitiveContains(self.query.trimmingCharacters(in: .whitespacesAndNewlines))
                        }.count) 건
                        """)
                        .font(Font.custom("SpoqaHanSans-Bold", size: 14))
                        .foregroundColor(Color.blue)
                }
                Spacer()
            }.padding(.leading, 20)
            
            
            if self.query.count == 0 {
                List(self.settings.RouteBeaconList,id:\.self){ item in
                    SearchResultRow(position: self.$position, item: item)
                }.foregroundColor(Color.gray)
                    .frame(height: screenHeight/3)
            }
                
            else{
                List(self.settings.RouteBeaconList.filter{ "\($0)".localizedCaseInsensitiveContains(self.query.trimmingCharacters(in: .whitespacesAndNewlines))
                },id:\.self){ item in
                    SearchResultRow(position: self.$position, item: item)
                }.foregroundColor(Color.gray)
                    .frame(height: screenHeight/3)
            }
        }
        .padding(.horizontal, 10.0)
        
    }
    
    
}

struct SearchResultRow: View {
    let screenHeight = UIScreen.main.bounds.size.height
    @ObservedObject var viewModel:DragContentViewModel = DragContentViewModel()
    @EnvironmentObject var settings: UserSettings
    @Binding var position:CGFloat
    let screenWidth = UIScreen.main.bounds.size.width
    var item:BeaconInfo
    
    var body:some View {
        
        HStack{
            Image(systemName: "pin.circle").padding(3).foregroundColor(.gray)
            VStack(alignment: .leading, spacing: 3) {
                Text("\(item.title)")
                    .font(Font.custom("SpoqaHanSans-Regular", size: 16))
                    .foregroundColor(Color.black)
                Text("\(item.description)")
                    .font(Font.custom("SpoqaHanSans-Regular", size: 12)).foregroundColor(Color.gray)
                
            }.padding(.leading,5)
                .foregroundColor(Color.gray)
            
        }
        .padding(.vertical, 9)
        .frame(width : screenWidth-20 ,height:40, alignment: .leading)
        .onTapGesture {
            self.position = self.screenHeight - 200;
            self.viewModel.search.removeAll()
            self.settings.RouteAnnotations = [CustomPointAnnotation(coordinate : CLLocationCoordinate2D(latitude: self.item.latitude, longitude: self.item.longitude), title: self.item.title, index: self.item.index)]
            //키보드 숨기기
            UIApplication.shared.endEditing()
        }
        .padding(5)
    }
}


