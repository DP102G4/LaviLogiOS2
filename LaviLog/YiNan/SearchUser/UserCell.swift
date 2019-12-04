//
//  UserCell.swift
//  LaviLog
//
//  Created by 田乙男 on 2019/12/3.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var ivUser: UIImageView!
    @IBOutlet weak var lbUser: UILabel!
    @IBOutlet weak var btUser: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 點擊加入帳號按鈕
    @IBAction func btUser(_ sender: Any) {
        
        // 按鈕文字
        btUser.setTitle("已傳送邀請", for: .normal)
        
        // 按鈕是否可以使用
        btUser.isEnabled = false
        
        // 按鈕背景顏色
        btUser.backgroundColor = UIColor.gray
        
        // 按鈕文字顏色
        btUser.setTitleColor(UIColor.white, for: .normal)
        
    }
    

}
