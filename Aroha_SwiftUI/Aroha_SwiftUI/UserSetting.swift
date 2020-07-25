//
//  UserEnvironmetData.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation

class UserSettings:ObservableObject{
    @Published var isLogin = false;
    @Published var tabselected = 0;
}
enum tabMenu:Int{
    case CamputTourTab1 = 0
    case TourLocationTab2 = 1
    case StampTab3 = 2
    case MyPageTab4 = 3
}
