//
//  HttpRequest.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/10.
//  Copyright © 2020 김성헌. All rights reserved.
//
import Foundation


enum APIRoute{ case
    route,
    beacon,
    selectroute(select: String)
    
    var path:String{
        switch self {
        case .route: return "route"
        case .beacon: return "beacon"
        case .selectroute(let select): return "route/\(select)"
        }
    }
    
    func url() -> String {
        return "\(URLRoot.DataRoot.rawValue)\(path)/"
    }
}
