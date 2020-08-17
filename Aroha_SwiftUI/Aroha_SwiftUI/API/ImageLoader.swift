//
//  ImageLoader.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/17.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import Alamofire
import Combine

class ImageLoader:ObservableObject{
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data(){
        didSet{
            didChange.send(data)
        }
    }
    init(urlString :String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
        
    }
}
