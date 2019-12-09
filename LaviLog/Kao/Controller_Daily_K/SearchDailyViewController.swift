//
//  SearchDailyViewController.swift
//  LaviLog
//
//  Created by Kao on 2019/12/3.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import Firebase

class SearchDailyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate {
    
    
    
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var searchTV: UITableView!
    
    @IBOutlet weak var dailySearchBar: UISearchBar!
    
    
    var articles = [QueryDocumentSnapshot]()
    
    //測試搜尋用
    //儲存搜尋結果資料
    var searchedArray = [QueryDocumentSnapshot]()
    let datePicker = UIDatePicker()
    //是否顯示搜尋後資料
    var search = false
    
    
    
    //取FIrebase資料
    func getArticle(){
        let db = Firestore.firestore()
        db.collection("article").order(by: "textClock",descending: true).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                self.articles = querySnapshot.documents
                self.searchTV.reloadData()
                print(self.articles.count)
            }
        }
    }
    
    
    //    //刪除
    //     func deleteArticle() {
    //        let db = Firestore.firestore()
    //        db.collection("article").document().delete(){ error in
    //            if let error = error{
    //                print(error)
    //            }else{
    //                print("刪除成功")
    //            }
    //
    //        }
    //    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getArticle()
        
        
        createDatePicker()
        
        //以下測試
        for str in articles{
            searchedArray.append(str)
        }
        searchTV.dataSource = self
        dateTextField.delegate = self
        //以上測試
    }
    
    //以下測試searchbar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text ?? ""
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if text == ""  {
            search = false
        } else {
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            searchedArray = articles.filter({ (article) -> Bool in
                let time = article["textClock"] as? String
                print("文章資訊：\(String(describing: time))")
                return ("\(String(describing: time!))".lowercased().elementsEqual(text.lowercased()))
                
                
            })
            search = true
        }
        searchTV.reloadData()
    }
    //以上測試searchbar
    
    
    //建立datePicker
    func createDatePicker(){
        
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(SearchDailyViewController.datePickerValueChanged(sender:)), for:
            UIControl.Event.valueChanged)
        dateTextField.inputView = datePicker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbar.barStyle = UIBarStyle.black
        toolbar.tintColor = UIColor.white
        
        let todayButton =  UIBarButtonItem(title: "Today", style: UIBarButtonItem.Style.plain, target: self, action: #selector(SearchDailyViewController.todayPressed(sender:)))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(SearchDailyViewController.donePressed(sender:)))
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.green
        label.textAlignment = NSTextAlignment.center
        label.text = "選擇日期"
        
        let labelButton = UIBarButtonItem(customView: label)
        toolbar.setItems([todayButton,flexButton,labelButton,doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
        
        
        
        
    }
    
    
    
    
    //DatePicker func
    @objc func donePressed(sender:UIBarButtonItem){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        formatter.dateFormat = "yyyy/MM/dd"
        dateTextField.text = formatter.string(from: datePicker.date)
        dailySearchBar.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        dateTextField.resignFirstResponder()
        self.view.endEditing(true)
        dailySearchBar.resignFirstResponder()
        
    }
    
    @objc func todayPressed(sender:UIBarButtonItem){
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        formatter.dateFormat = "yyyy/MM/dd"
        dateTextField.text = formatter.string(from: NSDate() as Date)
        dailySearchBar.text = formatter.string(from: NSDate() as Date)
        dateTextField.resignFirstResponder()
        dailySearchBar.resignFirstResponder()
        
        
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker)  {
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        formatter.dateFormat = "yyyy/MM/dd"
        dateTextField.text = formatter.string(from: sender.date)
        dailySearchBar.text = formatter.string(from: sender.date)
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if search{
            return searchedArray.count
        }else{
            return articles.count
        }
        //測試
        //        return searchedArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellId = "searchDailyTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! SearchDailyTableViewCell
        
        //以下測試
        //        if cell == nil{
        //            cell = UITableViewCell(style: .default, reuseIdentifier: "searchDailyTableViewCell") as! SearchDailyTableViewCell
        //        }
        //
        //以上測試
        
        
        let article = articles[indexPath.row].data()
        cell.dateLabel.text = article["textClock"] as? String
        cell.answerLabel.text = article["answer"] as? String
        cell.locationLabel.text = "地標：\(article["location"] as? String ?? "")"
        cell.questionTextFiled.text = article["question"] as? String
        
        //取得圖片，取得圖片字串，字串轉URL，URL轉Data，Data轉image
        let dailyImageStr = (article["imagePath"] as? String)!
        let dailyImageURL = URL(string: dailyImageStr)!
        let dailyImageData = try? Data(contentsOf: dailyImageURL)
        let dailyImage = UIImage(data: dailyImageData!)
        
        cell.ivDaily.image = dailyImage
        
        
        return cell
    }
    
    //以下測試
    //    func textFieldShouldClear(_ textField: UITextField) -> Bool {
    //        dateTextField.resignFirstResponder()
    //        dateTextField.text = ""
    //        self.searchedArray.removeAll()
    //        for str in articles{
    //            searchedArray.append(str)
    //        }
    //        searchTV.reloadData()
    //        return false
    //    }
    //
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        if(dateTextField.text?.count)! != 0{
    //            self.searchedArray.removeAll()
    //            for str in articles{
    //                let range = str.description.lowercased().range(of: textField.text!,options: .caseInsensitive,range: nil,locale: nil)
    //                if range != nil{
    //                    self.searchedArray.append(str)
    //                }
    //            }
    //        }
    //        searchTV.reloadData()
    //        return true
    //    }
    
    //以上測試
    
    
    
    
    
    
    
    
    
    //刪除文章func
    private func deleteDocument(indexPath:IndexPath) {
        let article = articles[indexPath.row]
        let id = article.data()["id"] as! String
        let db = Firestore.firestore()
        
        // [START delete_document]
        db.collection("article").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        // [END delete_document]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let article = articles[indexPath.row].data()
        
        
        let alertController = UIAlertController(title: "編輯文章", message: "以下是您的每日答案，確定編輯嗎？", preferredStyle: .alert)
        let updateAction = UIAlertAction(title: "更新", style: .default) { (_) in
            
            
            let ansewr = alertController.textFields?[0].text
            
            let db = Firestore.firestore()
            
            db.collection("articles").whereField("answer", isEqualTo: ansewr! ).getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot{
                    let document = querySnapshot.documents.first
                    document?.reference.updateData(["answer":ansewr!], completion: { (error) in
                        
                    })
                }
                
            }
            
        }
        let deleteAction = UIAlertAction(title: "刪除文章", style: .default) { (_) in
            //            self.deleteDocument(indexPath: <#T##IndexPath#>)
        }
        
        alertController.addTextField { (textField) in
            textField.text = article["answer"] as? String
        }
        
        alertController.addAction(updateAction)
        alertController.addAction(deleteAction)
        present(alertController,animated: true,completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, bool) in
            let alertController = UIAlertController(title: "確定刪除嗎？", message: "刪除就沒囉", preferredStyle: .alert)
            let ok = UIAlertAction(title: "確定", style: .default) { (action) in
                self.deleteDocument(indexPath: indexPath)
                self.articles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(ok)
            alertController.addAction(cancel)
            self.present(alertController,animated: true)
            
            
        }
        delete.backgroundColor = .red
        // delete.image = UIImage(named: "delete")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        // true代表滑到底視同觸發第一個動作；false代表滑到底也不會觸發任何動作
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
        
      
        deleteDocument(indexPath: indexPath)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            articles.remove(at: indexPath.row)
            //             deleteDocument()
            tableView.reloadData()
        }
        
        
    }
    
    
    func updateButtonTapped(){
        
    }
    
    
    
}
//
