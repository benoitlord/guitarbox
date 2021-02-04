//
//  MetronomeViewController.swift
//  GuitarBox
//
//  Created by Benoit Lord on 18-01-10.
//  Copyright © 2018 Benoit Lord. All rights reserved.
//

import UIKit
import AudioKit

//Extension pour arrondir les nombres
extension Float {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

class MetronomeViewController: UIViewController, UITextFieldDelegate, AVAudioPlayerDelegate {

    //MARK: propriétés
    
    //Outlets
    @IBOutlet weak var TempoSlider: UISlider!
    @IBOutlet weak var TempoTextField: UITextField!
    @IBOutlet weak var TempoSegments: UISegmentedControl!
    @IBOutlet weak var MetronomeImage: UIImageView!
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var TempoLabel: UILabel!
    
    //Pour le tempo et le type de mesure
    var tempoType = 3
    var tempo = 120
    var son: Bool = true
    
    //Détermine si le métronome est parti
    var parti = false
    
    //Variable qui contient le timer
    var timer: Timer?
    
    //Le player pour le son
    var player: AVAudioPlayer?
    
    //Permet de savoir à quelle temps de la mesure on est rendu
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set le delegate du textfield
        TempoTextField.delegate = self
        
        //Ajoute le bouton OK sur le clavier
        addDoneButton()
        
        //Ajoute le shadow sur la vue du bas
        BottomView.layer.shadowColor = UIColor.black.cgColor
        BottomView.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        BottomView.layer.shadowRadius = 3.0
        BottomView.layer.shadowOpacity = 0.6
        BottomView.layer.masksToBounds = false
        
        //Enlève le bouton Back
        self.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Désactive le timer quand on quitte le métronome
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    //MARK: Start/Stop
    
    //Démarre le métronome (quand on appuie sur le bouton Démarrer)
    @IBAction func Start(_ sender: Any) {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 60/tempo, target: self, selector: #selector(JouerSon), userInfo: nil, repeats: true)
        }
        parti = true
    }
    
    //Arrête le métronome (quand on appuie sur le bouton Arrêter)
    @IBAction func Stop(_ sender: Any) {
        //Remet le conteur au début de la mesure
        counter = 0
        
        //Arrête le timer
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        
        //Remet l'image avec aucun point allumé
        switch tempoType {
        case 0:
            MetronomeImage.image = UIImage(named: "0_0")
            break
        case 1:
            MetronomeImage.image = UIImage(named: "2-4_0")
            break
        case 2:
            MetronomeImage.image = UIImage(named: "3-4_0")
            break
        case 3:
            MetronomeImage.image = UIImage(named: "4-4_0")
            break
        default:
            MetronomeImage.image = UIImage(named: "4-4_0")
            break
        }
        
        //Change la variable pour dire que le métronome est arrêté
        parti = false
    }
    
    //Mark: Son
    
