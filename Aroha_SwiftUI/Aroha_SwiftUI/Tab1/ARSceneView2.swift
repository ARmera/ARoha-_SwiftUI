//
//  ARSceneView2.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/10/17.
//  Copyright © 2020 김성헌. All rights reserved.
//

import SwiftUI
import UIKit
import AVFoundation
//새로 추가
import ARCL
import SceneKit
import CoreLocation
import MapKit


struct ARSceneViewHolder2: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    var scene = SceneLocationView()
    var locationManager = CLLocationManager()
    @State var sign_num = 1
    
    @EnvironmentObject var settings:UserSettings
    @Binding var imgNum:Int
    @Binding var distance:String
    //view생성 시 한번만 호출 됨.
    func makeUIView(context: UIViewRepresentableContext<ARSceneViewHolder2>) -> SCNView{
        locationManager.startUpdatingHeading()
        locationManager.delegate = context.coordinator
        GPSSetting()
        scene.run()
        for item in AllBeaconInfo{
            print(item.title)
            let coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            let location = CLLocation(coordinate: coordinate, altitude: 50)
            let location2 = CLLocation(coordinate: coordinate, altitude: 80)
            let image = UIImage(named: "scenepin.png")!
            let annotationNode = LocationAnnotationNode(location: location, image:image)
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            label.text = "\(item.title)"
            label.font = UIFont(name: "BMJUA", size: 20)
            label.backgroundColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.5)

            label.textColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
            label.textAlignment = .center
            let annotationNode2 = LocationAnnotationNode(location: location2, view: label)
            (scene).addLocationNodesWithConfirmedLocation(locationNodes: [annotationNode,annotationNode2])
        }
        return scene
    }
    
    //부모 uiView가 업데이트 되면 호출 됨.
    func updateUIView(_ uiView: SCNView, context: Context) {
       
    }
    
    final class Coordinator:NSObject,SceneLocationViewDelegate,CLLocationManagerDelegate{
     
        var parent: ARSceneViewHolder2

        init(_ parent:ARSceneViewHolder2){
            self.parent = parent
        }
        
        // 디바이스의 head를 움직일때마다 호출
        func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
            
        }
        //Delegate : 위치 정보 업데이트
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            //asyn로 routeList가 전달되지 않았으면
            if let coor = manager.location?.coordinate{
                if self.parent.settings.currentRouteList.count == 0 {return}
                if self.parent.sign_num >= self.parent.settings.currentRouteList.count {return}
                let sign = self.parent.settings.currentRouteList[self.parent.sign_num]
                let distance = sign.calcDistance(pos: Pos(coor.latitude, coor.longitude))
                
                if distance <= 3 && self.parent.sign_num<self.parent.settings.currentRouteList.count-1{
                    self.parent.sign_num += 1
                };
                
                
                self.parent.distance = "\(String(format:"%.2f",distance)) m"
                self.parent.imgNum = self.parent.settings.currentRouteProperties[self.parent.sign_num]["turnType"] as! Int
            }
        }
        
    }
    
    
    func GPSSetting(){ // GPS 설정
        print("GPSSetting 실행됨")
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            //            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
   
    
}

