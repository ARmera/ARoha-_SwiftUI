//
//  Tab2Main.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI

struct Tab3MainView:View{
    var body:some View{
        NavigationView{
            Tab3ContentView()
                .navigationBarTitle(Text("획득한 전체 스탬프").font(.subheadline), displayMode: .inline)
        }
    }
}

struct Tab3ContentView:View{
    var body:some View{
        GridView(rows: AllBeaconInfo.count/2, columns: 2, content: {row,column in
            StampCard(beacon: AllBeaconInfo[2*row+column])
                .background(Color.white)
                .padding(.horizontal, 5)

        }).background(Color("blue200"))
    }
}

struct StampCard:View{
    var beacon:BeaconSummaryInfo
    var body:some View{
        VStack{
            HStack{
                Text("\(beacon.title)").font(Font.custom("BMJUA", size: 12))
                Spacer()
            }.padding(.horizontal, 5)
                .padding(.vertical,5)
            StampImage(img: convertTitle2Img(kor: beacon.title))
            .padding(.vertical,5)

        }
        .padding(3)
    }
}

struct StampImage: View {
    @EnvironmentObject var settings:UserSettings
    var img:String
    var body: some View {
        VStack{
            if(!self.settings.UserGetStamp.contains(img)){
                Image(img).resizable().frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 1, dash: [5])))
                    .shadow(radius: 10)
                    .foregroundColor(Color.gray)
            }
            else{
                Image(img).resizable().frame(width: 100, height: 100, alignment: .center)
                .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 1.5))
                .shadow(radius: 10)
            }
        }
    }
}

