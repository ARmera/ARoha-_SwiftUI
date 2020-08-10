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
struct Tab1MainView:View{
    @EnvironmentObject var settings:UserSettings
    var body:some View{
        NavigationView{
            Tab1ContentView()
                .navigationBarTitle(Text("현재 투어 상태").font(.subheadline), displayMode: .inline)
        }
    }
}

struct Tab1ContentView:View{
    @EnvironmentObject var settings:UserSettings
    var body:some View{
        VStack{
            SnapCarousel(UIState: UIStateModel())
            HStack{
                //go to toure
                NavigationLink(destination: Tab1TourView()){
                    Text("투어 시작하기").padding().overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue, lineWidth: 4)
                    )
                    }.buttonStyle(PlainButtonStyle()).padding()
                    .simultaneousGesture(TapGesture().onEnded{
                        print("TapGesture")
                        self.settings.requestRoute(start: CLLocationCoordinate2D(latitude: 37.5396509, longitude: 127.0710501), dest: CLLocationCoordinate2D(latitude:37.5418772, longitude: 127.07602))

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

struct Tab1Main_Previews: PreviewProvider {
    @EnvironmentObject var settings:UserSettings
    static var previews: some View {
        Tab1MainView()
    }
}
