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
    var nodePositionLabel: UILabel! = UILabel()

    @State var sign_num : Int = 0;
    @EnvironmentObject var settings:UserSettings
    @Binding var log:String
    @Binding var showDirection:[Bool]
    @State var txtSCN:SCNText = SCNText(string: "initial", extrusionDepth: 0.5)
    //view생성 시 한번만 호출 됨.
    func makeUIView(context: UIViewRepresentableContext<ARSceneViewHolder>) -> SCNView{
        self.settings.scene_instance = scene
        locationManager.startUpdatingHeading()
        locationManager.delegate = context.coordinator
        scene.locationNodeTouchDelegate = context.coordinator
        GPSSetting()
        scene.run()
        return scene
    }
    
    //부모 uiView가 업데이트 되면 호출 됨.
    func updateUIView(_ uiView: SCNView, context: Context) {
        if updateProperty{
            for item in (uiView as! SceneLocationView).locationNodes{
                (uiView as! SceneLocationView).removeLocationNode(locationNode: item)
            }
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
                (uiView as! SceneLocationView).addLocationNodesWithConfirmedLocation(locationNodes: [annotationNode,annotationNode2])
            }
            
            self.sign_num = 0;
            //showARObject(scene: uiView as! SceneLocationView,index: 0)
            showARObject(scene: uiView as! SceneLocationView,index: 1)
            self.sign_num = 1
            print("uiView \(uiView as! SceneLocationView)")
            updateProperty = false
        }
        
