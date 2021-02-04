//
//  AccordTableViewCell.swift
//  ChordRef
//
//  Created by Benoit Lord on 17-10-04.
//  Copyright © 2017 Benoit Lord. All rights reserved.
//

import UIKit

class AccordTableViewCell: UITableViewCell {
    
    //MARK: Propriétés
    
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var imageAccord: UIImageView!
    @IBOutlet weak var imageFavoris: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
