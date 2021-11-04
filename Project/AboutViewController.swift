//
//  AboutViewController.swift
//  GuitarBox
//
//  Created by Benoit Lord on 18-01-16.
//  Copyright © 2018 Benoit Lord. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UITextViewDelegate {
    
    //MARK: Propriétés
    
    //Outlets
    @IBOutlet weak var AboutImage: UIImageView!
    @IBOutlet weak var TitreAbout: UILabel!
    @IBOutlet weak var test: UITextView!
    
    //Change la couleur de la status bar en blanc
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Localization
        
        //Met le texte dans le titre selon la langue
        TitreAbout.text = NSLocalizedString("About titre", comment: "")
        
        //Crée une string avec attributs
        let mutableString: NSMutableAttributedString
        
        //Change la grosseur du texte selon la plateforme
        if UIDevice.current.userInterfaceIdiom == .pad {
            mutableString = NSMutableAttributedString(string: NSLocalizedString("About", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Arial", size: 25)!])
        }
        else{
            mutableString = NSMutableAttributedString(string: NSLocalizedString("About", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Arial", size: 18)!])
        }
        
        print(NSLocale.autoupdatingCurrent.languageCode!)
        
        //Ajoute la couleur et le soulignement à la bonne place selon la langue
        switch NSLocale.autoupdatingCurrent.languageCode! {
        case "en", "en-US", "en-GB", "en-AU":
            mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 86/255, green:39/255, blue:7/255, alpha: 1), range: NSRange(location: 284, length: 18))
            mutableString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 284, length: 18))
            mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 86/255, green:39/255, blue:7/255, alpha: 1), range: NSRange(location: 343, length: 16))
            mutableString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 343, length: 16))
            break
        case "fr", "fr-CA", "fr-FR":
            mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:86/255, green:39/255, blue:7/255, alpha: 1), range: NSRange(location: 354, length: 18))
            mutableString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 354, length: 18))
            mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:86/255, green:39/255, blue:7/255, alpha: 1), range: NSRange(location: 429, length: 16))
            mutableString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 429, length: 16))
            break
        default:
            mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:86/255, green:39/255, blue:7/255, alpha: 1), range: NSRange(location: 284, length: 18))
            mutableString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 284, length: 18))
            mutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 86/255, green:39/255, blue:7/255, alpha: 1), range: NSRange(location: 343, length: 16))
            mutableString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange(location: 343, length: 16))
            break
        }
        test.attributedText = mutableString
        test.isEditable = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions
    
    //Dismiss la view quand on clique sur OK
    @IBAction func OK(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Lien
    
    //Permet d'ouvrir le lien dans le texte about
    @IBAction func ClickedTextView(_ sender: UITapGestureRecognizer) {
        let myTextView = sender.view as! UITextView
        let layoutManager = myTextView.layoutManager
        
        // location of tap in myTextView coordinates and taking the inset into account
        var location = sender.location(in: myTextView)
        location.x -= myTextView.textContainerInset.left;
        location.y -= myTextView.textContainerInset.top;
        
        
        // character index at tap location
        let characterIndex = layoutManager.characterIndex(for: location, in: myTextView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        // if index is valid then do something.
        if characterIndex < myTextView.textStorage.length {
            
            let orgString = myTextView.attributedText.string
            
            //Find the WWW
            var didFind = false
            var count:Int = characterIndex
            while(count > 2 && didFind == false){
                
                let myRange = NSRange(location: count-1, length: 2)
                let substring = (orgString as NSString).substring(with: myRange)
                
                if substring == " w" || (substring  == "w." && count == 3){
                    didFind = true
                    
                    var count2 = count
                    while(count2 < orgString.count){
                        
                        let myRange = NSRange(location: count2 - 1, length: 2)
                        let substring = (orgString as NSString).substring(with: myRange)
                        
                        count2 += 1
                        
                        //If it was at the end of textView
                        if count2  == orgString.count {
                            
                            let length = orgString.count - count
                            let myRange = NSRange(location: count, length: length)
                            
                            let substring = (orgString as NSString).substring(with: myRange)
                            
                            openLink(link: substring)
                            print("It's a Link",substring)
                            return
                        }
                        
                        //If it's in the middle
                        if substring.hasSuffix(" "){
                            
                            let length =  count2 - count
                            let myRange = NSRange(location: count, length: length)
                            
                            let substring = (orgString as NSString).substring(with: myRange)
                            
                            openLink(link: substring)
                            print("It's a Link",substring)
                            
                            return
                        }
                    }
                    return
                }
                
                if substring.hasPrefix(" "){
                    print("Not a link")
                    return
                }
                count -= 1
            }
        }
    }
    
    func openLink(link:String){
        
        if let checkURL = URL(string: "http://\(link.replacingOccurrences(of: " ", with: ""))") {
            if UIApplication.shared.canOpenURL(checkURL) {
                UIApplication.shared.open(checkURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                
                print("url successfully opened")
            }
        } else {
            print("invalid url")
        }
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
