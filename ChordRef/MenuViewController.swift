//
//  MenuViewController.swift
//  GuitarBox
//
//  Created by Benoit Lord on 18-01-08.
//  Copyright © 2018 Benoit Lord. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var AccordsImage: UIImageView!
    @IBOutlet weak var AccordeurImage: UIImageView!
    @IBOutlet weak var MetronomeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AccordsImage.layer.shadowColor = UIColor.black.cgColor
        AccordsImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        AccordsImage.layer.shadowOpacity = 0.6
        AccordsImage.layer.shadowRadius = 3.0
        AccordsImage.clipsToBounds = false
        
        AccordeurImage.layer.shadowColor = UIColor.black.cgColor
        AccordeurImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        AccordeurImage.layer.shadowOpacity = 0.6
        AccordeurImage.layer.shadowRadius = 3.0
        AccordeurImage.clipsToBounds = false
        
        MetronomeImage.layer.shadowColor = UIColor.black.cgColor
        MetronomeImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        MetronomeImage.layer.shadowOpacity = 0.6
        MetronomeImage.layer.shadowRadius = 3.0
        MetronomeImage.clipsToBounds = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Shadow
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 3.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.6
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMenu(segue:UIStoryboardSegue) { }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
