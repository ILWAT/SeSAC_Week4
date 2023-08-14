//
//  UserDefaultHelper.swift
//  SeSACWeek4
//
//  Created by 문정호 on 2023/08/14.
//

import Foundation


class UserDefaultHelper {
    
    //싱글톤
    static let standard = UserDefaultHelper()
    
    private init() { } //초기화를 제한해서 외부에서의 접근을 제어함 => '접근 제어자'
    
    let userDefaults = UserDefaults.standard
    
    
    //클래스 내부에 있는 열거형은 접근 제한을 해주는 느낌임.
    //여러 파일에 영향을 안 미치기 때문에 컴파일 시간을 줄여 '컴파일 최적화'에 도움이 됨.
    enum Key: String {
        case nickname, age
    }
    
    var nickname: String {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        
        set {
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
}
