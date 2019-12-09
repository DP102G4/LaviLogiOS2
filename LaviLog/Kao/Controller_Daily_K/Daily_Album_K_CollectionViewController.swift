//
//  Daily_Album_K_CollectionViewController.swift
//  LaviLog
//
//  Created by Kao on 2019/12/6.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Firebase



private let reuseIdentifier = "Cell"

class Daily_Album_K_CollectionViewController: UICollectionViewController {
    
    var dailyAlbums = [QueryDocumentSnapshot]()
    var fullScreenSize:CGSize!
    
    func getDailyAlbum(){
        let db = Firestore.firestore()
        db.collection("article").order(by: "textClock",descending: true).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                self.dailyAlbums = querySnapshot.documents
                self.collectionView.reloadData()
                print(self.dailyAlbums.count)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取得螢幕尺存
        fullScreenSize = UIScreen.main.bounds.size
        //設定UICollectionView背景色
        collectionView.backgroundColor = UIColor.green
        //取得UICollectionView排版物件
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //設定內容與邊間的艱鉅
        layout.sectionInset = UIEdgeInsets(top: 25, left: 2, bottom: 25, right: 2)
        //設定每一列的間距
        layout.minimumLineSpacing = 25
        //設定每個項目尺寸
        layout.itemSize = CGSize(width: CGFloat(fullScreenSize.width)/3 - 10.0, height: CGFloat(fullScreenSize.width)/3 - 10.0)
        //設定header及footer的尺寸
        layout.headerReferenceSize = CGSize(width: fullScreenSize.width, height: 40)
        layout.footerReferenceSize = CGSize(width: fullScreenSize.width, height: 40)
        
        
        getDailyAlbum()
        
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    //    override func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dailyAlbums.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! Daily_Album_K_CollectionViewCell
        let dailyAlbum = dailyAlbums[indexPath.row].data()
        let dailyAlbumStr = (dailyAlbum["imagePath"] as? String)!
        let dailyAlbumURL = URL(string: dailyAlbumStr)!
        let dailyAlbumData = try? Data(contentsOf: dailyAlbumURL)
        let dailyAlbumImage = UIImage(data: dailyAlbumData!)
        cell.DailyImage.image = dailyAlbumImage
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
