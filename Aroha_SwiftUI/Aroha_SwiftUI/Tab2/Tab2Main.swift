//
//  Tab2Main.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI

struct Tab2MainView:View{
    var body:some View{
        NavigationView{
            Text("Hello World!")
                .navigationBarTitle(Text("전체 투어 명소").font(.subheadline), displayMode: .inline)
        }    }
}
