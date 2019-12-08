//
//  Commodity.swift
//  LaviLog
//
//  Created by Vincent Lin on 2019/12/3.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import Foundation
import UIKit
struct Commodity {
    var productId: String
//    var image: UIImage
    var productName: String
    var productInfo: String
    var productPrice: Int
    var imageUrl: String
}
//
extension Commodity {
    init(dic: [String: Any]) {
        productId = dic["productId"] as? String ?? ""
        productName = dic["productName"] as? String ?? "當我沒說!"
        productInfo = dic["productInfo"] as? String ?? "你看不到我!!"
        productPrice = dic["productPrice"] as? Int ?? 0
        imageUrl = dic["imageUrl"] as? String ?? ""
//        self.image = image
    }
}
