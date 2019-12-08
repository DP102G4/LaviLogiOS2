//
//  UserCell.swift
//  LaviLog
//
//  Created by 田乙男 on 2019/12/3.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    // 搜尋的圖片
    @IBOutlet weak var ivUser: UIImageView!
    //搜尋的好友名稱
    @IBOutlet weak var lbUser: UILabel!
    //加好友按鈕
    @IBOutlet weak var btAddUser: UIButton!
    //搜尋的好友帳號
    @IBOutlet weak var lbFriendAccount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //以下移動到SearchUserVC
    
//    // 點擊加入帳號按鈕
//    @IBAction func btUser(_ sender: Any) {
//
//        // 按鈕文字
//        btUser.setTitle("已傳送邀請", for: .normal)
//
//        // 按鈕是否可以使用
//        btUser.isEnabled = false
//
//        // 按鈕背景顏色
//        btUser.backgroundColor = UIColor.gray
//
//        // 按鈕文字顏色
//        btUser.setTitleColor(UIColor.white, for: .normal)
        
//        // 加進好友資料庫
//        let db = Firestore.firestore()
//        let data: [String: Any] = ["name": lbUser.text!]
//        var reference: DocumentReference?
//        reference = db.collection("friends").addDocument(data: data) { (error) in
//            if let error = error {
//                print("UserCell error : ",error)
//            } else {
//                print("UserCell reference?.documentID : ",reference?.documentID)
//                //self.navigationController.popViewController(animated: true)
//            }
//        }
        
//    }
    

}
