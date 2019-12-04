//
//  CommodityVC.swift
//  LaviLog
//
//  Created by Vincent Lin on 2019/12/3.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import UIKit

class CommodityDetailVC: UIViewController {
    //將資料傳到該處
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ivCommodity: UIImageView!
    var commodity: Commodity!
    var images = [String: UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = "name: \(commodity.productName)"
        infoLabel.text = "info: \(commodity.productInfo)"
        priceLabel.text = "price: \(String(commodity.productPrice))"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
