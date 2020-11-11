//
//  HomeView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI

struct HomeView:View{
    var body:some View{
        TabView {
            Tab1MainView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("캠퍼스 투어")
            }
            Tab2MainView()
                .tabItem {
                    Image(systemName: "car.fill")
                    Text("투어 명소")
            }
            Tab3MainView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("스탬프")
            }
            Tab4MainView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("마이 페이지")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
