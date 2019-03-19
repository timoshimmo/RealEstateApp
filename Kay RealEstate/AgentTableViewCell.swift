//
//  AgentTableViewCell.swift
//  Kay RealEstate
//
//  Created by MacBook Pro on 28/09/2016.
//  Copyright © 2016 AJE AJE. All rights reserved.
//

import UIKit

class AgentTableViewCell: UITableViewCell {

    @IBOutlet weak var agentName: UILabel!
    @IBOutlet weak var agentMobile: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
