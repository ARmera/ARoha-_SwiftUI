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


    var body:some View{
        NavigationView{
            ZStack{
                MapView(annotations:self.settings.RouteAnnotations)
                Spacer()
                DragOverCard(showSearchRouteView: self.$showSearchRouteView)
            }.navigationBarTitle(Text("전체 투어 명소").font(.subheadline), displayMode: .inline)
                .sheet(isPresented: $showSearchRouteView){
                    SearchSheetView(showSearchView: self.$showSearchRouteView)
                    .environmentObject(self.settings)

            }
            
        }
        
    }
    
   
}


