//
//  RecorderHomeViewController.swift
//  GuitarBox
//
//  Created by Benoit Lord on 2018-11-25.
//  Copyright © 2018 Benoit Lord. All rights reserved.
//

import UIKit

class RecorderHomeTableViewController: UITableViewController {
    
    //MARK: Propriétés
    var recordings = [Recording]()
    
    //MARK: Outlets
    @IBOutlet weak var newButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Enlève le bouton Back
        self.navigationItem.hidesBackButton = true

        //Localization
        navigationItem.title = NSLocalizedString("Recorder", comment: "")
        newButton.setTitle("+ \(NSLocalizedString("new", comment: ""))", for: .normal)
        
        loadRecordings()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Sources de données de la tableview
    
    //Dit le nombre de section de la tableview
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Vos enregistrements"
    }
    
    //Dit le nombre de rangées de les sections de la tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recordings.count
    }
    
    //Ajoute l'information dans chaque cellule de la tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "RecorderHomeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecorderHomeTableViewCell else {
            fatalError("The dequeued cell is not an instance of RecorderHomeTableViewCell.")
        }
        
        let recording = recordings[indexPath.row]
        
        cell.titleLabel.text = recording.title
        cell.dateLabel.text = recording.date
        cell.locationLabel.text = recording.location
        cell.durationLabel.text = recording.duration
        cell.typeLabel.text = recording.type
        
        return cell
    }
    
    func loadRecordings() {
        //Test
        guard let recording1 = Recording(title: "Test 1", date: "2018-11-25", location: "Lieu test", duration: "00:01:30", type: "test") else {
            fatalError("Unable to instantiate recording1")
        }
        guard let recording2 = Recording(title: "Test 2", date: "2018-11-24", location: "Lieu test 2", duration: "00:02:42", type: "test") else {
            fatalError("Unable to instantiate recording1")
        }
        recordings = [recording1, recording2]
    }
    
    //MARK: Pour le bouton vers le menu
    @IBAction func BackToMenu(_ sender: Any) {
        performSegue(withIdentifier: "BackToMenu", sender: self)
    }
    
    
    @IBAction func unwindRecorder(segue:UIStoryboardSegue) { }
}
