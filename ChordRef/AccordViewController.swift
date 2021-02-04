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

class AccordViewController: UIViewController, GADBannerViewDelegate {
    
    //MARK: Propriétés
    var bonAccord: Accord?
    var favorite:Bool?
    
    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var imageAccord: UIImageView!
    @IBOutlet weak var boutonFavoris: BoutonFavoris!
    
    // Ad banner and interstitial views
    var adMobBannerView = GADBannerView()
    
    // IMPORTANT: REPLACE THE RED STRING BELOW WITH THE AD UNIT ID YOU'VE GOT BY REGISTERING YOUR APP IN http://apps.admob.com
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-8499742200234965/4679479876"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init AdMob banner
        initAdMobBanner()
        
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

