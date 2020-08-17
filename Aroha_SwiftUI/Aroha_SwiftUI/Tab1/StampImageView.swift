//
//  StampImageView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/17.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI

struct StampImageView:View{
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()
    
    init(withURL url:String){
        imageLoader = ImageLoader(urlString: url)
    }
    
    var body:some View{
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:100, height:100)
            .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
        }
    }
}
