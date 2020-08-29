//
//  RouteInfo.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/29.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation

struct RouteInfo : Decodable,Hashable{
    var id:Int
    var title:String
    var estimated_time:Double
    var total_distance:Double
}
