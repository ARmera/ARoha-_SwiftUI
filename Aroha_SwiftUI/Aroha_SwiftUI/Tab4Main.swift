//
//  Tab2Main.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI
import KakaoSDKAuth
import KakaoSDKUser

struct Tab4MainView:View{
    var body:some View{
        NavigationView{
            Tab4ContentView()
                .navigationBarTitle(Text("마이 페이지").font(.subheadline), displayMode: .inline)
        }
    }
}
struct Tab4ContentView:View{
    @EnvironmentObject var setting:UserSettings
    var body: some View{
        ZStack {
            VStack{
                Spacer().frame(height : 20)
                VStack(spacing: screenHeight/25) {
                    
                    //Edit Profile Details
                    Button(action:{
                        withAnimation(.easeOut){
                            
                        }
                    }){
                        HStack{
                            Image("person")
                                .padding(.leading, 20)
                            Text("계정관리")
                                .font(.system(size: 16))
                                .padding(.leading, 14)
                            Spacer(minLength: 0)
                            Image("chevronRight")
                                .padding(.trailing, 12)
                            
                        }
                        
                    }.buttonStyle(PlainButtonStyle())
                    
                    //Logout
                    Button(action:{
                        UserApi.shared.logout {(error) in
                            if let error = error {
                                print(error)
                            }
                            else {
                                self.setting.isLogin = false
                                print("logout() success.")
                            }
                        }
                        withAnimation(.easeOut){
                            
                        }
                    }){
                        HStack{
                            Image("logOut")
                                .padding(.leading, 20)
                            Text("로그아웃")
                                .font(.system(size: 16))
                                .padding(.leading, 14)
                            Spacer(minLength: 0)
                            Image("chevronRight")
                                .padding(.trailing, 12)
                        }
                    }.buttonStyle(PlainButtonStyle())
                }.padding(.bottom, screenHeight/14.5)
                
                VStack(spacing: screenHeight/25) {
                    
                    //서비스 약관
                    Button(action:{
                        withAnimation(.easeIn){
                            
                        }
                    }){
                        
                        HStack{
                            Image("file")
                                .padding(.leading, 20)
                            Text("서비스 약관")
                                .font(.system(size: 16))
                                .padding(.leading, 14)
                            Spacer(minLength: 0)
                            Image("chevronRight")
                                .padding(.trailing, 12)
                            
                        }
                        
                    }.buttonStyle(PlainButtonStyle())
                    
                    //개인정보처리방침
                    Button(action:{
                        withAnimation(.easeOut){
                            
                        }
                    }){
                        HStack{
                            Image("file")
                                .padding(.leading, 20)
                            Text("개인정보처리방침")
                                .font(.system(size: 16))
                                .padding(.leading, 14)
                            Spacer(minLength: 0)
                            Image("chevronRight")
                                .padding(.trailing, 12)
                            
                        }
                        
                    }.buttonStyle(PlainButtonStyle())
                    
                    //사업자정보
                    Button(action:{
                        withAnimation(.easeOut){
                            
                        }
                    }){
                        HStack{
                            Image("minusCircle")
                                .padding(.leading, 20)
                            Text("사업자정보")
                                .font(.system(size: 16))
                                .padding(.leading, 14)
                            Spacer(minLength: 0)
                            Image("chevronRight")
                                .padding(.trailing, 12)
                            
                        }
                    }.buttonStyle(PlainButtonStyle())
                    
                }
                
                HStack {
                    //버전정보
                    Text("버전정보: V 2.0.5")
                        .padding(.leading, 20)
                        .font(.system(size: 14))
                        .foregroundColor(Color("blue600"))
                    Spacer(minLength: 0)
                }.padding(.top, screenHeight/20)
                
                Spacer(minLength: 0)
                
            }
        }
    }
}
