//
//  KakaoAPIManager.swift
//  SeSACWeek4
//
//  Created by 문정호 on 2023/08/14.
//

import Foundation
import Alamofire
import SwiftyJSON



class KakaoAPIManager {
    static let shared = KakaoAPIManager()
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoKey)"]
    
    private init() { } //Singleton(싱글턴) Pattern
    
    func callRequestJSON(type: EndPoint, query: String, completionHandler: @escaping (JSON)-> () ) {
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = type.url + text
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)

                completionHandler(json)
                
                
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    func callVideoRequest(type: EndPoint, query: String, page: Int, completionHandler: @escaping (KakaoVideoData)-> () ){
        guard let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = type.url + text + "&size=30&page=\(page)"
        
        AF.request(url, method: .get, headers: header).validate().responseDecodable(of: KakaoVideoData.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
