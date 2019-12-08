//
//  SearchUserVC.swift
//  LaviLog
//
//  Created by 田乙男 on 2019/11/25.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import UIKit
import Firebase

// SearchBar 要加 UISearchBarDelegate ！！
class SearchUserVC: UIViewController, UISearchBarDelegate {
    
    // 搜尋用戶
    @IBOutlet weak var searchBar: UISearchBar!
    // TavleView
    @IBOutlet weak var tableView: UITableView!
    
    // cell 裡的加好友按鈕
    //@IBOutlet weak var btAddUser: UIButton!
    // 這邊不可以這樣用! 要把下面 @IBAction func 的 Any 改成 UIButton
    
    var images = [String: UIImage]()
    var users = [User]()
    
    var db : Firestore!
    
    //實體化一個Users物件
    var user = Users()
    
    var accounts = ""
    
    var searchUsers = [User]() // 儲存搜尋結果資料
    var search = false // 是否要顯示搜尋後資料
    
    let date = NSDate() // 存時間
    let dateformatter = DateFormatter() // 時間
    
    var myUser = Users() // 存目前登入帳號的帳號
    var myImage = UIImage()
    
    func getUsers() {
        var imagePaths = [String]()
        let db = Firestore.firestore() // 建立儲藏庫實體
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                return
            }
            
            self.users = querySnapshot.documents.map {
                User(dic: $0.data())
            }
            
            self.tableView.reloadData()
            
