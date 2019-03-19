//
//  HistoryTableViewCell.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 28/10/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet weak var lblPurchaseType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
