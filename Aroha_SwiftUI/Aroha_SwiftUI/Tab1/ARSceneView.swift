import SwiftUI
import UIKit
import AVFoundation
//새로 추가
import ARCL
import SceneKit
import CoreLocation
import MapKit


struct ARSceneViewHolder: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    var scene = SceneLocationView()
    var locationManager = CLLocationManager()
    var correctDirectionGuide = SCNNode()
    @EnvironmentObject var settings:UserSettings
    @Binding var log:String
    @Binding var showDirection:[Bool]
    
    //view생성 시 한번만 호출 됨.
    func makeUIView(context: UIViewRepresentableContext<ARSceneViewHolder>) -> SCNView{
        self.settings.scene_instance = scene
        locationManager.startUpdatingHeading()
        locationManager.delegate = context.coordinator
        GPSSetting()
        scene.run()
        return scene
    }
    
    //부모 uiView가 업데이트 되면 호출 됨.
    func updateUIView(_ uiView: SCNView, context: Context) {
        print(scene.locationNodes)
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
        
        // 디바이스의 head를 움직일때마다 호출
        func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
            
            if self.parent.settings.currentRouteList.count == 0 {return}
            
            let current = self.parent.locationManager.location!.coordinate
            let current_pos = Pos(current.latitude, current.longitude)
            let compare = newHeading.trueHeading - 360;
     
            //적절한 위치입니다.
            if abs(compare - current_pos.getBearingBetweenTwoPoints1(point2: self.parent.settings.currentRouteList[sign_num])) <= 20.0{
                self.parent.showDirection[0] = false
                self.parent.showDirection[1] = false
            }
            else{
                //오른쪽
                if(abs(compare - current_pos.getBearingBetweenTwoPoints1(point2: self.parent.settings.currentRouteList[sign_num])) > 180){
                    self.parent.showDirection[0] = false
                    self.parent.showDirection[1] = true
                }
                //왼쪽
                else{
                    self.parent.showDirection[0] = true
                    self.parent.showDirection[1] = false
                }
            }
            
        }
        //Delegate : 위치 정보 업데이트
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let coor = manager.location?.coordinate{
                //asyn로 routeList가 전달되지 않았으면
                if self.parent.settings.currentRouteList.count == 0 {return}
                //크기 업데이트
                
                
                //initial rendering
                if self.sign_num == 0{
                    print("initial rendering")
                    //showARObject(index: 0)
                    showARObject(index: 1)
                    sign_num = 1
                }
                //보여지고 있는 표지판
                if self.sign_num >= self.parent.settings.currentRouteList.count {return}
                let sign = self.parent.settings.currentRouteList[sign_num]
                //내 거리와 표지판 사이의 거리
                let distance = sign.calcDistance(pos: Pos(coor.latitude, coor.longitude))
                
                //크기 업데이트
//                let current_nodes = self.parent.scene.sceneNode?.parent?.childNodes
//
//                for item in current_nodes!{
//                    var scale = 0
//                    if distance == 0 {scale = 15}
//                    else {scale = 15/Int(distance)}
//                    if scale <= 5 {scale = 10}
//                    item.scale = SCNVector3(scale,scale,scale)
//                }
                
                
                if distance <= 3 && sign_num<self.parent.settings.currentRouteList.count-1{
                    sign_num += 1
                    showARObject(index: sign_num)
                };
                self.txtSCN.string = "\(String(format:"%.2f",distance)) m"
                parent.log = "위도 : " + String(format: "%.1f",coor.longitude) + "/ 경도" + String(format: "%.1f",coor.latitude)
            }
        }
                
        //특정 위치에 AR을 Rendering & 위치에 띄워주는 함수
        func showARObject(index:Int){
            if index >= self.parent.settings.currentRouteList.count {return}
            let position = Pos(self.parent.settings.currentRouteList[index].lat, self.parent.settings.currentRouteList[index].lng)
            
            let turntype = self.parent.settings.currentRouteProperties[index]["turnType"] as! Int
            print("turntype : \(turntype)")
            
            let locationNode = LocationNode(location: CLLocation(coordinate: CLLocationCoordinate2D(latitude: position.lat, longitude: position.lng), altitude: 10))
            let rotate = simd_float4x4(SCNMatrix4MakeRotation(self.parent.scene.session.currentFrame!.camera.eulerAngles.y, 0, 1, 0))
            let rotateTransform = simd_mul(locationNode.simdWorldTransform,rotate)

            print("position \(position.lat) / \(position.lng)")
            
            locationNode.addChildNode(self.parent.makeSigneNode(turntype: turntype))
            locationNode.addChildNode(self.parent.makeAnimationNode())
            locationNode.addChildNode(self.parent.makeTextNode(txtSCN: txtSCN))
            locationNode.transform = SCNMatrix4(rotateTransform)
            
            //Polyline
//            let next_position = Pos(self.parent.settings.currentRouteList[index+1].lat, self.parent.settings.currentRouteList[index+1].lng)
//
//            self.parent.addPolyline(polyline_pos: [CLLocationCoordinate2D(latitude: position.lat, longitude: position.lng),CLLocationCoordinate2D(latitude: next_position.lat, longitude: next_position.lng)])
            
            self.parent.scene.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
            self.parent.scene.autoenablesDefaultLighting = true

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
    
    //움직이는 곰돌이 Object
    func makeAnimationNode() -> SCNNode{
        let tempScene = SCNScene(named:"KU.dae")!
        let material = SCNMaterial()
        let shape = tempScene.rootNode
        shape.childNode(withName: "model", recursively: true)
        shape.scale = SCNVector3(7, 7, 7)
        shape.position = SCNVector3(0,-50,0);
        material.diffuse.contents = UIImage(named : "1")
        shape.geometry?.firstMaterial = material
        return shape
    }
    
    //표지판 만들어줌
    func makeSigneNode(turntype: Int) -> SCNNode{
        let plane = SCNPlane(width: 50.0 , height: 50.0)
        let image = UIImage(named: "\(turntype)")?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
        let material = SCNMaterial()
        material.locksAmbientWithDiffuse = true
        material.isDoubleSided = false
        material.diffuse.contents = image
        //material.ambient.contents = UIColor.white
        
        let planeNode = SCNNode(geometry: plane)
        planeNode.geometry?.materials = [material]
        
        return planeNode
    }
    
    //텍스트 만들어줌
    func makeTextNode(txtSCN : SCNText) -> SCNNode{
        let boxNode = SCNNode(geometry: txtSCN)
        boxNode.scale = SCNVector3(1,1,1)
        boxNode.position = SCNVector3(0,-10,0)
        return boxNode;
    }
    
    //Polyline 그려주는 역할
    func addPolyline(polyline_pos:[CLLocationCoordinate2D]) {
        let box = SCNBox(width: 1, height: 0.2, length: 5, chamferRadius: 1)
        box.firstMaterial?.diffuse.contents = UIColor.gray.withAlphaComponent(0.8)
        let testline = MKPolyline(coordinates: polyline_pos, count: polyline_pos.count)
        scene.addPolylines(polylines: [testline]){ distance->SCNBox in
            let box = SCNBox(width: 3, height: 3, length: distance, chamferRadius: 5)
                box.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.8)
                return box
        }
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
