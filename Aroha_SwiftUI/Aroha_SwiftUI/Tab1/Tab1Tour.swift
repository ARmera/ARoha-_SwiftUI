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
    @State var showStamp = -1
    @State var showdirection:[Bool] = [false,false]
    @State var building_num = 0
    @State var customMode:Bool = false
    @State var imgNum:Int = 0
    @State var distance:String = ""
    @State var showAlert:Bool = false
    var body:some View{
        VStack{
            ZStack{
                ZStack(alignment: .top){
                    if(!customMode){
                        ARSceneViewHolder(log: $log, showDirection: $showdirection)
//                        HStack{
//                            if showdirection[1]{
//                                Image(systemName: "chevron.left.2")
//                                    .foregroundColor(Color.blue)
//                                .frame(width: 50, height: 50, alignment: .center)
//                            }
//                            Spacer()
//                            if showdirection[0]{
//                                Image(systemName: "chevron.right.2")
//                                    .foregroundColor(Color.blue)
//                                .frame(width: 50, height: 50, alignment: .center)
//                            }
//                        }
                    }
                    else{
                        ARSceneViewHolder2(imgNum: self.$imgNum, distance: self.$distance)
                        HStack{
                            HStack{
                                Image("\(imgNum)").resizable().frame(width: 50, height: 50, alignment: .center).padding()
                                Text("\(distance)")
                            }
                            Spacer()
                        }
                    }
                    HStack(alignment: .top){
                        Spacer()
                        Button(action: {
                            updateProperty = true
                            self.customMode.toggle()
                        }){
                            Image(systemName: "arrow.2.circlepath").frame(width: 50, height: 50, alignment: .center)
                                .background(Color("blue200"))
                        }
                    }

                }
                if showStamp != -1{
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
        .alert(isPresented:self.$showAlert){
            Alert(title: Text("권한 허용 에러"),message: Text("권한을 허용하지 않으면, 투어 기능을 사용할 수 없습니다."),primaryButton: .destructive(Text("재요청"),action: {checkPermission()}), secondaryButton: .cancel())
        }.onAppear(){
            checkPermission()
        }
        
        
    }
    private func checkPermission(){
        print("checkPermission")
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                self.showAlert = false
                print("response \(response)")
            } else {
                print("response \(response)")
                self.showAlert = true
            }
        }
    }
//    private func uploadImg( _ pic:UIImage){ // 이미지 프로세싱 & 식별을 위해 snapshot을 서버로 전송
//        let url = "http://api.ar.konk.uk/stamp" // https 일 경우 오류 발생!
//        let imgData = pic.jpegData(compressionQuality: 0.2)! // compression값이 커질수록 이미지 품질향상.
//        AF.upload(multipartFormData: { multipartFormData in
//            multipartFormData.append(Data("test".utf8), withName: "check")
//            multipartFormData.append(imgData, withName: "image",fileName: "test.jpg", mimeType: "image/jpg")
//        }, to: url).responseString { response in
//            switch response.result{
//            case .success:
//                print("업로드 이미지 : \(response.result)")
//                self.showStamp = true
//                return
//            default : return
//            }
//        }
//    }
    
    private func uploadImg( _ pic:UIImage){ // 이미지 프로세싱 & 식별을 위해 snapshot을 서버로 전송
        let url = "http://api.ar.konk.uk/stamp" // https 일 경우 오류 발생!
        let imgData = pic.jpegData(compressionQuality: 0.2)! // compression값이 커질수록 이미지 품질향상.
        print("이미지 : \(imgData)")
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data("test".utf8), withName: "check")
            multipartFormData.append(imgData, withName: "image",fileName: "test.jpg", mimeType: "image/jpg")
        }, to: url).responseData{ response in
            switch response.result{
            case .success(let value):
                do{
                    let response = try JSONDecoder().decode(stampCheckInfo.self, from: value)
                    print("업로드 이미지 : \(response.result)")
                    if response.result != "FALSE"{
                        self.showStamp = Int(atoi(response.result))
                        self.settings.UserGetStamp.stamp_status.append(Int(atoi(response.result)))
                        UserDefaults.standard.setValue(self.settings.UserGetStamp, forKey: "UserGetStamp")
                    }else{
                        self.showStamp = 0
                    }
                }catch{
                    print("JSONDecoder().decode DecodingError")
                }
            case .failure(let error):
                print("failure \(error)")
            }
        }
    }
}

struct Popupview:View{
    @Binding var showPopup:Int
    var body: some View{
        VStack{
            if showPopup > 0{
                Text("스탬프 획득").font(Font.custom("HelveticaNeue-Bold", size: 10))
                    .padding(.horizontal, 10)
                StampImageView(withURL: URLRoot.ImageSource.rawValue + String(showPopup))
            }else if showPopup == 0{
                Text("해당하는 스탬프가 없습니다").font(Font.custom("HelveticaNeue-Bold", size: 10))
                    .padding(.horizontal, 10).foregroundColor(.red)
                Image(systemName: "x.circle.fill")
            }
        }.onTapGesture {
            self.showPopup = -1
        }
        .padding(.all, 5.0)
        .foregroundColor(Color.black)
        .background(RoundedRectangle(cornerRadius: 18).foregroundColor(Color("blue200")))
    }
}

