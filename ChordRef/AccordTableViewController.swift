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
    
    //MARK: Properties
    
    var unfilteredAccords = [Accord]()
    var filteredAccords = [Accord]()
    //var favorites = [Accord?]()
    
    var favorites = defaults.object(forKey: defaultsKeys.favorites) as? [String]
    var favorites2 = [Accord]()
    var add = true
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Rechercher"
        searchController.searchBar.setValue("Annuler", forKey:"_cancelButtonText")
        
        if #available (iOS 11, *){
            self.navigationItem.searchController = searchController
            
            searchController.searchBar.searchBarStyle = .default
            searchController.searchBar.tintColor = UIColor.white
            searchController.searchBar.barTintColor = UIColor.white
            
            for subView in searchController.searchBar.subviews {
                
                for subViewOne in subView.subviews {
                    
                    if let textField = subViewOne as? UITextField {
                        
                        textField.textColor = UIColor.white
                        
                        //use the code below if you want to change the color of placeholder
                        let textFieldInsideUISearchBarLabel = textField.value(forKey: "placeholderLabel") as? UILabel
                        textFieldInsideUISearchBarLabel?.textColor = UIColor.white
                    }
                }
            }
            
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
            
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Rechercher", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
            
            searchController.searchBar.setImage(UIImage(named: "clear"), for: UISearchBarIcon.clear, state: .normal)
            searchController.searchBar.setImage(UIImage(named: "search"), for: UISearchBarIcon.search, state: .normal)
            
        }
        else{
            tableView.tableHeaderView = searchController.searchBar
        }
        
        super.viewDidLoad()
        
        updateSearchResults(for: searchController)
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.dismiss(animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredAccords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "AccordTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AccordTableViewCell else {
            fatalError("The dequeued cell is not an instance of AccordTableViewCell.")
        }
        
        // Fetches the appropriate chord for the data source layout.
        let accord = filteredAccords[indexPath.row]
        
        cell.nom.text = accord.name
        cell.imageAccord.image = accord.photo
        
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ShowDetail" {
            guard let AccordDetailsViewController = segue.destination as? AccordViewController else {
                fatalError("Unexpected destination: \(String(describing: type(of:segue.destination)))")
            }
            
            guard let selectedAccordCell = sender as? AccordTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedAccordCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedAccord = filteredAccords[indexPath.row]
            AccordDetailsViewController.bonAccord = selectedAccord
            
            AccordDetailsViewController.favorite = false
            if let abc = favorites as? [String] {
                for accord in favorites! {
                    if accord == selectedAccord.name {
                        AccordDetailsViewController.favorite = true
                    }
                }
            }
        }
        else {
            fatalError("Mauvaise segue")
        }
    }
    
    
    //MARK Private Methods
    
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
        
        guard let accordC = Accord(name: "C", photo: cImage!, favoris: false) else {
            fatalError("Unable to instantiate accordC")
        }
        
        guard let accordC7 = Accord(name: "C7", photo: c7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordC7")
        }
        
        guard let accordC_D = Accord(name: "C#/Db", photo: c_dImage!, favoris: false) else {
            fatalError("Unable to instantiate accordC_D")
        }
        
        guard let accordC_D7 = Accord(name: "C#7/Db7", photo: c_d7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordC_D7")
        }
        
        guard let accordD = Accord(name: "D", photo: dImage!, favoris: false) else {
            fatalError("Unable to instantiate accordD")
        }
        
        guard let accordD7 = Accord(name: "D7", photo: d7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordD7")
        }
        
        guard let accordD_E = Accord(name: "D#/Eb", photo: d_eImage!, favoris: false) else {
            fatalError("Unable to instantiate accordD_E")
        }
        
        guard let accordD_E7 = Accord(name: "D#7/Eb7", photo: d_e7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordD_E7")
        }
        
        guard let accordE = Accord(name: "E", photo: eImage!, favoris: false) else {
            fatalError("Unable to instantiate accordE")
        }
        
        guard let accordE7 = Accord(name: "E7", photo: e7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordE7")
        }
        
        guard let accordF = Accord(name: "F", photo: fImage!, favoris: false) else {
            fatalError("Unable to instantiate accordF")
        }
        
        guard let accordF7 = Accord(name: "F7", photo: f7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordF7")
        }
        
        guard let accordF_G = Accord(name: "F#/Gb", photo: f_gImage!, favoris: false) else {
            fatalError("Unable to instantiate accordF_G")
        }
        
        guard let accordF_G7 = Accord(name: "F#7/Gb7", photo: f_g7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordF_G7")
        }
        
        guard let accordG = Accord(name: "G", photo: gImage!, favoris: false) else {
            fatalError("Unable to instantiate accordG")
        }
        
        guard let accordG7 = Accord(name: "G7", photo: g7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordG7")
        }
        
        guard let accordG_A = Accord(name: "G#/Ab", photo: g_aImage!, favoris: false) else {
            fatalError("Unable to instantiate accordG_A")
        }
        
        guard let accordG_A7 = Accord(name: "G#7/Ab7", photo: g_a7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordG_A7")
        }
        
        guard let accordA = Accord(name: "A", photo: aImage!, favoris: false) else {
            fatalError("Unable to instantiate accordA")
        }
        
        guard let accordA7 = Accord(name: "A7", photo: a7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordA7")
        }
        
        guard let accordA_B = Accord(name: "A#/Bb", photo: a_bImage!, favoris: false) else {
            fatalError("Unable to instantiate accordA_B")
        }
        
        guard let accordA_B7 = Accord(name: "A#7/Bb7", photo: a_b7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordA_B7")
        }
        
        guard let accordB = Accord(name: "B", photo: bImage!, favoris: false) else {
            fatalError("Unable to instantiate accordB")
        }
        
        guard let accordB7 = Accord(name: "B7", photo: b7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordB7")
        }
        
        guard let accordC_min = Accord(name: "C min", photo: c_minImage!, favoris: false) else {
            fatalError("Unable to instantiate accordC_min")
        }
        
        guard let accordC_min7 = Accord(name: "C min7", photo: c_min7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordC_min7")
        }
        
        guard let accordC_D_min = Accord(name: "C#/Db min", photo: c_d_minImage!, favoris: false) else {
            fatalError("Unable to instantiate accordC_D_min")
        }
        
        guard let accordC_D_min7 = Accord(name: "C#/Db min7", photo: c_d_min7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordC_D_min7")
        }
        
        guard let accordD_min = Accord(name: "D min", photo: d_minImage!, favoris: false) else {
            fatalError("Unable to instantiate accordD_min")
        }
        
        guard let accordD_min7 = Accord(name: "D min7", photo: d_min7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordD_min7")
        }
        
        guard let accordD_E_min = Accord(name: "D#/Eb min", photo: d_e_minImage!, favoris: false) else {
            fatalError("Unable to instantiate accordD_E_min")
        }
        
        guard let accordD_E_min7 = Accord(name: "D#/Eb min7", photo: d_e_min7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordD_E_min7")
        }
        
        guard let accordE_min = Accord(name: "E min", photo: e_minImage!, favoris: false) else {
            fatalError("Unable to instantiate accordE_min")
        }
        
        guard let accordE_min7 = Accord(name: "E min7", photo: e_min7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordE_min7")
        }
        
        guard let accordF_min = Accord(name: "F min", photo: f_minImage!, favoris: false) else {
            fatalError("Unable to instantiate accordF_min")
        }
        
        guard let accordF_min7 = Accord(name: "F min7", photo: f_min7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordF_min7")
        }
        
        guard let accordF_G_min = Accord(name: "F#/Gb min", photo: f_g_minImage!, favoris: false) else {
            fatalError("Unable to instantiate accordF_G_min")
        }
        
        guard let accordF_G_min7 = Accord(name: "F#/Gb min7", photo: f_g_min7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordF_G_min7")
        }
        
        guard let accordG_min = Accord(name: "G min", photo: g_minImage!, favoris: false) else {
            fatalError("Unable to instantiate accordG_min")
        }
        
        guard let accordG_min7 = Accord(name: "G min7", photo: g_min7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordG_min7")
        }
        
        guard let accordG_A_min = Accord(name: "G#/Ab min", photo: g_a_minImage!, favoris: false) else {
            fatalError("Unable to instantiate accordG_A_min")
        }
        
        guard let accordG_A_min7 = Accord(name: "G#/Ab min7", photo: g_a_min7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordG_A_min7")
        }
        
        guard let accordA_min = Accord(name: "A min", photo: a_minImage!, favoris: false) else {
            fatalError("Unable to instantiate accordA_min")
        }
        
        guard let accordA_min7 = Accord(name: "A min7", photo: a_min7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordA_min7")
        }
        
        guard let accordA_B_min = Accord(name: "A#/Bb min", photo: a_b_minImage!, favoris: false) else {
            fatalError("Unable to instantiate accordA_B_min")
        }
        
        guard let accordA_B_min7 = Accord(name: "A#/Bb min7", photo: a_b_min7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordA_B_min7")
        }
        
        guard let accordB_min = Accord(name: "B min", photo: b_minImage!, favoris: false) else {
            fatalError("Unable to instantiate accordB_min")
        }
        
        guard let accordB_min7 = Accord(name: "B min7", photo: b_min7Image!, favoris: false) else {
            fatalError("Unable to instantiate accordB_min7")
        }
        
        unfilteredAccords = [accordC, accordC7, accordC_D, accordC_D7, accordD, accordD7, accordD_E, accordD_E7, accordE, accordE7, accordF, accordF7, accordF_G, accordF_G7, accordG, accordG7, accordG_A, accordG_A7, accordA, accordA7, accordA_B, accordA_B7, accordB, accordB7, accordC_min, accordC_min7, accordC_D_min, accordC_D_min7, accordD_min, accordD_min7, accordD_E_min, accordD_E_min7, accordE_min, accordE_min7, accordF_min, accordF_min7, accordF_G_min, accordF_G_min7, accordG_min, accordG_min7, accordG_A_min, accordG_A_min7, accordA_min, accordA_min7, accordA_B_min, accordA_B_min7, accordB_min, accordB_min7]
        
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
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredAccords = unfilteredAccords.filter { accord in
                return accord.name.lowercased().contains(searchText.lowercased())
            }
        }
        else{
            loadAccords()
            if let abc = favorites2 as? [Accord] {
                loadAccords()
                filteredAccords = favorites2 + unfilteredAccords
            }
            else{
                filteredAccords = unfilteredAccords
            }
        }
        tableView.reloadData()
    }

}
