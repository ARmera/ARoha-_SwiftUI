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
    @State var showPopUp:Bool = false
    @State var SelectStamp:BeaconSummaryInfo? = nil
    var body:some View{
        NavigationView{
            ZStack{
                Tab3ContentView(showPopUp: self.$showPopUp, SelectStamp: self.$SelectStamp)
                    .background(Color("blue200"))
                    .navigationBarTitle(Text("획득한 전체 스탬프").font(.subheadline), displayMode: .inline)
                if(self.showPopUp){
                    GeometryReader{_ in
                        PopUpStamp(Stamp: self.$SelectStamp)
                        .cornerRadius(20)
                    }.background(
                        Color.black.opacity(0.65)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation{
                                    self.showPopUp.toggle()
                                }
                        }
                    )
                }
            }
            
        }
    }
}
struct Tab3ContentView:View{
    @Binding var showPopUp:Bool
    @Binding var SelectStamp:BeaconSummaryInfo?
    var body:some View{
        GridView(rows: AllBeaconInfo.count/2, columns: 2, content: {row,column in
            StampCard(showPopUp: self.$showPopUp, beacon: AllBeaconInfo[2*row+column], SelectStamp: self.$SelectStamp)
                .cornerRadius(20)
                .background(Color.white)
                .padding(.horizontal, 5)
            
        })
            .padding(.vertical,10)
            .padding(.horizontal,5)
    }
}

struct StampCard:View{
    @Binding var showPopUp:Bool
    var beacon:BeaconSummaryInfo
    @State var half = false;
    @Binding var SelectStamp:BeaconSummaryInfo?
    var body:some View{
        VStack{
            HStack{
                Text("\(beacon.title)").font(Font.custom("BMJUA", size: 20))
                Spacer()
                Image(systemName: "info.circle.fill").frame(width:20,height: 20)
                    .scaleEffect(half ? 1.5 : 0.0)
                    .opacity(half ? 1.0 : 0.0)
                    .animation(.easeInOut(duration:1.0))
                    .foregroundColor(Color("Primary"))
                    .onTapGesture {
                        self.showPopUp.toggle()
                        self.SelectStamp  = self.beacon
                }
            }.padding(.horizontal, 5)
                .padding(.top,5)
                .padding(.bottom,3)
            StampImage(half: self.$half, beacon: beacon)
                .padding(.vertical,5)
                .onTapGesture {
                    self.half.toggle()
            }
        }
        .padding(3)
        
    }
}

struct StampImage: View {
    @EnvironmentObject var settings:UserSettings
    @Binding var half:Bool
    var beacon:BeaconSummaryInfo
    var body: some View {
        VStack{
            if(!self.settings.UserGetStamp.stamp_status.contains(beacon.id)){
                VStack{
                    Image(convertTitle2Img(kor: beacon.title)).resizable().frame(width: 100, height: 100, alignment: .center)
                        .scaleEffect(half ? 1.5 : 1.0)
                        .opacity(half ? 1.0 : 0.8)
                        .animation(.easeInOut(duration:1.0))
                }
                .frame(width:150,height:150)
                .clipShape(Circle())
                .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 1, dash: [5])))
                .shadow(radius: 10)
                .foregroundColor(Color.gray)
            }
            else{
                VStack{
                    Image(convertTitle2Img(kor: beacon.title)).resizable().frame(width: 100, height: 100, alignment: .center)
                        .scaleEffect(half ? 1.5 : 1.0)
                        .opacity(half ? 1.0 : 0.8)
                        .animation(.easeInOut(duration:1.0))
                }
                .frame(width:150,height:150)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.yellow, lineWidth: 3))
                .foregroundColor(Color.yellow)
                .shadow(radius: 10)
            }
        }
    }
}

struct PopUpStamp:View{
    @Binding var Stamp:BeaconSummaryInfo?
    var body:some View{
        HStack{
            VStack(alignment: .leading){
                HStack{
                    Text("\(Stamp!.title)").font(Font.custom("BMJUA", size: 20))
                    Image("\(convertTitle2Img(kor: Stamp!.title))").resizable().frame(width:20,height: 20)
                }
                Divider()
                Spacer().frame(height:20)
                VStack{
                    Text("방문 날짜").font(Font.custom("BMJUA", size: 15)).padding(5)
                    Text("2020년 9월 2일").font(Font.custom("SpoqaHanSans-Regular", size: 12))
                    Text("방문 시간").font(Font.custom("BMJUA", size: 15)).padding(5)
                    Text("오후 2시 23분").font(Font.custom("SpoqaHanSans-Regular", size: 12))
                }
                
            }.padding(.horizontal,10)
            Image("konkuk").resizable().frame(width:150,height: 150)
            .padding(.horizontal,10)
        }.frame(width:300,height: 200)
        .background(Color("blue200"))
    }
}

