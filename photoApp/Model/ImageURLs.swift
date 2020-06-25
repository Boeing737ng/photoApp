//
//  ImageURLs.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/06/25.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Foundation

struct ImageURLs: Decodable {
    let full: String
    let raw: String
    let regular: String
    let small: String
    let thumb: String
}
