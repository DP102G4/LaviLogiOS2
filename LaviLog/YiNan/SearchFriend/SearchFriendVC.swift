//
//  SearchFriendVC.swift
//  LaviLog
//
//  Created by 田乙男 on 2019/11/25.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import UIKit
import Firebase

// SearchBar 要加 UISearchBarDelegate ！！
class SearchFriendVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var images = [String: UIImage]()
    var friends = [Friend]()
    
    var searchFriends = [Friend]() // 儲存搜尋結果資料
    var search = false // 是否要顯示搜尋後資料
    
    func getFriends() {
        var imagePaths = [String]()
        let db = Firestore.firestore() // 建立儲藏庫實體
        db.collection("friends").addSnapshotListener { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else {
                return
            }
            
            self.friends = querySnapshot.documents.map {
                Friend(dic: $0.data())
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
        
        getFriends()
    }
    
    // 點擊鍵盤上的Search按鈕時呼叫
    // 可以執⾏searchBar.resignFirstResponder()將鍵盤隱藏
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 點擊鍵盤上的Search按鈕時將鍵盤隱藏
        searchBar.resignFirstResponder()
    }
    
    // 當UISearchBar元件輸入的⽂字改變時呼叫
    // 依照輸入的關鍵字，原始資料array呼叫filter(_:)得到搜尋結果array提供給Table View呈現使⽤
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text ?? ""
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if text == "" {
            search = false
        } else {
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            searchFriends = friends.filter({ (friend) -> Bool in
                return friend.name!.uppercased().contains(text.uppercased())
            })
            search = true
        }
        tableView.reloadData()
    }
    
}

// 接續UIViewController使用UITableView
extension SearchFriendVC: UITableViewDataSource, UITableViewDelegate {
    // 定義⼀個區塊的列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //如果搜尋顯示搜尋結果否則顯示好友
        if search {
            return searchFriends.count
        } else {
            return friends.count
        }
    }
    
    // 將資料顯⽰在儲存格上
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var friend:Friend?
        
        if search {
            friend = searchFriends[indexPath.row]
        } else {
            friend = friends[indexPath.row]
        }
        
        // UITableViewCell的Style屬性設定為Subtitle，
        // 也可以程式碼設定detailTextLabel屬性來改變每⼀筆資料的副標⽂字。
        
        // 程式碼設定UITableViewCell的textLabel、imageView屬性來改變每⼀筆資料的主標與圖片
        let cellId = "friendCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! FriendCell
        
        let image = images[friend!.imagePath!]
        cell.ivFriend.image = image
        cell.lbFriend.text = friend?.name
        print(friend!.name)
        return cell
    }
    
    //覆寫tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath)
    //點選儲存格時會呼叫
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* Identifier必須設定與Indentity inspector的Storyboard ID相同 */
        
        //使⽤「as!」轉型成⽬的⾴⾯類型後將欲傳遞的值指派給該⾴屬性
        let searchFriendResultVC = self.storyboard?.instantiateViewController(withIdentifier: "searchFriendResultVC") as! SearchFriendResultVC
        let friend = friends[indexPath.row]
        searchFriendResultVC.friend = friend
        searchFriendResultVC.images = images
        self.navigationController?.pushViewController(searchFriendResultVC, animated: true)
        
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
            friends.remove(at: indexPath.row)
            /* 提供array，儲存著欲刪除資料的indexPath。如果只刪除一筆資料，array內存放一個indexPath元素即可 */
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
}
