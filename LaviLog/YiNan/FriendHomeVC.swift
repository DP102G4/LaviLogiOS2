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
    
    //實體化一個Users物件
    var user = Users()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 使變數account等於登入的帳號
        if let account = Auth.auth().currentUser!.email {
            // 使畫面的gmail等於登入的gmail
            lbGmail.text = account
            db = Firestore.firestore()
            
            // 取得登入帳號的方法
            loadFireStore()
        }
    }
    
    // 取得登入相片的方法
    override func viewWillAppear(_ animated: Bool) {
        downloadPhoto()
    }
    
    // 取得登入帳號
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
