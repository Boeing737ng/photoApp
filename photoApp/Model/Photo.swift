//
//  Photo.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/06/25.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Foundation

struct imageReponse:Decodable {
    let response:Images
}

struct Images:Decodable {
    let images:[ImageDetail]
}

struct ImageDetail:Decodable {
    let id:Int
    let created_at:String
    let updated_at:String
    let width:Int
    let height:Int
    let color:String
    let description:String
    let urls:ImageURLs
    let links:Links
    let likes:Int
}
