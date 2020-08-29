//
//  enum.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/11.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import MapKit


enum URLRoot:String{
    case TMapRoute = "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result"
    case ImageSource = "http://api.ar.konk.uk/image/"
    case DataRoot = "http://api.ar.konk.uk/"

}

enum tabMenu:Int{
    case CamputTourTab1 = 0
    case TourLocationTab2 = 1
    case StampTab3 = 2
    case MyPageTab4 = 3
}
