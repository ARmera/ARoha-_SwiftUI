import SwiftUI
import UIKit
import AVFoundation
//새로 추가
import ARCL
import SceneKit
import CoreLocation

struct ARSceneViewHolder: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    var scene = SceneLocationView()
    var locationManager = CLLocationManager()
    @EnvironmentObject var settings:UserSettings
    @Binding var log:String
    
    //view생성 시 한번만 호출 됨.
    func makeUIView(context: UIViewRepresentableContext<ARSceneViewHolder>) -> SCNView{
        self.settings.scene_instance = scene
        locationManager.delegate = context.coordinator
        GPSSetting()
        let initial_coord = locationManager.location?.coordinate
        showAnimationObject(coordinate: initial_coord!)
        scene.run()
        return scene
    }
    
    //부모 uiView가 업데이트 되면 호출 됨.
    func updateUIView(_ uiView: SCNView, context: Context) {
//        guard let (locationManager.location?.coordinate)!=nil else{ // locationManager 값이 nil일 경우
//            print("현재 위치를 받아 올 수 없습니다.");
//            return
//        }
        
//        let boxNode = SCNNode(geometry: txtSCN)
//        let locationNode = LocationNode(location: CLLocation(latitude: 37.542249729731786, longitude: 127.07782375328537))
//        locationNode.addChildNode(boxNode)
//        scene.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
    }
    
    final class Coordinator:NSObject,SceneLocationViewDelegate,CLLocationManagerDelegate{
        var parent: ARSceneViewHolder
        var sign_num : Int = 0;
        var txtSCN:SCNText = SCNText(string: "initial", extrusionDepth: 0.5)
        
        init(_ parent:ARSceneViewHolder){
            self.parent = parent
            txtSCN.firstMaterial?.diffuse.contents = UIColor.black
            txtSCN.firstMaterial?.diffuse.contents = UIFont(name: "HelveticaNeue-Medium", size: 30)
        }
        //Delegate : 위치 정보 업데이트
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let coor = manager.location?.coordinate{
                //asyn로 routeList가 전달되지 않았으면
                if self.parent.settings.currentRouteList.count == 0 {return}
                //initial rendering
                if self.sign_num == 0{
                    print("initial rendering")
                    showARObject(index: 0)
                    showARObject(index: 1)
                    sign_num = 1
                }
                //보여지고 있는 표지판
                let sign = self.parent.settings.currentRouteList[sign_num]
                //내 거리와 표지판 사이의 거리
                let distance = sign.calcDistance(pos: Pos(coor.latitude, coor.longitude))
                if distance <= 3 && sign_num<self.parent.settings.currentRouteList.count-1{
                    sign_num += 1
                    showARObject(index: sign_num)
                };
                self.txtSCN.string = "\(String(format:"%.2f",distance)) m"
                parent.log = "latitude" + String(coor.latitude) + "/ longitude" + String(coor.longitude)
            }
        }
                
        //특정 위치에 AR을 Rendering & 위치에 띄워주는 함수
        func showARObject(index:Int){
            let position = Pos(self.parent.settings.currentRouteList[index].lat, self.parent.settings.currentRouteList[index].lng)
            let turntype = self.parent.settings.currentRouteProperties[index]["turnType"] as! Int
            print("turntype : \(turntype)")
            
            //Text
            let boxNode = SCNNode(geometry: txtSCN)
            boxNode.scale = SCNVector3(0.3,0.3,0.3)
            let locationNode = LocationNode(location: CLLocation(latitude: position.lat, longitude: position.lng))
            
            //obj
            let plane = SCNPlane(width: 30.0 , height: 30.0)
            let image = UIImage(named: "\(turntype)")
            let material = SCNMaterial()
            material.locksAmbientWithDiffuse = true
            material.isDoubleSided = false
            material.diffuse.contents = image
            material.ambient.contents = UIColor.white
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.geometry?.materials = [material]
            
            locationNode.addChildNode(planeNode)
            locationNode.addChildNode(boxNode)
            
            self.parent.scene.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
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
    
    func showAnimationObject(coordinate:CLLocationCoordinate2D){
        let tempScene = SCNScene(named:"KU.dae")!
        let material = SCNMaterial()
        let shape = tempScene.rootNode
        
        shape.childNode(withName: "model", recursively: true)
        shape.scale = SCNVector3(3, 3, 3)
        material.diffuse.contents = UIImage(named : "1")
        shape.geometry?.firstMaterial = material
        let locationnode = LocationNode(location: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
        locationnode.addChildNode(shape)
        scene.addLocationNodeWithConfirmedLocation(locationNode: locationnode)
    }
}

//struct DemoVideoStreaming: View {
//    @Binding var log:String
//    var body: some View {
//        VStack {
//            ARSceneViewHolder(log: $log)
//        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
//    }
//}
