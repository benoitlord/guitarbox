//
//  favorites.swift
//  ChordRef
//
//  Created by Benoit Lord on 17-11-15.
//  Copyright © 2017 Benoit Lord. All rights reserved.
//

import UIKit

//Pour permettre de sauvegarder les favoris dans les données de l'app
struct defaultsKeys {
    static let favorites = "favorites"
    static let launchCount = "launchCount"
    static let rate = "rate"
}

let defaults = UserDefaults.standard




/*// Setting

let defaults = UserDefaults.standard
defaults.set("Some String Value", forKey: defaultsKeys.favorites)

// Getting

let defaults = UserDefaults.standard
if let stringOne = defaults.string(forKey: defaultsKeys.favorites) {
    print(stringOne) // Some String Value
}*/
