//
//  Links.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/06/25.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Foundation

struct Links: Decodable {
    let selfLink: String?
    let html: String?
    let download: String?
    let download_location: String?
    
    enum CodingKeys:String, CodingKey {
        // "Swift 'self' 키워드 때문에 따로 구분"
        case selfLink = "self"
        case html
        case download
        case download_location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        selfLink = try container.decode(String.self, forKey: .selfLink)
        html = try container.decode(String.self, forKey: .html)
        download = try container.decode(String.self, forKey: .download)
        download_location = try container.decode(String.self, forKey: .download_location)
    }
}
