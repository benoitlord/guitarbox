//
//  ViewController.swift
//  ChordRef
//
//  Created by Benoit Lord on 17-10-04.
//  Copyright © 2017 Benoit Lord. All rights reserved.
//

import UIKit

class AccordViewController: UIViewController {

    var bonAccord: Accord?
    
    //MARK: Outlets
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var imageAccord: UIImageView!
    @IBOutlet weak var imageFavoris: UIImageView!
    
    
    //MARK: Actions
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up views if editing an existing Meal.
        if let accord = bonAccord {
            navigationItem.title = accord.name
            imageAccord.image = accord.photo
            nom.text = accord.name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let name = nom.text ?? ""
        let image = imageAccord.image
        
        bonAccord = Accord(name: name, photo: image!)
    }
}

