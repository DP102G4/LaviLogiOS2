//
//  GenQRCodeVC.swift
//  LaviLog
//
//  Created by 田乙男 on 2019/11/25.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import UIKit
import Firebase

class GenQRCodeVC: UIViewController {
    
    // 標題 ＸＸＸ 的 QR Code
    @IBOutlet weak var lbTitle: UILabel!
    // QR Code的圖
    @IBOutlet weak var imageView: UIImageView!
    // 說明暫時用不到
    @IBOutlet weak var label: UILabel!
    
    
    var db: Firestore!
    
    // 實體化一個Users物件
    var user = Users()
    
    override func viewDidLoad() {
        
        // 標題圓角設定
        lbTitle.layer.cornerRadius = 10
        lbTitle.layer.masksToBounds = true
        
        if let account = Auth.auth().currentUser!.email {
            db = Firestore.firestore()
            loadFireStore()
            
            // 將文字轉成Data，編碼採ASCII
            let data = account.data(using: String.Encoding.ascii)
            // 建立CIFilter物件，準備產生QR code
            guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
            // 使用CIFilter產生QR code要給予key-"inputMessage", value-文字值
            ciFilter.setValue(data, forKey: "inputMessage")
            // 取得產生好的QR code圖片，不過圖片很小
            guard let ciImage_smallQR = ciFilter.outputImage else { return }
            
            // QR code圖片很小，需要放大
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let ciImage_largeQR = ciImage_smallQR.transformed(by: transform)
            // 將CIImage轉成UIImage顯示
            let uiImage = UIImage(ciImage: ciImage_largeQR)
            imageView.image = uiImage
            
            print("QRCode:",account)
        }
    }
    
    //取得登入帳號
    func loadFireStore() {
        // 建立儲藏庫實體
        db.collection("users").whereField("account", isEqualTo: Auth.auth().currentUser!.email).getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    self.user = Users(dic: document.data())
                    //let textT = self.user.name!
                    
                    // 標題改文字 使用者名稱
                    self.lbTitle.text = "\(self.user.name!) 的 QR Code"
                }
            }
        }
    }
    
    
    
    @IBAction func clickGenerate(_ sender: Any) {
        let text = "tasi@gmail.com"
        
        //        let text = textField.text == nil ? "" : textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //        if text.isEmpty {
        //            imageView.image = nil
        //            textField.text = ""
        //            return
        //        }
        
        // 將文字轉成Data，編碼採ASCII
        let data = text.data(using: String.Encoding.ascii)
        // 建立CIFilter物件，準備產生QR code
        guard let ciFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        // 使用CIFilter產生QR code要給予key-"inputMessage", value-文字值
        ciFilter.setValue(data, forKey: "inputMessage")
        // 取得產生好的QR code圖片，不過圖片很小
        guard let ciImage_smallQR = ciFilter.outputImage else { return }
        
        // QR code圖片很小，需要放大
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let ciImage_largeQR = ciImage_smallQR.transformed(by: transform)
        // 將CIImage轉成UIImage顯示
        let uiImage = UIImage(ciImage: ciImage_largeQR)
        imageView.image = uiImage
    }
    
    // 返回前一頁
    @IBAction func btClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // 分享按鈕
    @IBAction func btShare(_ sender: Any) {
        
        // activityItems 陣列中放入我們想要使用的元件，這邊我們放入使用者圖片、使用者名稱及個人部落格。
        // 這邊因為我們確認裡面有值，所以使用驚嘆號強制解包。
        let activityVC = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            
            // 如果錯誤存在，跳出錯誤視窗並顯示給使用者。
            if error != nil {
                self.showAlert(title: "Error", message: "Error:\(error!.localizedDescription)")
                return
            }
            
            // 如果發送成功，跳出提示視窗顯示成功。
            if completed {
                self.showAlert(title: "傳送成功", message: "傳送了我的QR Code")
            }
            
        }
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(title:String,message:String) {
        let alertController = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

