//
//  IngredientsLabel.swift
//  Dessert App
//
//  Created by Mayra Cortez on 6/26/23.
//

import UIKit

class IngredientsLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment){
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    private func configure(){
        textColor = .secondaryLabel
        font = .systemFont(ofSize: 20, weight: .semibold)
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping //displays word wrapping
        translatesAutoresizingMaskIntoConstraints = false  //set autolayout
        
    }

}
