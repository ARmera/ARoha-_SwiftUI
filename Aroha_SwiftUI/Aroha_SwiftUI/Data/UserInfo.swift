//
//  UserInfo.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/09/14.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI

struct UsersStampInfo:Decodable,Hashable{
    var stamp_status:[Int]
    var stamp_achievement:Int
}
