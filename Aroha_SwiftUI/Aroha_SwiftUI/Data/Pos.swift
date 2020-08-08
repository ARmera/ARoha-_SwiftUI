//
//  Pos.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/08.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation

class Pos { // 좌표 class
    var lat:Double
    var lng:Double
    init(){
        self.lat=0;
        self.lng=0;
    }
    init(_ lat:Double,_ lng:Double) {
        self.lat = lat
        self.lng = lng
    }
    func updateCoord(_ lat:Double,_ lng:Double){
        self.lat = lat
        self.lng = lng
    }
    func calcDistance(pos:Pos!) -> Double{ // 좌표 거리 계산하는 function
        let R = 6371e3; // metres
        let φ1 = self.lat * Double.pi / 180; // φ, λ in radians
        let φ2 = pos.lat * Double.pi / 180;
        let Δφ = (pos.lat - self.lat) * Double.pi / 180;
        let Δλ = (pos.lng - self.lng) * Double.pi / 180;
        let a = sin(Δφ / 2) * sin(Δφ / 2) + cos(φ1) * cos(φ2) * sin(Δλ / 2) * sin(Δλ / 2);
        let c = 2 * atan2(sqrt(a), sqrt(1 - a));
        print(String("결과: "),abs(R * c))// in metres
        return abs(R*c)
    }
    
}
