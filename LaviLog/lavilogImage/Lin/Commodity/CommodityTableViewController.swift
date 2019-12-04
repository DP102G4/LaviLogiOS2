//
//  CommodityTableViewController.swift
//  LaviLog
//
//  Created by Vincent Lin on 2019/12/3.
//  Copyright © 2019 張哲禎. All rights reserved.
//
//
import UIKit
import FirebaseFirestore
import FirebaseStorage
class CommodityTableViewController: UITableViewController {
    var images = [String: UIImage]()
    var commodities = [Commodity]()
    func getCommodity(){
        var imagePaths = [String]()
        
        let db = Firestore.firestore()
        db.collection("commodity").whereField("onsale", isEqualTo: true).getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot else{
                    return
            }
            for document in querySnapshot.documents{
                print(document.data())
            }
            self.commodities = querySnapshot.documents.map {
                Commodity(dic: $0.data())
            }
            
            for snapshot in querySnapshot.documents{
                imagePaths.append(snapshot.data()["imageUrl"] as! String)
                print("imageUrl", imagePaths)
                
                for imagePath in imagePaths {
                    let fileReference = Storage.storage().reference().child("\(imagePath)")
                    fileReference.getData(maxSize: .max){ data, error in
                        if let error = error{
                            print("imageView error!!")
                        } else {
                            if let data = data, let image = UIImage(data: data){
                                self.images[imagePath] = image
                                print("imagePath",imagePath)
                                print("self.images",self.images)
                            }
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getCommodity()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return commodities.count
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        var commodity: Commodity
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommodityTableViewCell", for: indexPath) as! CommodityTableViewCell
            //let image = images
            let commodity = commodities[indexPath.row]
    //        cell.imageView.image = commodity.imageUrl

            let image = images[commodity.imageUrl]
            cell.nameLabel.text = commodity.productName
            cell.ivCommodity.image = image
    //        cell.infoLabel.text = commodity.productInfo
            cell.priceLabel.text = String(commodity.productPrice)
            // #warning Incomplete implementation, return the number of rows
            return cell
            
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let indexPath = tableView.indexPathForSelectedRow {
            let commodity = commodities[indexPath.row]
            print(commodity)
            let commodityVC = segue.destination as! CommodityDetailVC
            commodityVC.commodity = commodity
        }
    }

}
