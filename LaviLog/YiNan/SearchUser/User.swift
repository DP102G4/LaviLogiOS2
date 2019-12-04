//
//  User.swift
//  LaviLog
//
//  Created by 田乙男 on 2019/12/3.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import Foundation

struct User{
    var account:String?
    var birthDay:String?
    var gender:String?
    var id:String?
    var imagePath:String?
    var name:String?
    var password:String?
    var phone:String?
    var status:String?
    var verificationCode:String?
    var verificationId:String?
}

extension User {
    init(dic:[String:Any]){
        self.account = dic["account"] as? String ?? ""
        self.birthDay = dic["birthDay"] as? String ?? ""
        self.gender = dic["gender"] as? String ?? ""
        self.id = dic["id"] as? String ?? ""
        self.imagePath = dic["imagePath"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.password = dic["password"] as? String ?? ""
        self.phone = dic["phone"] as? String ?? ""
        self.status = dic["status"] as? String ?? ""
        self.verificationCode = dic["verificationCode"] as? String ?? ""
        self.verificationId = dic["verificationId"] as? String ?? ""
    }
}
