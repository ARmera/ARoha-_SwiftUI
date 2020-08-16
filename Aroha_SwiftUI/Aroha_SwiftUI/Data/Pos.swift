//
//  Pos.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/08.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import MapKit

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
        return abs(R*c)
    }
    
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    func getBearingBetweenTwoPoints1(point2 : Pos) -> Double {

        let lat1 = degreesToRadians(degrees: self.lat)
        let lon1 = degreesToRadians(degrees: self.lng)

        let lat2 = degreesToRadians(degrees: point2.lat)
        let lon2 = degreesToRadians(degrees: point2.lng)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radians: radiansBearing)
    }

    
}
