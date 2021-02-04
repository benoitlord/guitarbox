//
//  Recordings.swift
//  ChordRef
//
//  Created by Benoit Lord on 18-11-25.
//  Copyright © 2018 Benoit Lord. All rights reserved.
//

import os.log
import UIKit

//Classe qui contient la structure des infos d'un accord
class Recording {
    
    //MARK: Properties
    
    var title: String
    var date: String
    var location: String
    var duration: String
    var type: String
    
    //MARK: Initialisation
    init?(title: String, date: String, location:String, duration: String, type: String) {
        if title.isEmpty {
            return nil
        }
        
        self.title = title
        self.date = date
        self.location = location
        self.duration = duration
        self.type = type
        
    }
}
