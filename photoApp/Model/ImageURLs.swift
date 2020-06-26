//
//  ImageURLs.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/06/25.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Foundation

struct ImageURLs: Decodable {
    let full: URL
    let raw: URL
    let regular: URL
    let small: URL
    let thumb: URL
}
