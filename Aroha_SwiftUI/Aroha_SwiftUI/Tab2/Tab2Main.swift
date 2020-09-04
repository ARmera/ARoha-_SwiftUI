//
//  Tab2Main.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI
import Alamofire

struct Tab2MainView:View{
    let screenHeight = UIScreen.main.bounds.size.height
    
    @State private var showSearchRouteView = false
    @EnvironmentObject var settings:UserSettings
    //showDetailBeaconView : 디테일 뷰를 보여줄지 말지
    @State var showDetailBeaconView:Bool = false;
    //selectDetailBeacon : 선택한 비콘
    @State var selectDetailBeacon:BeaconInfo? = nil
    
    var body:some View{
        NavigationView{
            ZStack{
                MapView(annotations:self.settings.RouteAnnotations, showDetailBeacon: { index in
                    self.showDetailBeaconView = true;
                    if(index != -1) {self.selectDetailBeacon = self.settings.RouteBeaconList[index-1]}
                })
                Spacer()
                DragOverCard(showSearchRouteView: self.$showSearchRouteView)
                
                if(self.showDetailBeaconView && self.selectDetailBeacon != nil){
                    BeaconDetailView(selectBeacon : self.$selectDetailBeacon, showBeaconDetailView: self.$showDetailBeaconView).background(Color.white)
                }
            }.navigationBarTitle(Text("전체 투어 명소").font(.subheadline), displayMode: .inline)
                .sheet(isPresented: $showSearchRouteView){
                    SearchSheetView(showSearchView: self.$showSearchRouteView)
                    .environmentObject(self.settings)

            }
            
        }
        
    }
    
   
}


