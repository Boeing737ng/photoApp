//
//  Links.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/06/25.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Foundation

struct Links: Decodable {
    let selfLink:String
    let html:String
    let download:String
    let download_location:String
    
    enum keys:String {
        // "Swift 'self' 키워드 때문에 따로 구분"
        case selfLink = "self"
    }
}
