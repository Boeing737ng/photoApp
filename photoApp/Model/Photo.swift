//
//  Photo.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/06/25.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Foundation

struct SearchResult:Decodable {
    let total:Int?
    let total_pages:Int?
    let results:[ImageDetail]
}

struct ImageDetail:Decodable {
    let id: String
    let created_at: String?
    let updated_at: String?
    let width: Int?
    let height: Int?
    let color: String?
    let description: String?
    let user: User?
    let urls: ImageURLs
    let links: Links?
    let likes: Int?
}
