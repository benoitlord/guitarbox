//
//  ViewController.swift
//  ChordRef
//
//  Created by Benoit Lord on 17-10-04.
//  Copyright © 2017 Benoit Lord. All rights reserved.
//

import UIKit

class AccordViewController: UIViewController {
    
    //MARK: Propriétés
    var bonAccord: Accord?
    var favorite:Bool?
    
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var imageAccord: UIImageView!
    @IBOutlet weak var boutonFavoris: BoutonFavoris!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Recevoir les infos de la tableview
        if let accord = bonAccord {
            navigationItem.title = accord.name
            imageAccord.image = accord.photo
            nom.text = accord.name
        }
        
        //Sélectionner le bouton des favoris si l'accord est dans les favoris
        if favorite! {
            boutonFavoris.isSelected = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Pour passer l'info entre les scènes
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //Pour ajouter/retirer l'accord des favoris si on clique sur le bouton
        let name = nom.text ?? ""
        let image = imageAccord.image
        
        bonAccord = Accord(name: name, photo: image!, favoris: false)
        
        //Modifie les données de l'app en fonction
        if favorite! {
            let defaults = UserDefaults.standard
            var favorites = defaults.array(forKey: defaultsKeys.favorites) as? [String]
            
            if favorites != nil {
                favorites?.append(bonAccord!.name)
            }
            else {
                favorites = [(bonAccord?.name)!]
            }
            
            defaults.set(favorites, forKey: defaultsKeys.favorites)
        }
        else {
            let defaults = UserDefaults.standard
            var favorites = defaults.array(forKey: defaultsKeys.favorites) as? [String]
            
            let index = favorites?.index(of: bonAccord!.name)
            favorites?.remove(at: index!)
            
            defaults.set(favorites, forKey: defaultsKeys.favorites)
        }
    }
    
    //MARK: Actions
    
    //Lorsqu'on clique sur le bouton favoris
    @IBAction func buttonPressed(_ sender: BoutonFavoris) {
        if !sender.isSelected {
            sender.isSelected = true
            favorite = true
        }
        else{
            sender.isSelected = false
            favorite = false
        }
    }
}

