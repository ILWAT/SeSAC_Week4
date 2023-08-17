//
//  ReusableProtocol.swift
//  SeSACWeek4
//
//  Created by 문정호 on 2023/08/14.
//

import Foundation
import UIKit

protocol ReusableProtocol {
    static var identifier: String { get }
}

extension UIViewController: ReusableProtocol {
    
    //연산프로퍼티로 해야 상황에 따라 유동적으로 대처할 수 있음.
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableProtocol {
    
    static var identifier: String {
        return String(describing: self)
    }
}
