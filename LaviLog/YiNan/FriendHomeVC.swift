//
//  FriendHomeVC.swift
//  LaviLog
//
//  Created by 田乙男 on 2019/11/25.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import UIKit
import Firebase

class FriendHomeVC: UIViewController {
    
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbGmail: UILabel!
    
    var db : Firestore!
    var user = Users()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let account = Auth.auth().currentUser!.email {
            lbGmail.text = account
            db = Firestore.firestore()
            loadFireStore()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        downloadPhoto()
    }
    
    //取得登入帳號
    func loadFireStore() {
        // 建立儲藏庫實體
        db.collection("users").whereField("account", isEqualTo: Auth.auth().currentUser!.email).getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    self.user = Users(dic: document.data())
                    self.lbName.text = self.user.name!
                }
            }
        }
    }
    
    // 取得登入相片
    func downloadPhoto() {
        var imagePath = ""
        let db = Firestore.firestore()
        db.collection("users").whereField("account", isEqualTo: "\(Auth.auth().currentUser!.email!)").addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                return
            }
            for snapshot in querySnapshot.documents {
                imagePath = snapshot.data()["imagePath"] as! String
                let fileReference = Storage.storage().reference().child("\(imagePath)")
                fileReference.getData(maxSize: .max) { (data, error) in
                    if let data = data, let image = UIImage(data: data) {
                        self.ivPhoto.image = image
                    }else {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
}
