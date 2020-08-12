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
}

struct Tab1Tour_Previews: PreviewProvider {
    static var previews: some View {
        Tab1TourView()
    }
}
