//
//  TunerViewController.swift
//  ChordRef
//
//  Created by Benoit Lord on 18-01-03.
//  Copyright © 2018 Benoit Lord. All rights reserved.
//

import UIKit
import AudioKit
import GoogleMobileAds

//Extension pour arrondir les nombres
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//Classe pour contenir la note
class Pitch {
    var note: String
    var offset: Double
    
    init(note: String, offset: Double) {
        self.note = note
        self.offset = offset
    }
}


class TunerViewController: UIViewController, GADBannerViewDelegate {
    
    //MARK: Propriétés
    
    var timer: Timer?
    
    //Microphone Tracker
    let micro = AKMicrophoneTracker()
    
    //Outlets
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var aiguilleImage: UIImageView!
    @IBOutlet weak var tunerImage: UIImageView!
    
    // Ad banner and interstitial views
    var adMobBannerView = GADBannerView()
    
    // IMPORTANT: REPLACE THE RED STRING BELOW WITH THE AD UNIT ID YOU'VE GOT BY REGISTERING YOUR APP IN http://apps.admob.com
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-8499742200234965/6806808513"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init AdMob banner
        initAdMobBanner()
        
        //Pour enlever le bouton Back
        self.navigationItem.hidesBackButton = true
        
        //Démarre le Microphone Tracker
        micro.start()
        
