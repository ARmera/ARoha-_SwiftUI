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
        ret.append(CustomPointAnnotation(coordinate: coord, title: title, index: -1))
    }
    return ret;
}

func convertBeacon2Anno(beaconinfos:[BeaconInfo])->[CustomPointAnnotation]{
    var ret = [CustomPointAnnotation]()
    for item in beaconinfos{
        let title = item.title
        let coord = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        ret.append(CustomPointAnnotation(coordinate: coord, title: title, index: item.index))
    }
    return ret;
}

func convertTitle2Img(kor:String)->String{
    switch kor {
    case "수의학관":
        return "animal"
    case "공학관":
        return "engineering"
    case "인문학관":
        return "accademy"
    case "입학정보관":
        return "architecture"
    case "이과대학":
        return "art"
    case "신공학관":
        return "business"
    case "와우도":
        return "commerce"
    case "황소상":
        return "craft"
    default:
        return "ecampus"
    }
}

func convertomonth(str:String) -> String{
    switch str {
    case "01":
        return "January"
    case "02":
        return "Feburary"
    case "03":
        return "March"
    case "04":
        return "April"
    case "05":
        return "May"
    case "06":
        return "June"
    case "07":
        return "July"
    case "08":
        return "August"
    case "09":
        return "September"
    case "10":
        return "October"
    case "11":
        return "November"
    case "12":
        return "December"
    default:
        print(str)
        return "ecampus"
    }
}

func endOfMonth(atMonth: Int) -> Int {
    let set30: [Int] = [1,3,5,7,8,10,12]
    var endDay: Int = 0
    if atMonth == 2 {
        endDay = 28
    }else if set30.contains(atMonth) {
        endDay = 31
    }else {
        endDay = 30
    }
    
    return endDay
}


func getWeekDay(month: Int, day: Int) -> String {
   
    let week: [String] = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var totalDay: Int = 0

    if month > 1 {
        for i in 1..<month {
            let endDay: Int = endOfMonth(atMonth: i)
            totalDay += endDay
        }
        
        totalDay = totalDay + day
        
    }else if month == 1 {
        totalDay = day
    }
    
    var index: Int = (totalDay) % 7

    if index > 0 {
        index = index - 1
    }
    
    return week[index]
}

extension Double {
    func toString() -> String {
        return String(format: "%.1f",self)
    }
}
