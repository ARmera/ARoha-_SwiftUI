//
//  Pretreatment .swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/10.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import MapKit

func Data_to_CLLocation(data:Data)->([Pos],[[String:Any]]){
    var routeList = [Pos]()
    var featureList = [[String:Any]]()
    do{
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        let features = json!["features"]! as! [[String:Any]]
        for item in features{
            let geometry = item["geometry"] as! [String:Any]
            if geometry["type"] as! String != "Point" {continue}
            let coordinate = geometry["coordinates"] as! [Double]
            let properties = item["properties"] as! [String:Any]
            routeList.append(Pos(coordinate[1], coordinate[0]))
            featureList.append(properties)
        }
    }catch{
        fatalError("Not Convert to JSON")
    }
    return (routeList,featureList);
}

func convertBeaconSummary2Anno(beaconinfos:[BeaconSummaryInfo])->[CustomPointAnnotation]{
    var ret = [CustomPointAnnotation]()
    for item in beaconinfos{
        let title = item.title
        let coord = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        ret.append(CustomPointAnnotation(coordinate: coord, title: title))
    }
    return ret;
}

func convertBeacon2Anno(beaconinfos:[BeaconInfo])->[CustomPointAnnotation]{
    var ret = [CustomPointAnnotation]()
    for item in beaconinfos{
        let title = item.title
        let coord = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        ret.append(CustomPointAnnotation(coordinate: coord, title: title))
    }
    return ret;
}

extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}
