//
//  ViewController.swift
//  SeSACWeek4
//
//  Created by 문정호 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Movie {
    var movieTitle: String
    var release: String
}

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var movieTableView: UITableView!
    
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest(date: "20221010")
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
        indicatorView.isHidden = true
    }

    func callRequest(date: String) {
        indicatorView.startAnimating()
        
        indicatorView.isHidden = false
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=\(date)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let name1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
                let name2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
                let name3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
                
                print(name1, name2, name3)
//                self.movieList.append(name1)
//                self.movieList.append(name2)
//                self.movieList.append(name3)
//                print(name, "=====")
                
                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    
                    let movieNm = item["movieNm"].stringValue
                    let openDt = item["openDt"].stringValue
                    
                    let data = Movie(movieTitle: movieNm, release: openDt)
                    self.movieList.append(data)
                }
                
                self.indicatorView.stopAnimating()
                self.indicatorView.isHidden = true
                self.movieTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //날짜 확인(ex: 20220101) : 1. 8글자인지 2. 올바른 날짜 인지 3.날짜 범주
        callRequest(date: searchBar.text!)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell")!
        
        cell.textLabel?.text = self.movieList[indexPath.row].movieTitle
        cell.detailTextLabel?.text = self.movieList[indexPath.row].release
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}

