//
//  AboutViewController.swift
//  GuitarBox
//
//  Created by Benoit Lord on 18-01-16.
//  Copyright © 2018 Benoit Lord. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var AboutImage: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func OK(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
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
                UIApplication.shared.open(checkURL, options: [:], completionHandler: nil)
                
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
