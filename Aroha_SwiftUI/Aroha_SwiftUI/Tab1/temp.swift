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

    let dest = Pos(37.53969283119606,127.07282707914266)
    let scene = SceneLocationView()
    var locationManager = CLLocationManager()
    var txtSCN:SCNText = SCNText(string: "tqtqtqtq", extrusionDepth: 0.5)
    
    @Binding var log:String
    func makeUIView(context: UIViewRepresentableContext<ARSceneViewHolder>) -> SCNView{
        locationManager.delegate = context.coordinator
        GPSSetting()
        scene.run()
        return scene;
    }
    func updateUIView(_ uiView: SCNView, context: Context) {
        print("호출됨")
        guard let coord = (locationManager.location?.coordinate) else{ // locationManager 값이 nil일 경우
            print("안됨");
            return
        }
        let boxNode = SCNNode(geometry: txtSCN)
        let locationNode = LocationNode(location: CLLocation(latitude: coord.latitude, longitude: coord.longitude))
//        let boxNode = SCNNode(geometry: txtSCN)
//        let locationNode = LocationNode(location: CLLocation(latitude: 37.541397497580704, longitude: 127.09980830971979))

        locationNode.addChildNode(boxNode)
        scene.addLocationNodeWithConfirmedLocation(locationNode: locationNode)
    }
    
    final class Coordinator:NSObject,SceneLocationViewDelegate,CLLocationManagerDelegate{
        var parent: ARSceneViewHolder
        init(_ parent:ARSceneViewHolder){
            print("init")
            self.parent = parent
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("update location")
            if let coor = manager.location?.coordinate{
                parent.txtSCN.string = "\(parent.dest.calcDistance(pos: Pos(Double(coor.latitude),Double(coor.longitude))))"
                print("latitude" + String(coor.latitude) + "/ longitude" + String(coor.longitude))
                parent.log = "latitude" + String(coor.latitude) + "/ longitude" + String(coor.longitude)
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

struct DemoVideoStreaming: View {
    @Binding var log:String
    var body: some View {
        VStack {
            ARSceneViewHolder(log: $log)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}