        //Timer qui répète la fonction updateTuner() à chaque 0.1 seconde
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTuner), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer!.invalidate()
    }
    
    //MARK: Pour le bouton vers le menu
    @IBAction func BackToMenu(_ sender: Any) {
        performSegue(withIdentifier: "backToMenu", sender: self)
    }
    
    //MARK: Mise à jour de l'accordeur
    @objc func updateTuner() {
        
        //Donnée trouvées par le micro
        let frequence = micro.frequency
        let amplitude = micro.amplitude
        
        //Arrondie la fréquence
        let frequenceArrondie = frequence.rounded(toPlaces: 1)
        
        //Appèle la fonction qui trouve la note
        let note = trouverNote(frequence: frequenceArrondie)
        
        //Arrondie la différence
        let offset = note.offset.rounded(toPlaces: 1)
        
        //Si le son est assez fort
        if amplitude > 0.1 && note.note != "err" {
            
            //Met à jour les labels
            noteLabel.text = note.note
            offsetLabel.text = String(offset)
            
            //Trop bas
            if offset < -0.2 {
                tunerImage.image = UIImage(named: "TunerB")
            }
            //Trop Haut
            else if offset > 0.2 {
                tunerImage.image = UIImage(named: "Tuner#")
            }
            //OK
            else if offset > -0.2 && offset < 0.2 {
                tunerImage.image = UIImage(named: "TunerOK")
            }
            
            //Fait tourner l'aiguille
            aiguilleImage.transform = CGAffineTransform(rotationAngle: CGFloat(offset*0.1))
        }
        //Si le son n'est pas assez fort
        else{
            noteLabel.text = "-"
            offsetLabel.text = "-"
            tunerImage.image = UIImage(named: "Tuner")
            aiguilleImage.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
    //MARK: Pour déterminer quelle note est entendue
    func trouverNote (frequence: Double) -> Pitch {
        let notes: [String: Double] = ["c": 65.4, "c#": 69.2, "d": 73.4, "d#": 77.7, "e": 82.4, "f": 87.3, "f#": 92.5, "g": 98.0, "g#": 103.8, "a": 110.0, "a#": 116.5, "b": 123.4]
        
        if frequence < notes["c"]!-3.5 {
            let lanote = Pitch(note: "err", offset: 0.0)
            return lanote
        }
        else if frequence >= notes["c"]!-3.5 && frequence < notes["c#"]!-3.5 {
            let lanote = Pitch(note: "C", offset: frequence-notes["c"]!)
            return lanote
        }
        else if frequence >= notes["c#"]!-3.5 && frequence < notes["d"]!-3.5 {
            let lanote = Pitch(note: "C#", offset: frequence-notes["c#"]!)
            return lanote
        }
        else if frequence >= notes["d"]!-3.5 && frequence < notes["d#"]!-3.5 {
            let lanote = Pitch(note: "D", offset: frequence-notes["d"]!)
            return lanote
        }
        else if frequence >= notes["d#"]!-3.5 && frequence < notes["e"]!-3.5 {
            let lanote = Pitch(note: "D#", offset: frequence-notes["d#"]!)
            return lanote
        }
        else if frequence >= notes["e"]!-3.5 && frequence < notes["f"]!-3.5 {
            let lanote = Pitch(note: "E", offset: frequence-notes["e"]!)
            return lanote
        }
        else if frequence >= notes["f"]!-3.5 && frequence < notes["f#"]!-3.5 {
            let lanote = Pitch(note: "F", offset: frequence-notes["f"]!)
            return lanote
        }
        else if frequence >= notes["f#"]!-3.5 && frequence < notes["g"]!-3.5 {
            let lanote = Pitch(note: "F#", offset: frequence-notes["f#"]!)
            return lanote
        }
        else if frequence >= notes["g"]!-3.5 && frequence < notes["g#"]!-3.5 {
            let lanote = Pitch(note: "G", offset: frequence-notes["g"]!)
            return lanote
        }
        else if frequence >= notes["g#"]!-3.5 && frequence < notes["a"]!-3.5 {
            let lanote = Pitch(note: "G#", offset: frequence-notes["g#"]!)
            return lanote
        }
        else if frequence >= notes["a"]!-3.5 && frequence < notes["a#"]!-3.5 {
            let lanote = Pitch(note: "A", offset: frequence-notes["a"]!)
            return lanote
        }
        else if frequence >= notes["a#"]!-3.5 && frequence < notes["b"]!-3.5 {
            let lanote = Pitch(note: "A#", offset: frequence-notes["a#"]!)
            return lanote
        }
        else if frequence >= notes["b"]!-3.5 && frequence < (notes["c"]!*pow(2, 1))-3.5 {
            let lanote = Pitch(note: "B", offset: frequence-notes["b"]!)
            return lanote
        }
        else if frequence >= (notes["c"]!*pow(2, 1))-3.5 && frequence < (notes["c#"]!*pow(2, 1))-3.5 {
            let lanote = Pitch(note: "C", offset: frequence-notes["c"]!*pow(2, 1))
            return lanote
        }
        else if frequence >= (notes["c#"]!*pow(2, 1))-3.5 && frequence < (notes["d"]!*pow(2, 1))-3.5 {
            let lanote = Pitch(note: "C#", offset: frequence-notes["c#"]!*pow(2, 1))
            return lanote
        }
        else if frequence >= (notes["d"]!*pow(2, 1))-3.5 && frequence < (notes["d#"]!*pow(2, 1))-3.5 {
            let lanote = Pitch(note: "D", offset: frequence-notes["d"]!*pow(2, 1))
            return lanote
        }
        else if frequence >= (notes["d#"]!*pow(2, 1))-3.5 && frequence < (notes["e"]!*pow(2, 1))-3.5 {
            let lanote = Pitch(note: "D#", offset: frequence-notes["d#"]!*pow(2, 1))
            return lanote
        }
        else if frequence >= (notes["e"]!*pow(2, 1))-3.5 && frequence < (notes["f"]!*pow(2, 1))-3.5 {
            let lanote = Pitch(note: "E", offset: frequence-notes["e"]!*pow(2, 1))
            return lanote
        }
        else if frequence >= (notes["f"]!*pow(2, 1))-3.5 && frequence < (notes["f#"]!*pow(2, 1))-3.5 {
            let lanote = Pitch(note: "F", offset: frequence-notes["f"]!*pow(2, 1))
            return lanote
        }
        else if frequence >= (notes["f#"]!*pow(2, 1))-3.5 && frequence < (notes["g"]!*pow(2, 1))-3.5 {
            let lanote = Pitch(note: "F#", offset: frequence-notes["f#"]!*pow(2, 1))
            return lanote
        }
        else if frequence >= (notes["g"]!*pow(2, 1))-3.5 && frequence < (notes["g#"]!*pow(2, 1))-3.5 {
            let lanote = Pitch(note: "G", offset: frequence-notes["g"]!*pow(2, 1))
            return lanote
        }
        else if frequence >= (notes["g#"]!*pow(2, 1))-3.5 && frequence < (notes["a"]!*pow(2, 1))-3.5 {
            let lanote = Pitch(note: "G#", offset: frequence-notes["g#"]!*pow(2, 1))
            return lanote
        }
        else if frequence >= (notes["a"]!*pow(2, 1))-3.5 && frequence < (notes["a#"]!*pow(2, 1))-3.5 {
            let lanote = Pitch(note: "A", offset: frequence-notes["a"]!*pow(2, 1))
            return lanote
        }
        else if frequence >= (notes["a#"]!*pow(2, 1))-3.5 && frequence < (notes["b"]!*pow(2, 1))-3.5 {
            let lanote = Pitch(note: "A#", offset: frequence-notes["a#"]!*pow(2, 1))
            return lanote
        }
        else if frequence >= (notes["b"]!*pow(2, 1))-3.5 && frequence < (notes["c"]!*pow(2, 2))-3.5 {
            let lanote = Pitch(note: "B", offset: frequence-notes["b"]!*pow(2, 1))
            return lanote
        }
        else if frequence >= (notes["c"]!*pow(2, 2))-3.5 && frequence < (notes["c#"]!*pow(2, 2))-3.5 {
            let lanote = Pitch(note: "C", offset: frequence-notes["c"]!*pow(2, 2))
            return lanote
        }
        else if frequence >= (notes["c#"]!*pow(2, 2))-3.5 && frequence < (notes["d"]!*pow(2, 2))-3.5 {
            let lanote = Pitch(note: "C#", offset: frequence-notes["c#"]!*pow(2, 2))
            return lanote
        }
        else if frequence >= (notes["d"]!*pow(2, 2))-3.5 && frequence < (notes["d#"]!*pow(2, 2))-3.5 {
            let lanote = Pitch(note: "D", offset: frequence-notes["d"]!*pow(2, 2))
            return lanote
        }
        else if frequence >= (notes["d#"]!*pow(2, 2))-3.5 && frequence < (notes["e"]!*pow(2, 2))-3.5 {
            let lanote = Pitch(note: "D#", offset: frequence-notes["d#"]!*pow(2, 2))
            return lanote
        }
        else if frequence >= (notes["e"]!*pow(2, 2))-3.5 && frequence < (notes["f"]!*pow(2, 2))-3.5 {
            let lanote = Pitch(note: "E", offset: frequence-notes["e"]!*pow(2, 2))
            return lanote
        }
        else if frequence >= (notes["f"]!*pow(2, 2))-3.5 && frequence < (notes["f#"]!*pow(2, 2))-3.5 {
            let lanote = Pitch(note: "F", offset: frequence-notes["f"]!*pow(2, 2))
            return lanote
        }
        else if frequence >= (notes["f#"]!*pow(2, 2))-3.5 && frequence < (notes["g"]!*pow(2, 2))-3.5 {
            let lanote = Pitch(note: "F#", offset: frequence-notes["f#"]!*pow(2, 2))
            return lanote
        }
        else if frequence >= (notes["g"]!*pow(2, 2))-3.5 && frequence < (notes["g#"]!*pow(2, 2))-3.5 {
            let lanote = Pitch(note: "G", offset: frequence-notes["g"]!*pow(2, 2))
            return lanote
        }
        else if frequence >= (notes["g#"]!*pow(2, 2))-3.5 && frequence < (notes["a"]!*pow(2, 2))-3.5 {
            let lanote = Pitch(note: "G#", offset: frequence-notes["g#"]!*pow(2, 2))
            return lanote
        }
        else if frequence >= (notes["a"]!*pow(2, 2))-3.5 && frequence < (notes["a#"]!*pow(2, 2))-3.5 {
            let lanote = Pitch(note: "A", offset: frequence-notes["a"]!*pow(2, 2))
            return lanote
        }
        else if frequence >= (notes["a#"]!*pow(2, 2))-3.5 && frequence < (notes["b"]!*pow(2, 2))-3.5 {
            let lanote = Pitch(note: "A#", offset: frequence-notes["a#"]!*pow(2, 2))
            return lanote
        }
        else if frequence >= (notes["b"]!*pow(2, 2))-3.5 && frequence < (notes["c"]!*pow(2, 3))-3.5 {
            let lanote = Pitch(note: "B", offset: frequence-notes["b"]!*pow(2, 2))
            return lanote
        }
        else if frequence < (notes["c"]!*pow(2, 3))-3.5 {
            return Pitch(note: "err", offset: 0.0)
        }
        
        return Pitch(note: "err", offset: 0.0)
    }
    
    // MARK: -  ADMOB BANNER
    func initAdMobBanner() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 320, height: 50)
        } else  {
            // iPad
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 468, height: 60))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 468, height: 60)
        }
        
        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        view.addSubview(adMobBannerView)
        
        let request = GADRequest()
        adMobBannerView.load(request)
    }
    
    
    // Hide the banner
    func hideBanner(_ banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = true
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = false
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        hideBanner(adMobBannerView)
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
