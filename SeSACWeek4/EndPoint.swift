//
//  EndPoint.swift
//  SeSACWeek4
//
//  Created by 문정호 on 2023/08/14.
//

import Foundation

enum EndPoint {
    case blog
    case cafe
    case video
    
    var url: String {
        switch self {
        case .blog:
            return URL.makeEndPointingString("blog?query=")
        case .cafe:
            return URL.makeEndPointingString("cafe?query=")
        case .video:
            return URL.makeEndPointingString("vclip?query=")
        }
    }
}
