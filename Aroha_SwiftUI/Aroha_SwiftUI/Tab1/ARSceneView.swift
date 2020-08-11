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

    let dest = Pos(37.542249729731786,127.07782375328537)
    let scene = SceneLocationView()
    var locationManager = CLLocationManager()
    var txtSCN:SCNText = SCNText(string: "initial", extrusionDepth: 0.5)
    @EnvironmentObject var settings:UserSettings
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
            print("안됨\n");
            return
        }
        let boxNode = SCNNode(geometry: txtSCN)
        //latitude37.542249729731786/ longitude127.07782375328537
        let locationNode = LocationNode(location: CLLocation(latitude: 37.542249729731786, longitude: 127.07782375328537))
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
                //지워야함
                parent.settings.test = parent.scene.snapshot()
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
