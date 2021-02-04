//
//  MenuTableViewCell.swift
//  ChordRef
//
//  Created by Benoit Lord on 17-12-31.
//  Copyright © 2017 Benoit Lord. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    //MARK: Propriétés
    @IBOutlet weak var nom: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
