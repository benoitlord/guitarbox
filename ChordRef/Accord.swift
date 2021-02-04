//
//  Accord.swift
//  ChordRef
//
//  Created by Benoit Lord on 17-10-04.
//  Copyright © 2017 Benoit Lord. All rights reserved.
//

import os.log
import UIKit

class Accord {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage
    
    init?(name: String, photo: UIImage) {
        if name.isEmpty {
            return nil
        }
        
    self.name = name
    self.photo = photo
        
    }
}
