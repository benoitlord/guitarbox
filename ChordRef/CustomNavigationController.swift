//
//  CustomNavigationBar.swift
//  ChordRef
//
//  Created by Benoit Lord on 17-10-25.
//  Copyright © 2017 Benoit Lord. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController, UISearchBarDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLoad() {
        
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barStyle = UIBarStyle.black
        
        let newFont = UIFont(name: "Mukta", size: 20.0)!
        let color = UIColor.white
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes([NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: newFont], for: .normal)
        
        /*self.navigationBar.layer.shadowColor = UIColor.black.cgColor;
        self.navigationBar.layer.shadowRadius = 4.0;
        self.navigationBar.layer.shadowOpacity = 1.0;*/
        
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = true
        }
        
        super.viewDidLoad()
    }

}
