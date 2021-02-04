//
//  RecorderHomeTableViewCell.swift
//  GuitarBox
//
//  Created by Benoit Lord on 2018-11-25.
//  Copyright © 2018 Benoit Lord. All rights reserved.
//

import UIKit

class RecorderHomeTableViewCell: UITableViewCell {
    
    //MARK: Propriétés
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
