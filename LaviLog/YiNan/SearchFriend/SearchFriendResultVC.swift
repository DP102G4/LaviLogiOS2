//
//  SearchFriendResultVC.swift
//  LaviLog
//
//  Created by 田乙男 on 2019/11/25.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import UIKit

class SearchFriendResultVC: UIViewController {
    
    @IBOutlet weak var ivFriend: UIImageView!
    @IBOutlet weak var lbFriend: UILabel!
    
    var friend: Friend!
    var images = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //let image = images[friend!.imagePath!]
        ivFriend.image = images[friend.imagePath!]
        lbFriend.text = friend.name
    }

}
