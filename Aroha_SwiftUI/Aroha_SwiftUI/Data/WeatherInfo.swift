//
//  WeatherInfo.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/09/15.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation

//{"weather":"구름많음, 어제보다 2˚ 높아요","dust":"30 ㎍/㎥ $(dust[2])"}

struct WeatherInfo:Decodable,Hashable{
    var weather:String
    var dust:String
}
