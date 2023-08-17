//
//  KakaoVideoData.swift
//  SeSACWeek4
//
//  Created by 문정호 on 2023/08/16.
//

import Foundation

// MARK: - KakaoVideoData
struct KakaoVideoData: Codable {
    let documents: [Document]
    let meta: Meta
}

// MARK: - Document
struct Document: Codable {
    let author, datetime: String
    let playTime: Int
    let thumbnail: String
    let title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case author, datetime
        case playTime = "play_time"
        case thumbnail, title, url
    }
}


// MARK: - Meta
struct Meta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
