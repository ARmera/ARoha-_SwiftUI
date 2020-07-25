//
//  LoginView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var setting:UserSettings
    var body: some View {
        VStack{
            VStack(alignment: .center){
                Image("main-logo").resizable().frame(width: 100, height: 100, alignment: .center)
                Text("AroHa!").font(.footnote)
            }
            Button(action: {
                self.setting.isLogin = true
            }){
                HStack(spacing : 10){
                    Image("kakao-login").resizable()
                }
            }.frame(width: 300, height: 50, alignment: .center)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
