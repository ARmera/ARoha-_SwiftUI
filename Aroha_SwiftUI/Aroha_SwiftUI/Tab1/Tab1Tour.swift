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

struct Tab1TourView : View{
    @EnvironmentObject var settings:UserSettings
    @State var log:String = "초기값"
    
    var body:some View{
        VStack{
            ARSceneViewHolder(log: $log)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            HStack{
                Text("현재위치: \(log)").frame(maxWidth: .infinity, alignment: .center)
                Button(action: {
                    print("스탬프 인식")
                    if let scene = self.settings.scene_instance {
                        let pic = scene.snapshot()
                        print("스냅샷 촬영됨")
                        self.uploadImg(pic)
                    }else{
                        print("스냅샷 촬영안됨")
                    }
                }){
                    Text("스탬프 인식").foregroundColor(.black)
                        .frame(width : 100,alignment: .trailing)
                }.padding()
            }
            //Image(uiImage: self.settings.test).frame(width: 100, height: 100, alignment: .center)
            AR_MaPWebView( request: URLRequest(url: URL(string : "https://ar.konk.uk/kdh/rsync/map.html")!))
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
        let url = "http://ar.konk.uk:8080/upload" // https 일 경우 오류 발생!
        let imgData = pic.jpegData(compressionQuality: 0.2)! // compression값이 커질수록 이미지 품질향상.
        AF.upload(multipartFormData: { multipartFormData in

        multipartFormData.append(Data("test".utf8), withName: "check")
        multipartFormData.append(imgData, withName: "image",fileName: "test.jpg", mimeType: "image/jpg")

        }, to: url).responseString { response in
            print(response)
        }
    }
}

struct Tab1Tour_Previews: PreviewProvider {
    static var previews: some View {
        Tab1TourView()
    }
}
