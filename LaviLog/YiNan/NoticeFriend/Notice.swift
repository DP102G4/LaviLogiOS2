//
//  Notice.swift
//  
//
//  Created by 田乙男 on 2019/12/2.
//

import Foundation

struct Notice {
    var account: String?
    var id: String?
    var inviteAccount: String?
    var nImagePath: String?
    var noticeMessage: String?
    var noticeMessage2: String?
    var noticeTime: String?
    var status: String?
    // 0 已發送未同意未拒絕
    // 1 已發送已接受
    // 2 已發送已拒絕
}

extension Notice {
    init(dic: [String: Any]) {
        account = dic["account"] as? String ?? ""
        id = dic["id"] as? String ?? ""
        inviteAccount = dic["inviteAccount"] as? String ?? ""
        nImagePath = dic["nImagePath"] as? String ?? ""
        noticeMessage = dic["noticeMessage"] as? String ?? ""
        noticeMessage2 = dic["noticeMessage2"] as? String ?? ""
        noticeTime = dic["noticeTime"] as? String ?? ""
        status = dic["status"] as? String ?? ""
    }
}
