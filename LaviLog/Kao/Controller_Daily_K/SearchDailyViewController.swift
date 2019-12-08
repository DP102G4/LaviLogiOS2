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

class SearchDailyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
   
    
   
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchTV: UITableView!
    
    var articles = [QueryDocumentSnapshot]()
    var searchedArray:[String] = Array()
    
    
    
    
    //取FIrebase資料
    func getArticle(){
       let db = Firestore.firestore()
        db.collection("article").order(by: "textClock",descending: true).getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                self.articles = querySnapshot.documents
                self.searchTV.reloadData()
                print(self.articles.count)
                print("112233")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getArticle()
        

//        for str in articles{
//            searchedArray.append(str.description)
//        }
//        searchTV.dataSource = self
//        searchTextField.delegate = self
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        let cellId = "searchDailyTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId,for: indexPath) as! SearchDailyTableViewCell
        let article = articles[indexPath.row].data()
        cell.dateLabel.text = article["textClock"] as? String
        cell.answerTextView.text = article["answer"] as? String
        cell.locationLabel.text = "地標：\(article["location"] as? String ?? "")"
        cell.questionTextFiled.text = article["question"] as? String
        
        
        
        
//                  if cell == nil {
//                    cell.textLabel!.text = searchedArray[indexPath.row]
//                  }
                 
        

        return cell
       }
    
    
//    func textFieldShouldClear(_ textField: UITextField) -> Bool{
//        searchTextField.resignFirstResponder()
//        searchTextField.text = ""
//        self.searchedArray.removeAll()
//        for str in articles{
//            searchedArray.append(str.description)
//        }
//        searchTV.reloadData()
//        return false
//    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if (searchTextField.text?.count)! != 0{
//            self.searchedArray.removeAll()
//            for str in articles{
//                let range = (str.description as String).range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
//                if range != nil{
//                    self.searchedArray.append(str.description)
//                }
//            }
//        }
//        searchTV.reloadData()
//        return true
//    }


    

   
}

