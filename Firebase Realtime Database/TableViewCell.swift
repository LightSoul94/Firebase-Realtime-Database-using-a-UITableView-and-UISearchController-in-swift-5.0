//
//  TableViewCell.swift
//  Firebase Realtime Database
//
//  Created by Gianluca Caliendo on 25/09/2019.
//  Copyright © 2019 Gianluca Caliendo. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

        @IBOutlet var address: UILabel!
        @IBOutlet var descript: UILabel!
        @IBOutlet var thumbnail: UIImageView!

        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            // Configure the view for the selected state
        }

    }

