//
//  Tab1Tour.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation
import Alamofire
import Mapbox

struct Tab1TourView : View{
    @EnvironmentObject var settings:UserSettings
    @State var log:String = "초기값"
    @State var showStamp = false
    @State var showdirection:[Bool] = [false,false]
    @State var building_num = 0
    var body:some View{
        VStack{
            ZStack{
                ARSceneViewHolder(log: $log, showDirection: $showdirection)
                HStack{
                    if showdirection[1]{
                        Image(systemName: "chevron.left.2")
                            .foregroundColor(Color.blue)
                        .frame(width: 50, height: 50, alignment: .center)
                    }
                    Spacer()
                    if showdirection[0]{
                        Image(systemName: "chevron.right.2")
                            .foregroundColor(Color.blue)
                        .frame(width: 50, height: 50, alignment: .center)
                    }
                    
                }
                if showStamp{
                    HStack{
                        Popupview(showPopup: $showStamp)
                            .animation(Animation.easeInOut(duration: 10.0))
                    }
                }
            }
            
            HStack{
                Spacer()
                Text("현재위치: \(self.settings.currentBeaconList[self.settings.tourVisitBeaconIndex].title)").font(Font.custom("HelveticaNeue-Bold", size: 12))
                Spacer()
                Button(action: {
                    if let scene = self.settings.scene_instance {
                        let pic = scene.snapshot()
                        self.uploadImg(pic)
                    }else{
                    }
                }){
                    HStack{
                        Image("stamp").resizable().frame(width: 12, height: 12, alignment: .center)
                        Text("스탬프 인식").font(Font.custom("HelveticaNeue-Bold", size: 12)).foregroundColor(Color("Primary"))
                    }.padding().border(Color("Primary")).cornerRadius(20)
                }
                
                Button(action: {
                    if(self.settings.tourVisitBeaconIndex < self.settings.currentBeaconList.count-1) {self.settings.tourVisitBeaconIndex += 1};
                }){
                    HStack{
                        Image(systemName: "hand.point.right.fill").resizable().frame(width: 12, height: 12, alignment: .center).foregroundColor(Color("Primary"))
                        Text("다음 위치").font(Font.custom("HelveticaNeue-Bold", size: 12)).foregroundColor(Color("Primary"))
                    }.padding().border(Color("Primary")).cornerRadius(20)
                }
                Spacer()
            }.border(Color.gray)
            //37.5407667,127.0771541
            TourMapView(annotations: self.settings.tourVisitBeaconIndex < self.settings.currentBeaconList.count - 1 ? [CustomPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: self.settings.currentBeaconList[self.settings.tourVisitBeaconIndex].latitude, longitude: self.settings.currentBeaconList[self.settings.tourVisitBeaconIndex].longitude), title: self.settings.currentBeaconList[self.settings.tourVisitBeaconIndex].title, index: self.settings.tourVisitBeaconIndex),CustomPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: self.settings.currentBeaconList[self.settings.tourVisitBeaconIndex+1].latitude, longitude: self.settings.currentBeaconList[self.settings.tourVisitBeaconIndex+1].longitude), title: self.settings.currentBeaconList[self.settings.tourVisitBeaconIndex+1].title, index: self.settings.tourVisitBeaconIndex+1)]: [CustomPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: self.settings.currentBeaconList[self.settings.tourVisitBeaconIndex].latitude, longitude: self.settings.currentBeaconList[self.settings.tourVisitBeaconIndex].longitude), title: self.settings.currentBeaconList[self.settings.tourVisitBeaconIndex].title, index: self.settings.tourVisitBeaconIndex)])
                .centerCoordinate(CLLocationCoordinate2D(latitude: 37.5407667 , longitude: 127.0771541))
                .zoomLevel(14)
        }
        
    }
    private func checkPermission(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                print("response \(response)")
            } else {
                print("response \(response)")
            }
        }
    }
    private func uploadImg( _ pic:UIImage){ // 이미지 프로세싱 & 식별을 위해 snapshot을 서버로 전송
        let url = "http://api.ar.konk.uk/stamp" // https 일 경우 오류 발생!
        let imgData = pic.jpegData(compressionQuality: 0.2)! // compression값이 커질수록 이미지 품질향상.
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data("test".utf8), withName: "check")
            multipartFormData.append(imgData, withName: "image",fileName: "test.jpg", mimeType: "image/jpg")
            
        }, to: url).responseString { response in
            switch response.result{
            case .success:
                print(response.result)
                self.showStamp = true
                return
            default : return
            }
        }
    }
}

struct Popupview:View{
    @Binding var showPopup:Bool
    var body: some View{
        VStack{
            Text("스탬프 획득").font(Font.custom("HelveticaNeue-Bold", size: 10))
                .padding(.horizontal, 10)
            StampImageView(withURL: URLRoot.ImageSource.rawValue + String(2))
        }.onTapGesture {
            self.showPopup = false
        }
        .padding(.all, 5.0)
        .foregroundColor(Color.black)
        .background(RoundedRectangle(cornerRadius: 18)
        .foregroundColor(Color.blue.opacity(0.2)))
    }
}




struct Tab1Tour_Previews: PreviewProvider {
    @State var showpopup = true
    static var previews: some View {
        Popupview(showPopup: .constant(true))
    }
}