//        if updateUILabel{
//            print("updateUILabel")
//            let coordinate = CLLocationCoordinate2D(latitude: LabelCoordinate.latitude, longitude: LabelCoordinate.longitude)
//            let location = CLLocation(coordinate: coordinate, altitude:60)
//            let image = UIImage(systemName: "pin.fill")!
//            //image.text = UILabelString
//            let annotationNode = LocationAnnotationNode(location: location, image: image)
//            (uiView as! SceneLocationView).addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
//            updateUILabel = false
//        }
    }
    
    final class Coordinator:NSObject,SceneLocationViewDelegate,CLLocationManagerDelegate,LNTouchDelegate{
        func locationNodeTouched(node: LocationNode) {
        }
        
        
        func annotationNodeTouched(node: AnnotationNode) {
            if let node = node.parent as? LocationNode{
                let coords = "\(node.location.coordinate.latitude.short)° \(node.location.coordinate.longitude.short)°"
                let altitude = "\(node.location.altitude.short)m"
                let tag = node.tag ?? ""
                LabelCoordinate = node.location.coordinate
                UILabelString = " Annotation node at \(coords), \(altitude) - \(tag)"
                updateUILabel = true
            }
        }
        
        var parent: ARSceneViewHolder

        init(_ parent:ARSceneViewHolder){
            self.parent = parent
            self.parent.txtSCN.firstMaterial?.diffuse.contents = UIColor.black
            self.parent.txtSCN.firstMaterial?.diffuse.contents = UIFont(name: "HelveticaNeue-Medium", size: 30)
        }
        
        // 디바이스의 head를 움직일때마다 호출
        func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
            
            if self.parent.settings.currentRouteList.count == 0 {return}
            guard let location = self.parent.locationManager.location else{
                return
            }
            let current = location.coordinate
            let current_pos = Pos(current.latitude, current.longitude)
            let compare = newHeading.trueHeading - 360;
            
            //적절한 위치입니다.
            if abs(compare - current_pos.getBearingBetweenTwoPoints1(point2: self.parent.settings.currentRouteList[self.parent.sign_num])) <= 20.0{
                self.parent.showDirection[0] = false
                self.parent.showDirection[1] = false
            }
            else{
                //오른쪽
                if(abs(compare - current_pos.getBearingBetweenTwoPoints1(point2: self.parent.settings.currentRouteList[self.parent.sign_num])) > 180){
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
                //보여지고 있는 표지판
                if self.parent.sign_num >= self.parent.settings.currentRouteList.count {return}
                let sign = self.parent.settings.currentRouteList[self.parent.sign_num]
                //let description = self.parent.settings.currentRouteProperties[self.parent.sign_num]["description"]
                //내 거리와 표지판 사이의 거리
                let distance = sign.calcDistance(pos: Pos(coor.latitude, coor.longitude))
                
                if distance <= 3 && self.parent.sign_num<self.parent.settings.currentRouteList.count-1{
                    self.parent.sign_num += 1
                    self.parent.showARObject(index: self.parent.sign_num)
                };
                self.parent.txtSCN.string = "\(String(format:"%.2f",distance)) m"
            }
        }
        
    }
    
    //특정 위치에 AR을 Rendering & 위치에 띄워주는 함수
    func showARObject(index:Int){
        if index >= self.settings.currentRouteList.count {return}
        let position = Pos(self.settings.currentRouteList[index].lat, self.settings.currentRouteList[index].lng)
        
        let turntype = self.settings.currentRouteProperties[index]["turnType"] as! Int
        
        let locationNode = LocationNode(location: CLLocation(coordinate: CLLocationCoordinate2D(latitude: position.lat, longitude: position.lng), altitude: 15))
        
        if let currentFrame  = self.scene.session.currentFrame {
            let rotate = simd_float4x4(SCNMatrix4MakeRotation(currentFrame.camera.eulerAngles.y, 0, 1, 0))
            let rotateTransform = simd_mul(locationNode.simdWorldTransform,rotate)
            print("position \(position.lat) / \(position.lng)")
            
            locationNode.transform = SCNMatrix4(rotateTransform)
            
            //Polyline
            //            let next_position = Pos(self.parent.settings.currentRouteList[index+1].lat, self.parent.settings.currentRouteList[index+1].lng)
            //
            //            self.parent.addPolyline(polyline_pos: [CLLocationCoordinate2D(latitude: position.lat, longitude: position.lng),CLLocationCoordinate2D(latitude: next_position.lat, longitude: next_position.lng)])
        }
        
        locationNode.addChildNode(self.makeSigneNode(turntype: turntype))
        locationNode.addChildNode(self.makeAnimationNode())
        locationNode.addChildNode(self.makeTextNode(txtSCN: txtSCN))
        self.scene.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
        print("addLoctaionNode \(locationNode)")
        print("addLocationNode \(scene)")
        self.scene.autoenablesDefaultLighting = true
    }
    
    func showARObject(scene:SceneLocationView,index:Int){
        
        if index >= self.settings.currentRouteList.count {return}
        let position = Pos(self.settings.currentRouteList[index].lat, self.settings.currentRouteList[index].lng)
        
        let turntype = self.settings.currentRouteProperties[index]["turnType"] as! Int
        
        let locationNode = LocationNode(location: CLLocation(coordinate: CLLocationCoordinate2D(latitude: position.lat, longitude: position.lng), altitude: 15))
        
        if let currentFrame  = self.scene.session.currentFrame {
            let rotate = simd_float4x4(SCNMatrix4MakeRotation(currentFrame.camera.eulerAngles.y, 0, 1, 0))
            let rotateTransform = simd_mul(locationNode.simdWorldTransform,rotate)
            print("position \(position.lat) / \(position.lng)")
            locationNode.transform = SCNMatrix4(rotateTransform)
        }
        
        locationNode.addChildNode(self.makeAnimationNode())
        locationNode.addChildNode(self.makeTextNode(txtSCN: txtSCN))
        print("make \(makeSigneNode(turntype: turntype))")
        print("make \(makeAnimationNode())")
        print("make \(makeTextNode(txtSCN: txtSCN))")
        //var image = UIImage(named: "\(turntype)")!
        let image = resizeImage(image: UIImage(named: "\(turntype)")!, newWidth: 150)
        print("preimage \(UIImage(named: "\(turntype)")!)")
        print("image \(image)")
        scene.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
        scene.addLocationNodeWithConfirmedLocation(locationNode: LocationAnnotationNode(location: CLLocation(coordinate: CLLocationCoordinate2D(latitude: position.lat, longitude: position.lng), altitude: 15), image: image))
        scene.autoenablesDefaultLighting = true
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
        shape.scale = SCNVector3(4, 4, 4)
        shape.position = SCNVector3(0,0,0);
        material.diffuse.contents = UIImage(named : "1")
        shape.geometry?.firstMaterial = material
        return shape
    }
    
    //표지판 만들어줌
    func makeSigneNode(turntype: Int) -> SCNNode{
        let tempScene = SCNScene(named:"12.dae")!
        let material = SCNMaterial()
        let shape = tempScene.rootNode
        shape.scale = SCNVector3(3, 3, 3)
        shape.position = SCNVector3(0,0,0);
        material.diffuse.contents = UIImage(named : "1")
        shape.geometry?.firstMaterial = material
        return shape
    }
    
    //텍스트 만들어줌
    func makeTextNode(txtSCN : SCNText) -> SCNNode{
        let boxNode = SCNNode(geometry: txtSCN)
        boxNode.scale = SCNVector3(0.2,0.2,0.2)
        boxNode.position = SCNVector3(0,0,0)
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
