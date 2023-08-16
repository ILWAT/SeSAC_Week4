//
//  VideoViewController.swift
//  SeSACWeek4
//
//  Created by 문정호 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct Video {
    let author: String
    let date: String
    let time: Int
    let thumbnail: String
    let title: String
    let url: String
    
    var contents: String{
        get { //get scope는 생략 가능
            return "\(author) | \(time)회\n\(date)"
        }
    }
}


class VideoViewController: UIViewController {
    
    @IBOutlet weak var videoTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var videoList: [Document] = []
    var pageNumber = 1
    var isEnd = false //현재 페이지가 마지막 페이지인지 점검하는 프로퍼티
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoTableView.delegate = self
        videoTableView.dataSource = self
        videoTableView.prefetchDataSource = self
        videoTableView.rowHeight = 140
        
        searchBar.delegate = self
    }
    
    func callRequest(query: String, page: Int) {
//        let text = "아이유".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://dapi.kakao.com/v2/search/vclip?query=\(text)&size=30&page=\(page)"
        let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakaoKey)"]
        
        print(url)
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseDecodable(of: KakaoVideoData.self) { response in
            switch response.result{
            case .success(let value):
                print(value)
                self.videoList = value.documents
                self.videoTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
//        responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
////                print("JSON: \(json)")
//
//                let statusCode = response.response?.statusCode ?? 500
//
//                if statusCode == 200{
//
//                    self.isEnd = json["meta"]["is_end"].boolValue
//
//                    for item in json["documents"].arrayValue{
//                        let author = item["author"].stringValue
//                        let date = item["datetime"].stringValue
//                        let title = item["title"].stringValue
//                        let time = item["play_time"].intValue
//                        let thumbnail = item["thumbnail"].stringValue
//                        let link = item["url"].stringValue
//
//                        let data = Video(author: author, date: date, time: time, thumbnail: thumbnail, title: title, url: link)
//
//                        self.videoList.append(data)
//
////                        print(self.videoList)
//
//                        self.videoTableView.reloadData()
//                    }
//                } else {
//                    print("문제가 발생했어요. 잠시후 다시 시도해주세요.")
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
    }

}


//UITableViewDataSourcePrefetching: iOS10 이상 사용 가능한 프로토콜, cellForRowAt 메서드가 호출 되기 전에 미리 호출됨
extension VideoViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell") as? VideoTableViewCell else { return UITableViewCell()}
        
        cell.titleLabel.text = videoList[indexPath.row].title
        cell.contentLabel.text = String(videoList[indexPath.row].playTime)
        
        if let url = URL(string: videoList[indexPath.row].thumbnail){
            cell.thumbnailImageView.kf.setImage(with: url)
        }
        
        
        return cell
    }
    
    //셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    //videoList 갯수와 indexPath.row 위치를 비교해 마지막 스크롤 시점을 확인 -> 네트워크 요청 시도
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if videoList.count - 1 == indexPath.row && pageNumber < 15 && !isEnd {
                pageNumber += 1
                callRequest(query: searchBar.text!, page: pageNumber)
            }
        }
    }
    
    //취소 기능: 직접 취소하는 기능을 구현해주어야 함!
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("===취소: \(indexPaths)")
    }
}

extension VideoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let inputText = searchBar.text else { return }
        
        pageNumber = 1 //새로운 검색어이기 때문에 page를 1로 변경
        videoList.removeAll()
        
        callRequest(query: inputText, page: pageNumber)
    }

}