            for snapshot in querySnapshot.documents {
                imagePaths.append(snapshot.data()["imagePath"] as! String)
                print("path",imagePaths)
                
                for imagePath in imagePaths {
                    let fileReference = Storage.storage().reference().child("\(imagePath)")
                    print("filepath",fileReference)
                    fileReference.getData(maxSize: .max) { (data, error) in
                        if let data = data, let image = UIImage(data: data) {
                            self.images[imagePath] = image
                            print("imagePath",imagePath)
                            print("self.images",self.images)
                        }else {
                            print(error?.localizedDescription)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getUsers()
        
        // 使變數account等於登入的帳號
        if let account = Auth.auth().currentUser!.email {
            // 使畫面的gmail等於登入的gmail
            accounts = account
            
            db = Firestore.firestore()
            
            // 取得登入帳號的方法
            loadFireStore()
            
            // 取得日期
            dateformatter.dateFormat = "yyyy/MM/dd HH:mm"
            let strNowTime = dateformatter.string(from: date as Date) as String
        }
    }
    
    // 之後要改登入方式要改～～～～～～～～～～
    
    // 取得登入帳號
    func loadFireStore() {
        // 建立儲藏庫實體
        db.collection("users").whereField("account", isEqualTo: Auth.auth().currentUser!.email).getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    self.user = Users(dic: document.data())
                    self.myUser = Users(dic: document.data())
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
                        self.myImage = image
                    }else {
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }
    
    // 取得登入相片的方法
    override func viewWillAppear(_ animated: Bool) {
        downloadPhoto()
    }
    
    
    // 點擊鍵盤上的Search按鈕時呼叫
    // 可以執⾏searchBar.resignFirstResponder()將鍵盤隱藏
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 點擊鍵盤上的Search按鈕時將鍵盤隱藏
        searchBar.resignFirstResponder() 
        
        let text = searchBar.text ?? ""
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if text == "" {
            search = false
        } else {
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            // user.account 搜尋帳號
            searchUsers = users.filter({ (user) -> Bool in
                return user.account!.uppercased().elementsEqual(text.uppercased())
            })
            search = true
        }
        tableView.reloadData()
    }
    
    // 當UISearchBar元件輸入的⽂字改變時呼叫
    // 依照輸入的關鍵字，原始資料array呼叫filter(_:)得到搜尋結果array提供給Table View呈現使⽤
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // 加入帳號頁面不需要關鍵字搜尋
    }
    
    // 按加入好友按鈕
    @IBAction func btAddUser(_ sender: UIButton) {
        
        // user = 點到的cell資料
        let user = users[sender.tag]
        
        // 按鈕文字
        sender.setTitle("已傳送邀請", for: .normal)
        
        // 按鈕是否可以使用
        sender.isEnabled = false
        
        // 按鈕背景顏色
        sender.backgroundColor = UIColor.gray
        
        // 按鈕背景顏色
        sender.setTitleColor(UIColor.white, for: .normal)

        
        // 加進好友資料庫
        let db = Firestore.firestore()
        
        var imagePathString = "no_image.jpg"
        let imagePath = Storage.storage().reference().child("images_friends/\(user.account!).jpg")
        imagePathString = "/images_friends/\(user.account!).jpg"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let image = images[user.imagePath!]
        let imageData = image?.jpegData(compressionQuality: 0.2)
        imagePath.putData(imageData!, metadata: metaData) { (data, error) in
            guard error == nil else { return }
            imagePath.downloadURL { (url, error) in
                print("\(url!)")
            }
        }
        
        // account = 登入的帳號==accunts，friend_account = 加入的用戶的帳號
        // imagePath = imagePath，name = 用戶名
        let data: [String: Any] = ["account": accounts, "friend_account": user.account,"id": user.id, "imagePath": imagePathString, "name": user.name!]
        var reference: DocumentReference?
        reference = db.collection("friends").addDocument(data: data) { (error) in
            if let error = error {
                print("UserCell error : ",error)
            } else {
                print("UserCell reference?.documentID : ",reference?.documentID)
            }
        }
        
        //--------------//
        // 加進通知資料庫
        // 取得目前時間
        let strNowTime = dateformatter.string(from: date as Date) as String
        
        var imagePathString2 = "no_image.jpg"
//        let imagePath2 = Storage.storage().reference().child("images_notices/\(myImage).jpg")
        imagePathString2 = "/images_users/\(accounts).jpg"
        let metaData2 = StorageMetadata()
        metaData2.contentType = "image/jpg"
        
        let image2 = images[user.imagePath!]
        let imageData2 = image2?.jpegData(compressionQuality: 0.2)
//        imagePath2.putData(imageData2!, metadata: metaData2) { (data2, error2) in
//            guard error2 == nil else { return }
//            imagePath2.downloadURL { (url, error) in
//                print("\(url!)")
//            }
//        }
        
        // 通知要另外取得自己帳號
        
        // account = 對方的帳號 因為我們要傳到對方的通知
        // noticeMessage = 自己的帳號 因為要顯示我傳邀請給對方
        let data2: [String: Any] = ["account": accounts, "id": user.id, "inviteAccount": user.account, "nImagePath": imagePathString2, "noticeMessage": myUser.name!, "noticeMessage2": "傳送了好友邀請", "noticeTime": strNowTime, "stastu": "0"]
        var reference2: DocumentReference?
        reference2 = db.collection("notices").addDocument(data: data2) { (error) in
            if let error = error {
                print("UserCell error : ",error)
            } else {
                print("UserCell reference?.documentID : ",reference2?.documentID)
            }
        }
        
        
    }
    
    
}



extension SearchUserVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search {
            return searchUsers.count
        } else {
            return users.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var user:User?
        
        if search {
            user = searchUsers[indexPath.row]
        } else {
            user = users[indexPath.row]
        }
        let cellId = "userCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! UserCell
        
        cell.btAddUser.tag = indexPath.row
        
        let image = images[user!.imagePath!]
        cell.ivUser.image = image
        cell.lbUser.text = user?.name
        cell.lbFriendAccount.text = user?.account
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* Identifier必須設定與Indentity inspector的Storyboard ID相同 */
        
        //        let searchFriendResultVC = self.storyboard?.instantiateViewController(withIdentifier: "searchFriendResultVC") as! SearchFriendResultVC
        //        let friend = friends[indexPath.row]
        //        searchFriendResultVC.friend = friend
        //        searchFriendResultVC.images = images
        //        self.navigationController?.pushViewController(searchFriendResultVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false) // 關閉點選灰色
    }
    
    /* 設定可否編輯資料列 */
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        //         if indexPath.row == 1{
        //             return false
        //         }
        //         //使第二個資料無法修改
        
        return true
    }
    
    /* 修改確定後，判斷編輯模式並作出回應 */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 按下Delete按鈕
        if editingStyle == .delete {
            users.remove(at: indexPath.row)
            /* 提供array，儲存著欲刪除資料的indexPath。如果只刪除一筆資料，array內存放一個indexPath元素即可 */
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    
}

