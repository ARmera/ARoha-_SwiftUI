//
//  BeaconDetailView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/09/04.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI
import Mapbox

struct BeaconDetailView:View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectBeacon:BeaconInfo?
    @Binding var showBeaconDetailView:Bool
    var body:some View{
        ZStack(alignment: .topLeading) {
            ScrollView(.vertical, showsIndicators: false, content: {
                GeometryReader{reader in
                    Image("konkuk")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .offset(y: -reader.frame(in: .global).minY)
                        .frame(width: UIScreen.main.bounds.width, height:  reader.frame(in: .global).minY + 350)
                }.frame(height : 350)
                
                VStack(alignment: .leading){
                    HStack {
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "suit.heart.fill").foregroundColor(Color.red)
                                Text("건국대학교 \(selectBeacon!.title)")
                                    .font(Font.custom("BMJUA", size: 17))
                                    .fontWeight(.bold)
                            }
                            HStack {
                                Image(systemName: "pin.fill").foregroundColor(Color.blue)
                                Text("\(selectBeacon!.longitude) , \(selectBeacon!.latitude)")
                                    .font(Font.custom("BMJUA", size: 12))
                                Spacer(minLength: 0)
                            }.foregroundColor(Color.gray)
                                .padding(.top, 3)
                        }
                        Spacer()
                        CircleImage()
                    }.padding(.top, 5)
                    .padding(.horizontal, 15)
                    
                    
                    Divider()
                    
                    VStack{
                        HStack{
                            Image(systemName: "book.fill").foregroundColor(Color.blue)
                            Text("비콘 설명").font(Font.custom("BMJUA", size: 15.0))
                            Spacer()
                        }
                        
                        ScrollView(.vertical) {
                            HStack{
                                Text("\(selectBeacon!.description)").font(Font.custom("SpoqaHanSans-Regular", size: 13))
                                    .foregroundColor(Color.black)
                                Spacer(minLength: 0)
                            }
                        }.padding(7)
                            .foregroundColor(colorScheme == .dark ? Color("blue200") : Color("blue700"))
                            .frame(height: 170)
                    }.padding(.horizontal, 15)
                        .padding(.top,7)
                    
                }

            }).edgesIgnoringSafeArea(.all)
                .background(Color.white)
            .cornerRadius(20, corners: [.topLeft, .topRight])

            
            Button(action:{
                self.showBeaconDetailView = false
            }){
                Image(systemName: "arrow.left")
                    .resizable()
                    .frame(width:  24, height:  24)
                    .foregroundColor(.white)
                    .padding(16)
                    .background(Color.red.opacity(0.01))
                    .padding(.top, 10)
            }.offset(y: 50)

        }

    }
    
    
}

struct CircleImage: View {
    var body: some View {
        Image("museum")
            .resizable()
            .frame(width:50, height: 50)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.gray, lineWidth: 1.2))
            .shadow(radius: 10)
        
    }
}



struct BeaconDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BeaconDetailView(selectBeacon: .constant(BeaconInfo(title: "1", description: "2", longitude: 3.0, latitude: 4.0, index: 1)), showBeaconDetailView: .constant(true))
    }
}
