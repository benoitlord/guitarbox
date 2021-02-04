//
//  TunerViewController.swift
//  ChordRef
//
//  Created by Benoit Lord on 18-01-03.
//  Copyright © 2018 Benoit Lord. All rights reserved.
//

import UIKit
import AudioKit

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class Pitch {
    var note: String
    var offset: Double
    
    init(note: String, offset: Double) {
        self.note = note
        self.offset = offset
    }
}

class TunerViewController: UIViewController {
    
    let micro = AKMicrophoneTracker()
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var offsetLabel: UILabel!
    @IBOutlet weak var aiguilleImage: UIImageView!
    @IBOutlet weak var tunerImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        micro.start()
        
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTuner), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func BackToMenu(_ sender: Any) {
        performSegue(withIdentifier: "backToMenu", sender: self)
    }
    
    @objc func updateTuner() {
        let frequence = micro.frequency
        let amplitude = micro.amplitude
        
        let frequenceArrondie = frequence.rounded(toPlaces: 1)
        
        let note = trouverNote(frequence: frequenceArrondie)
        let offset = note.offset.rounded(toPlaces: 1)
        
        if amplitude > 0.1 && note.note != "err" {
            
            noteLabel.text = note.note
            offsetLabel.text = String(offset)
            
            if offset < -0.2 {
                tunerImage.image = UIImage(named: "TunerB")
            }
            else if offset > 0.2 {
                tunerImage.image = UIImage(named: "Tuner#")
            }
            else if offset > -0.2 && offset < 0.2 {
                tunerImage.image = UIImage(named: "TunerOK")
            }
            
            aiguilleImage.transform = CGAffineTransform(rotationAngle: CGFloat(offset*0.1))
        }
        else{
            noteLabel.text = "-"
            offsetLabel.text = "-"
            tunerImage.image = UIImage(named: "Tuner")
            aiguilleImage.transform = CGAffineTransform(rotationAngle: 0)
        }
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