    @objc func JouerSon() {
        
        //Met à jour le compteur pour le temps dans la mesure
        updateCounter()
        
        //Change l'image pour que le bon point allume
        updateImage()
        
        //si on est au premier temps, jouer le son plus haut
        if counter == 1 && son {
            guard let url = Bundle.main.url(forResource: "metronome_son_haut", withExtension: "wav") else { print ("le fichier n'existe pas"); return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                player?.delegate = self
                
                /* iOS 10 and earlier require the following line:
                 player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
                
                guard let player = player else { return }
                
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
        //Sinon, jouer le son plus bas
        else {
            guard let url = Bundle.main.url(forResource: "metronome_son_bas", withExtension: "wav") else { print ("le fichier n'existe pas"); return }
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                player?.delegate = self
                
                /* iOS 10 and earlier require the following line:
                 player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
                
                guard let player = player else { return }
                
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: Update Counter/Image
    
    //Fonction qui met à jour le compteur pour le temps dans la mesure
    func updateCounter() {
        switch tempoType {
        case 0:
            counter = 1
            break
        case 1:
            if counter < 2 {
                counter = counter + 1
            }
            else {
                counter = 1
            }
            break
        case 2:
            if counter < 3 {
                counter = counter + 1
            }
            else {
                counter = 1
            }
            break
        case 3:
            if counter < 4 {
                counter = counter + 1
            }
            else {
                counter = 1
            }
            break
        default:
            counter = 1
            break
        }
    }
    
    //Fonction qui met à jour l'image
    func updateImage() {
        switch tempoType {
        case 0:
            MetronomeImage.image = UIImage(named: "0_\(counter)")
            break
        case 1:
            MetronomeImage.image = UIImage(named: "2-4_\(counter)")
            break
        case 2:
            MetronomeImage.image = UIImage(named: "3-4_\(counter)")
            break
        case 3:
            MetronomeImage.image = UIImage(named: "4-4_\(counter)")
            break
        default:
            MetronomeImage.image = nil
            break
        }
    }
    
    //Quand le son finit de jouer, remet l'image avec aucun point allumé
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        switch tempoType {
        case 0:
            MetronomeImage.image = UIImage(named: "0_0")
            break
        case 1:
            MetronomeImage.image = UIImage(named: "2-4_0")
            break
        case 2:
            MetronomeImage.image = UIImage(named: "3-4_0")
            break
        case 3:
            MetronomeImage.image = UIImage(named: "4-4_0")
            break
        default:
            MetronomeImage.image = nil
            break
        }
    }
    
    //MARK: Mise à jour des informations
    
    //Met à jour le tempo quand on modifie le slider
    @IBAction func UpdateSlider(_ sender: Any) {
        //Arrondi la valeur du slider
        TempoSlider.value = TempoSlider.value.rounded(toPlaces: 0)
        
        //Change la valeur dans le textfield
        TempoTextField.text = String(Int(TempoSlider.value))
        
        //Change le tempo
        tempo = Int(TempoSlider.value)
        
        //Change le texte du tempo
        WriteTempo()
        
        //Change le timer
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        if parti == true {
            timer = Timer.scheduledTimer(timeInterval: 60/tempo, target: self, selector: #selector(JouerSon), userInfo: nil, repeats: true)
        }
    }
    
    //Met à jour le tempo quand on change la valeur dans le textfield
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Enlève le clavier
        TempoTextField.resignFirstResponder()
        
        if TempoTextField.text! != "" {
            //Si la valeur entrée n'est pas entre 40 et 300, met une alerte
            if Float(TempoTextField.text!)! < 40 || Float(TempoTextField.text!)! > 300 {
                let alert = UIAlertController(title: "Valeur incorrecte", message: "Veuillez saisir une valeur entre 40 et 300", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                TempoTextField.text = String(Int(TempoSlider.value))
            }
            //Sinon, change le tempo
            else{
                //Change la valeur du slider
                TempoSlider.value = Float(TempoTextField.text!)!
                
                //Change le tempo
                tempo = Int(TempoTextField.text!)!
                
                //Change le texte du tempo
                WriteTempo()
                
                //Change le timer
                if timer != nil {
                    timer!.invalidate()
                    timer = nil
                }
                if parti == true {
                    timer = Timer.scheduledTimer(timeInterval: 60/tempo, target: self, selector: #selector(JouerSon), userInfo: nil, repeats: true)
                }
            }
        }
        else {
            let alert = UIAlertController(title: "Valeur incorrecte", message: "Veuillez saisir une valeur entre 40 et 300", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            TempoTextField.text = String(Int(TempoSlider.value))
        }
    }
    
    //Est appelée quand on change la switch, met à jour la variable qui détermine si on joue le son haut
    @IBAction func SwitchChanged(_ sender: Any) {
        let laSwitch = sender as! UISwitch
        
        son = laSwitch.isOn
    }
    
    //Fonction qui détermine quel tempo à écrire (texte)
    func WriteTempo() {
        if tempo >= 40 && tempo < 52 {
            TempoLabel.text = "Largo"
        }
        else if tempo >= 52 && tempo <= 60 {
            TempoLabel.text = "Largo/Lento"
        }
        else if tempo > 60 && tempo <= 68 {
            TempoLabel.text = "Lento/Adagio"
        }
        else if tempo > 68 && tempo < 76 {
            TempoLabel.text = "Adagio"
        }
        else if tempo >= 76 && tempo <= 80 {
            TempoLabel.text = "Adagio/Andante"
        }
        else if tempo > 80 && tempo < 88 {
            TempoLabel.text = "Andante/Moderato"
        }
        else if tempo >= 88 && tempo < 100 {
            TempoLabel.text = "Moderato"
        }
        else if tempo >= 100 && tempo <= 112 {
            TempoLabel.text = "Moderato/Allegretto"
        }
        else if tempo > 112 && tempo <= 128 {
            TempoLabel.text = "Allegretto/Allegro"
        }
        else if tempo > 128 && tempo < 140 {
            TempoLabel.text = "Allegro"
        }
        else if tempo == 140 {
            TempoLabel.text = "Allegro/Vivace/Presto"
        }
        else if tempo > 140 && tempo <= 160 {
            TempoLabel.text = "Allegro/Presto"
        }
        else if tempo > 160 && tempo <= 188 {
            TempoLabel.text = "Presto"
        }
        else if tempo > 188 && tempo <= 200 {
            TempoLabel.text = "Presto/Prestissimo"
        }
        else if tempo > 200 {
            TempoLabel.text = "Prestissimo"
        }
    }
    
    //Met à jour le type de mesure quand on change les segments
    @IBAction func UpdateSegments(_ sender: Any) {
        switch TempoSegments.selectedSegmentIndex {
        case 0:
            tempoType = 0
            if timer == nil {
                MetronomeImage.image = UIImage(named: "0_0")
            }
            break
        case 1:
            tempoType = 1
            if timer == nil {
                MetronomeImage.image = UIImage(named: "2-4_0")
            }
            break
        case 2:
            tempoType = 2
            if timer == nil {
                MetronomeImage.image = UIImage(named: "3-4_0")
            }
            break
        case 3:
            tempoType = 3
            if timer == nil {
                MetronomeImage.image = UIImage(named: "4-4_0")
            }
            break
        default:
            tempoType = 0
        }
    }
    
    //MARK: Pour le bouton OK du clavier
    
    //Ajoute le bouton OK en haut du clavier
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        TempoTextField.inputAccessoryView = keyboardToolbar
    }
    
    //MARK: Pour le bouton vers le menu
    @IBAction func BackToMenu(_ sender: Any) {
        performSegue(withIdentifier: "BackToMenu", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
