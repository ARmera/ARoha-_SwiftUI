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
    let screenHeight = UIScreen.main.bounds.size.height
    var body:some View{
        ZStack{
            MapView()
            SnapCarousel(UIState: UIStateModel()).offset(x: 0, y:  screenHeight/4 )
        }
    }
}
