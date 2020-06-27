//
//  User.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/06/27.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Foundation

struct User:Decodable {
    let id:String
    let updated_at:String
    let username:String
}
