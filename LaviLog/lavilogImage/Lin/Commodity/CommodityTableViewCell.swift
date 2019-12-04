//
//  CommodityTableViewCell.swift
//  LaviLog
//
//  Created by Vincent Lin on 2019/12/3.
//  Copyright © 2019 張哲禎. All rights reserved.
//

import UIKit

class CommodityTableViewCell: UITableViewCell {
    //
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ivCommodity: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
