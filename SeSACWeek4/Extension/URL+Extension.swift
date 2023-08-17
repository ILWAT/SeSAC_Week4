//
//  URL+Extension.swift
//  SeSACWeek4
//
//  Created by 문정호 on 2023/08/14.
//

import Foundation

extension URL {
    static let baseURL = "https://dapi.kakao.com/v2/search/"
    
    static func makeEndPointingString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}
