//
//  CustomNavigationBar.swift
//  ChordRef
//
//  Created by Benoit Lord on 17-10-25.
//  Copyright © 2017 Benoit Lord. All rights reserved.
//

import UIKit

//Classe qui crée le navigationcontroller personalisé
class CustomNavigationController: UINavigationController, UISearchBarDelegate {
    
    //MARK: Propriétés

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func viewDidLoad() {
        
        //Change la couleur du texte de la navbar
        self.navigationBar.tintColor = UIColor.white
        
        //Permet d'afficher la status bar en blanc
        self.navigationBar.barStyle = UIBarStyle.black
        
        //Change la police
        let newFont = UIFont(name: "Mukta", size: 20.0)!
        let color = UIColor.white
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.classForCoder() as! UIAppearanceContainer.Type]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: newFont], for: .normal)
        
        //Met les titres grand formats d'iOS 11 s'il est utilisé
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = true
        }
        
        super.viewDidLoad()
    }

}
