//
//  ResultTableViewCell.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 02/10/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var HouseTypes: UILabel!
    @IBOutlet weak var PurchaseType: UILabel!
    @IBOutlet weak var housePrice: UILabel!
    @IBOutlet weak var propertyDetails: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
