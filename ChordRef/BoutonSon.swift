//
//  BoutonFavoris.swift
//  ChordRef
//
//  Created by Benoit Lord on 17-10-04.
//  Copyright © 2017 Benoit Lord. All rights reserved.
//

import UIKit

//Classe qui permet de créer le bouton des favoris
@IBDesignable class BoutonSon: UIButton {
    
    //MARK: Propriétés
    @IBInspectable var size: CGSize = CGSize(width: 50.0, height: 50.0) {
        didSet{
            setupButton()
        }
    }
    
    //MARK: Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        setupButton()
    }
    
    //MARK: Fonctions privées
    
    //Configure le bouton
    private func setupButton() {
        let bundle = Bundle(for: type(of: self))
        let SonImage = UIImage(named: "Son", in: bundle, compatibleWith: self.traitCollection)
        let SonImageSelected = UIImage(named: "SonSelected", in: bundle, compatibleWith: self.traitCollection)
        
        let SonImageGros = UIImage(named: "SonGros", in: bundle, compatibleWith: self.traitCollection)
        let SonImageSelectedGros = UIImage(named: "SonSelectedGros", in: bundle, compatibleWith: self.traitCollection)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.setImage(SonImage, for: .normal)
            self.setImage(SonImageSelected, for: .selected)
        }
        else{
            self.setImage(SonImageGros, for: .normal)
            self.setImage(SonImageSelectedGros, for: .selected)
        }
    }

}
