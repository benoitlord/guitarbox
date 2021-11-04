//
//  ViewController.swift
//  ChordRef
//
//  Created by Benoit Lord on 17-10-04.
//  Copyright © 2017 Benoit Lord. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AudioToolbox
import AVFoundation

class AccordViewController: UIViewController, GADBannerViewDelegate, AVAudioPlayerDelegate {
    
    //MARK: Propriétés
    var bonAccord: Accord?
    var favorite:Bool?
    var player: AVAudioPlayer?
    
    @IBOutlet weak var imageAccord: UIImageView!
    @IBOutlet weak var boutonFavoris: BoutonFavoris!
    @IBOutlet weak var boutonSon: BoutonSon!
    
    // Ad banner and interstitial views
    var adMobBannerView = GADBannerView()
    
    // IMPORTANT: REPLACE THE RED STRING BELOW WITH THE AD UNIT ID YOU'VE GOT BY REGISTERING YOUR APP IN http://apps.admob.com
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-8499742200234965/4679479876"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init AdMob banner
        initAdMobBanner()
        
        // Recevoir les infos de la tableview
        navigationItem.title = bonAccord?.name
        imageAccord.image = bonAccord?.photo
        
        //Sélectionner le bouton des favoris si l'accord est dans les favoris
        if favorite! {
            boutonFavoris.isSelected = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
        }
        
        //Shadow
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 3.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.6
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    // Pour passer l'info entre les scènes
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
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
            
            let index = favorites?.firstIndex(of: bonAccord!.name)
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
    
    //MARK: Audio
    @IBAction func playSound(_ sender: Any) {
        guard let url = Bundle.main.url(forResource: "sons/\(bonAccord?.son ?? "son")", withExtension: "wav") else { print ("le fichier n'existe pas"); return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player?.delegate = self
            
            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            let bouton = sender as! BoutonSon
            bouton.isSelected = true
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        boutonSon.isSelected = false
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
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
