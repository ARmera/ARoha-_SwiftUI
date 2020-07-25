//
//  ContentView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var setting:UserSettings
    var body: some View {
        ZStack{
            if self.setting.isLogin{
                HomeView()
            }else{
                LoginView()
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
