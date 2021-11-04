//
//  BoutonFavoris.swift
//  ChordRef
//
//  Created by Benoit Lord on 17-10-04.
//  Copyright © 2017 Benoit Lord. All rights reserved.
//

import UIKit

//Classe qui permet de créer le bouton des favoris
@IBDesignable class BoutonFavoris: UIButton {
    
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
        let FavorisImage = UIImage(named: "AddFavoris", in: bundle, compatibleWith: self.traitCollection)
        let FavorisImageSelected = UIImage(named: "AddFavorisSelected", in: bundle, compatibleWith: self.traitCollection)
        
        let FavorisImageGros = UIImage(named: "AddFavorisGros", in: bundle, compatibleWith: self.traitCollection)
        let FavorisImageSelectedGros = UIImage(named: "AddFavorisSelectedGros", in: bundle, compatibleWith: self.traitCollection)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.setImage(FavorisImage, for: .normal)
            self.setImage(FavorisImageSelected, for: .selected)
        }
        else{
            self.setImage(FavorisImageGros, for: .normal)
            self.setImage(FavorisImageSelectedGros, for: .selected)
        }
    }

}
