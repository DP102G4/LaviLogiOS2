//
//  Friend.swift
//  LaviLog
//
//  Created by 田乙男 on 2019/11/25.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import Foundation

struct Friend {
    var account: String?
    var friend_account: String?
    var id: String?
    var imagePath: String?
    var name: String?
}

extension Friend {
    init(dic: [String: Any]) {
        account = dic["account"] as? String ?? ""
        friend_account = dic["friend_account"] as? String ?? ""
        id = dic["id"] as? String ?? ""
        imagePath = dic["imagePath"] as? String ?? ""
        name = dic["name"] as? String ?? ""
    }
}
