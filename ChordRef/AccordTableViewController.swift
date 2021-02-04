//
//  AccordTableViewController.swift
//  ChordRef
//
//  Created by Benoit Lord on 17-10-04.
//  Copyright © 2017 Benoit Lord. All rights reserved.
//

import os.log
import UIKit

class AccordTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate{
    
    //MARK: Propriétés
    
    var unfilteredAccords = [Accord]()
    var filteredAccords = [Accord]()
    
    var favorites = defaults.object(forKey: defaultsKeys.favorites) as? [String]
    var favorites2 = [Accord]()
    var add = true
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBAction func BackToMenu(_ sender: Any) {
        performSegue(withIdentifier: "BackToMenu", sender: self)
    }
    
    override func viewDidLoad() {
        
        //Setup du searchController
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Rechercher"
        searchController.searchBar.setValue("Annuler", forKey:"_cancelButtonText")
        
        //Fonctions à ajouter si l'utilisateur utilise iOS 11
        if #available (iOS 11, *){
            
            //Met la search bar dans la navbar
            searchController.searchBar.searchBarStyle = .default
            searchController.searchBar.tintColor = UIColor.white
            searchController.searchBar.barTintColor = UIColor.white
            self.navigationItem.searchController = searchController
            
            //Changer l'apparence de la search bar
            for subView in searchController.searchBar.subviews {
                for subViewOne in subView.subviews {
                    if let textField = subViewOne as? UITextField {
                        
                        //Couleur du texte dans la search bar ???
                        //textField.textColor = UIColor.white
                        
                        //Couleur du placeholder de la search bar
                        let textFieldInsideUISearchBarLabel = textField.value(forKey: "placeholderLabel") as? UILabel
                        textFieldInsideUISearchBarLabel?.textColor = UIColor.white
                    }
                }
            }
            
            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    
                    // Background color
                    let sbColor = UIColor(red: 80/255, green: 30/255, blue: 6/255, alpha: 1)
                    backgroundview.backgroundColor = sbColor
                    
                    // Rounded corner
                    backgroundview.layer.cornerRadius = 10;
                    backgroundview.clipsToBounds = true;
                }
            }
            
            //Couleur du texte dans la search bar
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
            
            //Changer le placeholder de "Search" à "Rechercher"
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Rechercher", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            
            //Changer les images pour l'icône de recherche et pour effacer
            searchController.searchBar.setImage(UIImage(named: "clear"), for: UISearchBarIcon.clear, state: .normal)
            searchController.searchBar.setImage(UIImage(named: "search"), for: UISearchBarIcon.search, state: .normal)
        }
            
        //Si l'utilisateur n'utilise pas iOS 11
        else{
            tableView.tableHeaderView = searchController.searchBar
        }
        
        //Met à jour les résultat de la recherche
        updateSearchResults(for: searchController)
        
        //Empêche d'afficher le bouton de retour lorsqu'on revient en ajoutant/retirant un accord dans les favoris
        self.navigationItem.hidesBackButton = true
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Permet d'afficher la search bar quand l'application ouvre
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationItem.largeTitleDisplayMode = .always
        }
        
        //Shadow
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 0.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Permet d'afficher la search bar quand l'application ouvre
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Enlève la search bar quand on quitte la tableview
        searchController.dismiss(animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Sources de données de la tableview
    
    //Dit le nombre de section de la tableview
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Dit le nombre de rangées de les sections de la tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredAccords.count
    }
    
    //Ajoute l'information dans chaque cellule de la tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AccordTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AccordTableViewCell else {
            fatalError("The dequeued cell is not an instance of AccordTableViewCell.")
        }
        
        let accord = filteredAccords[indexPath.row]
        
        cell.nom.text = accord.name
        cell.imageAccord.image = accord.thumb
        
        if accord.favoris == true {
            cell.imageFavoris.image = UIImage(named: "Favoris")
        }
        else{
            cell.imageFavoris.image = nil
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // Pour passer l'info entre les scènes
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowDetail" {
            
            //Va chercher la scène des details de l'accord
            guard let AccordDetailsViewController = segue.destination as? AccordViewController else {
                fatalError("Unexpected destination: \(String(describing: type(of:segue.destination)))")
            }
            
            //Va chercher la cellule sur laquelle on a cliqué
            guard let selectedAccordCell = sender as? AccordTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            //Va chercher l'identifiant de la cellule
            guard let indexPath = tableView.indexPath(for: selectedAccordCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            //Envoie l'accord contenu dans la cellule à l'autre scène
            let selectedAccord = filteredAccords[indexPath.row]
            AccordDetailsViewController.bonAccord = selectedAccord
            
            //Dit à l'autre scène si l'accord est dans les favoris
            AccordDetailsViewController.favorite = false
            if favorites != nil {
                for accord in favorites! {
                    if accord == selectedAccord.name {
                        AccordDetailsViewController.favorite = true
                    }
                }
            }
        }
        else {
            //fatalError("Mauvaise segue")
        }
    }
    
    
    //MARK: Methodes privées
    
    //Load tous les accords
    private func loadAccords(){
        let cImage = UIImage(named: "CImage")
        let c7Image = UIImage(named: "C7Image")
        let c_dImage = UIImage(named: "C-DImage")
        let c_d7Image = UIImage(named: "C-D7Image")
        let dImage = UIImage(named: "DImage")
        let d7Image = UIImage(named: "D7Image")
        let d_eImage = UIImage(named: "D-EImage")
        let d_e7Image = UIImage(named: "D-E7Image")
        let eImage = UIImage(named: "EImage")
        let e7Image = UIImage(named: "E7Image")
        let fImage = UIImage(named: "FImage")
        let f7Image = UIImage(named: "F7Image")
        let f_gImage = UIImage(named: "F-GImage")
        let f_g7Image = UIImage(named: "F-G7Image")
        let gImage = UIImage(named: "GImage")
        let g7Image = UIImage(named: "G7Image")
        let g_aImage = UIImage(named: "G-AImage")
        let g_a7Image = UIImage(named: "G-A7Image")
        let aImage = UIImage(named: "AImage")
        let a7Image = UIImage(named: "A7Image")
        let a_bImage = UIImage(named: "A-BImage")
        let a_b7Image = UIImage(named: "A-B7Image")
        let bImage = UIImage(named: "BImage")
        let b7Image = UIImage(named: "B7Image")
        let c_minImage = UIImage(named: "C_minImage")
        let c_min7Image = UIImage(named: "C_min7Image")
        let c_d_minImage = UIImage(named: "C-D_minImage")
        let c_d_min7Image = UIImage(named: "C-D_min7Image")
        let d_minImage = UIImage(named: "D_minImage")
        let d_min7Image = UIImage(named: "D_min7Image")
        let d_e_minImage = UIImage(named: "D-E_minImage")
        let d_e_min7Image = UIImage(named: "D-E_min7Image")
        let e_minImage = UIImage(named: "E_minImage")
        let e_min7Image = UIImage(named: "E_min7Image")
        let f_minImage = UIImage(named: "F_minImage")
        let f_min7Image = UIImage(named: "F_min7Image")
        let f_g_minImage = UIImage(named: "F-G_minImage")
        let f_g_min7Image = UIImage(named: "F-G_min7Image")
        let g_minImage = UIImage(named: "G_minImage")
        let g_min7Image = UIImage(named: "G_min7Image")
        let g_a_minImage = UIImage(named: "G-A_minImage")
        let g_a_min7Image = UIImage(named: "G-A_min7Image")
        let a_minImage = UIImage(named: "A_minImage")
        let a_min7Image = UIImage(named: "A_min7Image")
        let a_b_minImage = UIImage(named: "A-B_minImage")
        let a_b_min7Image = UIImage(named: "A-B_min7Image")
        let b_minImage = UIImage(named: "B_minImage")
        let b_min7Image = UIImage(named: "B_min7Image")
        
        let cThumb = UIImage(named: "CThumb")
        let c7Thumb = UIImage(named: "C7Thumb")
        let c_dThumb = UIImage(named: "C-DThumb")
        let c_d7Thumb = UIImage(named: "C-D7Thumb")
        let dThumb = UIImage(named: "DThumb")
        let d7Thumb = UIImage(named: "D7Thumb")
        let d_eThumb = UIImage(named: "D-EThumb")
        let d_e7Thumb = UIImage(named: "D-E7Thumb")
        let eThumb = UIImage(named: "EThumb")
        let e7Thumb = UIImage(named: "E7Thumb")
        let fThumb = UIImage(named: "FThumb")
        let f7Thumb = UIImage(named: "F7Thumb")
        let f_gThumb = UIImage(named: "F-GThumb")
        let f_g7Thumb = UIImage(named: "F-G7Thumb")
        let gThumb = UIImage(named: "GThumb")
        let g7Thumb = UIImage(named: "G7Thumb")
        let g_aThumb = UIImage(named: "G-AThumb")
        let g_a7Thumb = UIImage(named: "G-A7Thumb")
        let aThumb = UIImage(named: "AThumb")
        let a7Thumb = UIImage(named: "A7Thumb")
        let a_bThumb = UIImage(named: "A-BThumb")
        let a_b7Thumb = UIImage(named: "A-B7Thumb")
        let bThumb = UIImage(named: "BThumb")
        let b7Thumb = UIImage(named: "B7Thumb")
        let c_minThumb = UIImage(named: "C_minThumb")
        let c_min7Thumb = UIImage(named: "C_min7Thumb")
        let c_d_minThumb = UIImage(named: "C-D_minThumb")
        let c_d_min7Thumb = UIImage(named: "C-D_min7Thumb")
        let d_minThumb = UIImage(named: "D_minThumb")
        let d_min7Thumb = UIImage(named: "D_min7Thumb")
        let d_e_minThumb = UIImage(named: "D-E_minThumb")
        let d_e_min7Thumb = UIImage(named: "D-E_min7Thumb")
        let e_minThumb = UIImage(named: "E_minThumb")
        let e_min7Thumb = UIImage(named: "E_min7Thumb")
        let f_minThumb = UIImage(named: "F_minThumb")
        let f_min7Thumb = UIImage(named: "F_min7Thumb")
        let f_g_minThumb = UIImage(named: "F-G_minThumb")
        let f_g_min7Thumb = UIImage(named: "F-G_min7Thumb")
        let g_minThumb = UIImage(named: "G_minThumb")
        let g_min7Thumb = UIImage(named: "G_min7Thumb")
        let g_a_minThumb = UIImage(named: "G-A_minThumb")
        let g_a_min7Thumb = UIImage(named: "G-A_min7Thumb")
        let a_minThumb = UIImage(named: "A_minThumb")
        let a_min7Thumb = UIImage(named: "A_min7Thumb")
        let a_b_minThumb = UIImage(named: "A-B_minThumb")
        let a_b_min7Thumb = UIImage(named: "A-B_min7Thumb")
        let b_minThumb = UIImage(named: "B_minThumb")
        let b_min7Thumb = UIImage(named: "B_min7Thumb")
        
        guard let accordC = Accord(name: "C", photo: cImage!, thumb: cThumb!, favoris: false, son: "c") else {
            fatalError("Unable to instantiate accordC")
        }
        guard let accordC7 = Accord(name: "C7", photo: c7Image!, thumb: c7Thumb!, favoris: false, son: "c7") else {
            fatalError("Unable to instantiate accordC7")
        }
        guard let accordC_D = Accord(name: "C#/Db", photo: c_dImage!, thumb: c_dThumb!, favoris: false, son: "c-d") else {
            fatalError("Unable to instantiate accordC_D")
        }
        guard let accordC_D7 = Accord(name: "C#7/Db7", photo: c_d7Image!, thumb: c_d7Thumb!, favoris: false, son: "c-d7") else {
            fatalError("Unable to instantiate accordC_D7")
        }
        guard let accordD = Accord(name: "D", photo: dImage!, thumb: dThumb!, favoris: false, son: "d") else {
            fatalError("Unable to instantiate accordD")
        }
        guard let accordD7 = Accord(name: "D7", photo: d7Image!, thumb: d7Thumb!, favoris: false, son: "d7") else {
            fatalError("Unable to instantiate accordD7")
        }
        guard let accordD_E = Accord(name: "D#/Eb", photo: d_eImage!, thumb: d_eThumb!, favoris: false, son: "d-e") else {
            fatalError("Unable to instantiate accordD_E")
        }
        guard let accordD_E7 = Accord(name: "D#7/Eb7", photo: d_e7Image!, thumb: d_e7Thumb!, favoris: false, son: "d-e7") else {
            fatalError("Unable to instantiate accordD_E7")
        }
        guard let accordE = Accord(name: "E", photo: eImage!, thumb: eThumb!, favoris: false, son: "e") else {
            fatalError("Unable to instantiate accordE")
        }
        guard let accordE7 = Accord(name: "E7", photo: e7Image!, thumb: e7Thumb!, favoris: false, son: "e7") else {
            fatalError("Unable to instantiate accordE7")
        }
        guard let accordF = Accord(name: "F", photo: fImage!, thumb: fThumb!, favoris: false, son: "f") else {
            fatalError("Unable to instantiate accordF")
        }
        guard let accordF7 = Accord(name: "F7", photo: f7Image!, thumb: f7Thumb!, favoris: false, son: "f7") else {
            fatalError("Unable to instantiate accordF7")
        }
        guard let accordF_G = Accord(name: "F#/Gb", photo: f_gImage!, thumb: f_gThumb!, favoris: false, son: "f-g") else {
            fatalError("Unable to instantiate accordF_G")
        }
        guard let accordF_G7 = Accord(name: "F#7/Gb7", photo: f_g7Image!, thumb: f_g7Thumb!, favoris: false, son: "f-g7") else {
            fatalError("Unable to instantiate accordF_G7")
        }
        guard let accordG = Accord(name: "G", photo: gImage!, thumb: gThumb!, favoris: false, son: "g") else {
            fatalError("Unable to instantiate accordG")
        }
        guard let accordG7 = Accord(name: "G7", photo: g7Image!, thumb: g7Thumb!, favoris: false, son: "g7") else {
            fatalError("Unable to instantiate accordG7")
        }
        guard let accordG_A = Accord(name: "G#/Ab", photo: g_aImage!, thumb: g_aThumb!, favoris: false, son: "g-a") else {
            fatalError("Unable to instantiate accordG_A")
        }
        guard let accordG_A7 = Accord(name: "G#7/Ab7", photo: g_a7Image!, thumb: g_a7Thumb!, favoris: false, son: "g-a7") else {
            fatalError("Unable to instantiate accordG_A7")
        }
        guard let accordA = Accord(name: "A", photo: aImage!, thumb: aThumb!, favoris: false, son: "a") else {
            fatalError("Unable to instantiate accordA")
        }
        guard let accordA7 = Accord(name: "A7", photo: a7Image!, thumb: a7Thumb!, favoris: false, son: "a7") else {
            fatalError("Unable to instantiate accordA7")
        }
        guard let accordA_B = Accord(name: "A#/Bb", photo: a_bImage!, thumb: a_bThumb!, favoris: false, son: "a-b") else {
            fatalError("Unable to instantiate accordA_B")
        }
        guard let accordA_B7 = Accord(name: "A#7/Bb7", photo: a_b7Image!, thumb: a_b7Thumb!, favoris: false, son: "a-b7") else {
            fatalError("Unable to instantiate accordA_B7")
        }
        guard let accordB = Accord(name: "B", photo: bImage!, thumb: bThumb!, favoris: false, son: "b") else {
            fatalError("Unable to instantiate accordB")
        }
        guard let accordB7 = Accord(name: "B7", photo: b7Image!, thumb: b7Thumb!, favoris: false, son: "b7") else {
            fatalError("Unable to instantiate accordB7")
        }
        guard let accordC_min = Accord(name: "C min", photo: c_minImage!, thumb: c_minThumb!, favoris: false, son: "c_min") else {
            fatalError("Unable to instantiate accordC_min")
        }
        guard let accordC_min7 = Accord(name: "C min7", photo: c_min7Image!, thumb: c_min7Thumb!, favoris: false, son: "c_min7") else {
            fatalError("Unable to instantiate accordC_min7")
        }
        guard let accordC_D_min = Accord(name: "C#/Db min", photo: c_d_minImage!, thumb: c_d_minThumb!, favoris: false, son: "c-d_min") else {
            fatalError("Unable to instantiate accordC_D_min")
        }
        guard let accordC_D_min7 = Accord(name: "C#/Db min7", photo: c_d_min7Image!, thumb: c_d_min7Thumb!, favoris: false, son: "c-d_min7") else {
            fatalError("Unable to instantiate accordC_D_min7")
        }
        guard let accordD_min = Accord(name: "D min", photo: d_minImage!, thumb: d_minThumb!, favoris: false, son: "d_min") else {
            fatalError("Unable to instantiate accordD_min")
        }
        guard let accordD_min7 = Accord(name: "D min7", photo: d_min7Image!, thumb: d_min7Thumb!, favoris: false, son: "d_min7") else {
            fatalError("Unable to instantiate accordD_min7")
        }
        guard let accordD_E_min = Accord(name: "D#/Eb min", photo: d_e_minImage!, thumb: d_e_minThumb!, favoris: false, son: "d-e_min") else {
            fatalError("Unable to instantiate accordD_E_min")
        }
        guard let accordD_E_min7 = Accord(name: "D#/Eb min7", photo: d_e_min7Image!, thumb: d_e_min7Thumb!, favoris: false, son: "d-e_min7") else {
            fatalError("Unable to instantiate accordD_E_min7")
        }
        guard let accordE_min = Accord(name: "E min", photo: e_minImage!, thumb: e_minThumb!, favoris: false, son: "e_min") else {
            fatalError("Unable to instantiate accordE_min")
        }
        guard let accordE_min7 = Accord(name: "E min7", photo: e_min7Image!, thumb: e_min7Thumb!, favoris: false, son: "e_min7") else {
            fatalError("Unable to instantiate accordE_min7")
        }
        guard let accordF_min = Accord(name: "F min", photo: f_minImage!, thumb: f_minThumb!, favoris: false, son: "f_min") else {
            fatalError("Unable to instantiate accordF_min")
        }
        guard let accordF_min7 = Accord(name: "F min7", photo: f_min7Image!, thumb: f_min7Thumb!, favoris: false, son: "f_min7") else {
            fatalError("Unable to instantiate accordF_min7")
        }
        guard let accordF_G_min = Accord(name: "F#/Gb min", photo: f_g_minImage!, thumb: f_g_minThumb!, favoris: false, son: "f-g_min") else {
            fatalError("Unable to instantiate accordF_G_min")
        }
        guard let accordF_G_min7 = Accord(name: "F#/Gb min7", photo: f_g_min7Image!, thumb: f_g_min7Thumb!, favoris: false, son: "f-g_min7") else {
            fatalError("Unable to instantiate accordF_G_min7")
        }
        guard let accordG_min = Accord(name: "G min", photo: g_minImage!, thumb: g_minThumb!, favoris: false, son: "g_min") else {
            fatalError("Unable to instantiate accordG_min")
        }
        guard let accordG_min7 = Accord(name: "G min7", photo: g_min7Image!, thumb: g_min7Thumb!, favoris: false, son: "g_min7") else {
            fatalError("Unable to instantiate accordG_min7")
        }
        guard let accordG_A_min = Accord(name: "G#/Ab min", photo: g_a_minImage!, thumb: g_a_minThumb!, favoris: false, son: "g-a_min") else {
            fatalError("Unable to instantiate accordG_A_min")
        }
        guard let accordG_A_min7 = Accord(name: "G#/Ab min7", photo: g_a_min7Image!, thumb: g_a_min7Thumb!, favoris: false, son: "g-a_min7") else {
            fatalError("Unable to instantiate accordG_A_min7")
        }
        guard let accordA_min = Accord(name: "A min", photo: a_minImage!, thumb: a_minThumb!, favoris: false, son: "a_min") else {
            fatalError("Unable to instantiate accordA_min")
        }
        guard let accordA_min7 = Accord(name: "A min7", photo: a_min7Image!, thumb: a_min7Thumb!, favoris: false, son: "a_min7") else {
            fatalError("Unable to instantiate accordA_min7")
        }
        guard let accordA_B_min = Accord(name: "A#/Bb min", photo: a_b_minImage!, thumb: a_b_minThumb!, favoris: false, son: "a-b_min") else {
            fatalError("Unable to instantiate accordA_B_min")
        }
        guard let accordA_B_min7 = Accord(name: "A#/Bb min7", photo: a_b_min7Image!, thumb: a_b_min7Thumb!, favoris: false, son: "a-b_min7") else {
            fatalError("Unable to instantiate accordA_B_min7")
        }
        guard let accordB_min = Accord(name: "B min", photo: b_minImage!, thumb: b_minThumb!, favoris: false, son: "b_min") else {
            fatalError("Unable to instantiate accordB_min")
        }
        guard let accordB_min7 = Accord(name: "B min7", photo: b_min7Image!, thumb: b_min7Thumb!, favoris: false, son: "b_min7") else {
            fatalError("Unable to instantiate accordB_min7")
        }
        
        unfilteredAccords = [accordC, accordC7, accordC_D, accordC_D7, accordD, accordD7, accordD_E, accordD_E7, accordE, accordE7, accordF, accordF7, accordF_G, accordF_G7, accordG, accordG7, accordG_A, accordG_A7, accordA, accordA7, accordA_B, accordA_B7, accordB, accordB7, accordC_min, accordC_min7, accordC_D_min, accordC_D_min7, accordD_min, accordD_min7, accordD_E_min, accordD_E_min7, accordE_min, accordE_min7, accordF_min, accordF_min7, accordF_G_min, accordF_G_min7, accordG_min, accordG_min7, accordG_A_min, accordG_A_min7, accordA_min, accordA_min7, accordA_B_min, accordA_B_min7, accordB_min, accordB_min7]
        
        //Ajoutes les accord favoris aux tableau des favoris
        favorites = defaults.object(forKey: defaultsKeys.favorites) as? [String]
        if add {
            if favorites != nil {
                for accord in unfilteredAccords {
                    for accordFavorite in favorites! {
                        if accord.name == accordFavorite {
                            accord.favoris = true
                            favorites2.append(accord)
                        }
                    }
                }
            }
            add = false
        }
    }
    
    //MARK: Search Bar
    
    //Met à jour les infos de recherche quand on écrit dans la search bar
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredAccords = unfilteredAccords.filter { accord in
                return accord.name.lowercased().contains(searchText.lowercased())
            }
        }
        else{
            loadAccords()
            loadAccords()
            filteredAccords = favorites2 + unfilteredAccords
        }
        
        //Reload la tableview
        tableView.reloadData()
    }

}
