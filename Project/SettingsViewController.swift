//
//  SettingsViewController.swift
//  GuitarBox
//
//  Created by Benoit Lord on 2018-12-15.
//  Copyright © 2018 Benoit Lord. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: Propriétés
    var filePath:URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        print(filePath!)
    }
    
    @IBAction func Save(_ sender: Any) {
        performSegue(withIdentifier: "unwindRecorder", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
