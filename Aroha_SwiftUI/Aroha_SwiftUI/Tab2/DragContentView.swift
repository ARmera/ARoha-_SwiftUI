//
//  DragContentView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/29.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI
final class DragContentViewModel: ObservableObject {
    //Observable Variable
    @Published var searchQureyResult:Bool = false
    @Published var search:String = ""{
        didSet{
            self.searchQureyResult = true
        }
    }
    @Published var isSelected = false
    @Published var currentPlaceName = ""
    @Published var selectedPOIId:String = ""
    
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
            })
            {
                Image(systemName:"tray.2.fill").foregroundColor(Color("Primary"))
                    .padding(.trailing,10)
            }
            Spacer();
            Button(action:{
                self.showSearchRouteView.toggle()
            }){
                Text("\(self.settings.UserSelected)")
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
            
//            if self.viewmodel.searchQureyResult { SearchQueryResultView(query: self.$viewmodel.search, position: self.$position) }
            
        }.foregroundColor(Color.gray)
    }
}



