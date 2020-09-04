//
//  MapViewSettings.swift
//  PintweenTravel
//
//  Created by 김성헌 on 2020/08/19.
//  Copyright © 2020 Pintween, Inc. All rights reserved.
//
import Foundation
import Mapbox

func setCenter(annotations:[CustomPointAnnotation])->(CLLocationCoordinate2D) {
    
    var latitudeAvg = 0.0
    var longitudeAvg = 0.0
    for item in annotations{
        latitudeAvg += item.coordinate.latitude
        longitudeAvg += item.coordinate.longitude
    }
    latitudeAvg /= Double(annotations.count)
    longitudeAvg /= Double(annotations.count)
    if latitudeAvg.isNaN || longitudeAvg.isNaN  { return CLLocationCoordinate2D(latitude: 0, longitude: 0) }
    else { return CLLocationCoordinate2D(latitude: latitudeAvg, longitude: longitudeAvg) }
}

func setZoomLevel(annotations:[CustomPointAnnotation])->(Double,Double) {
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }
    if annotations.count == 0 { return (0,0) }
    let latitudeAvg = setCenter(annotations: annotations).latitude
    let longitudeAvg = setCenter(annotations: annotations).longitude
    
    
    
    var maxLength = 0.0
    var zoomLevel = 0
    for item in annotations{
        let longitude = item.coordinate.longitude
        let latitude = item.coordinate.latitude
        let theta = longitudeAvg - longitude
        var dist = sin(deg2rad(latitude)) * sin(deg2rad(latitudeAvg)) + cos(deg2rad(latitude)) * cos(deg2rad(latitudeAvg)) * cos(deg2rad(theta))
        dist = acos(dist)
        dist = rad2deg(dist)
        dist = dist * 60 * 1.1515 * 1609.344
        maxLength = max(maxLength,dist)
    }
    switch maxLength/1000.0 {
    case 5547.0...99999999:
        zoomLevel = 0
    case 2773.0...5547.0:
        zoomLevel = 1
    case 1387.0...2773.0:
        zoomLevel = 2
    case 693.0...1387.0:
        zoomLevel = 3
    case 347.0...693.0:
        zoomLevel = 4
    case 173.0...347.0:
        zoomLevel = 5
    case 86.7...173.0:
        zoomLevel = 6
    case 43.3...86.7:
        zoomLevel = 7
    case 21.7...43.3:
        zoomLevel = 8
    case 10.8...21.7:
        zoomLevel = 9
    case 5.4...10.8:
        zoomLevel = 10
    case 2.7...5.4:
        zoomLevel = 11
    case 1.35...2.7:
        zoomLevel = 12
    case 0.677...1.35:
        zoomLevel = 13
    case 0.339...0.677:
        zoomLevel = 14
    case 0.169...0.339:
        zoomLevel = 15
    case 0.0846...0.169:
        zoomLevel = 16
    case 0.0423...0.0846:
        zoomLevel = 17
    case 0.0212...0.0423:
        zoomLevel = 18
    case 0.000...0.0212:
        zoomLevel = 19
    default:
        zoomLevel = 0
    }

    return (Double(zoomLevel),Double(maxLength))
}




extension UIApplication {
    static var mapBoxToken: String? {
        return Bundle.main.object(forInfoDictionaryKey: "MGLMapboxAccessToken") as? String
    }
    //키보드 숨기기 함수
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
