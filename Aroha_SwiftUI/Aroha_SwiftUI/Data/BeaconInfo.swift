//
//  BeaconInfo.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/29.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation

struct ResponseRoute : Decodable,Hashable{
    var beacon_list:[BeaconInfo]
}

struct BeaconInfo : Decodable,Hashable{
    var title:String
    var description:String
    var longitude:Double
    var latitude:Double
    var index:Int
}
