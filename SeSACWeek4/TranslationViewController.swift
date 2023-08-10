//
//  TranslationViewController.swift
//  SeSACWeek4
//
//  Created by 문정호 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

class TranslationViewController: UIViewController {

    @IBOutlet weak var translateTextView: UITextView!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var origianlTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setPlaceHolder()
        origianlTextView.delegate = self
        
        setUI()
    }
    
    func setUI(){
        translateTextView.layer.cornerRadius = 5
        translateTextView.layer.borderWidth = 1
        translateTextView.layer.borderColor = UIColor.black.cgColor
        
        origianlTextView.layer.cornerRadius = 5
        origianlTextView.layer.borderWidth = 1
        origianlTextView.layer.borderColor = UIColor.black.cgColor
        
        requestButton.layer.cornerRadius = 5
        requestButton.layer.borderWidth = 1
        requestButton.layer.borderColor = UIColor.black.cgColor
        requestButton.setTitle("번역", for: .normal)
    }

    @IBAction func requestButtonClicked(_ sender: UIButton) {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let langDetectURL = "https://openapi.naver.com/v1/papago/detectLangs"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.naverClientID,
            "X-Naver-Client-Secret": APIKey.naverClientSecret
        ]
        var detectLangResult: String = ""
        
        // 언어 감지 API
        guard let inputText = origianlTextView.text else {return}
        
        let langDetectParameters: Parameters = [
            "query" : inputText
        ]
        
        AF.request(langDetectURL, method: .post, parameters: langDetectParameters, headers: header).validate().responseJSON{ response in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                detectLangResult = json["langCode"].stringValue
                
                let parameters:Parameters = [
                    "source": json["langCode"].stringValue,
                    "target": "en",
                    "text": self.origianlTextView.text ?? ""
                ]
                
                AF.request(url, method: .post, parameters: parameters ,headers: header).validate().responseJSON{ response in
                    switch response.result{
                    case .success(let value):
                        let json = JSON(value)
                        print(json)
                        
                        let translateResult = json["message"]["result"]["translatedText"].stringValue
                        self.translateTextView.text = translateResult
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
        
        print(detectLangResult)
        
        
        
    }
    
    
    func setPlaceHolder(){
        self.origianlTextView.text = "내용을 입력해 주세요."
        self.origianlTextView.textColor = .gray
        self.translateTextView.text = ""
        translateTextView.isEditable = false
    }
}

extension TranslationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.origianlTextView.text = ""
        self.origianlTextView.textColor = .black
    }
}
