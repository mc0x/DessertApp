//
//  DAButton.swift
//  Dessert App
//
//  Created by Mayra Cortez on 6/23/23.
//

import UIKit

class DAButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //initialize the class
    init(background: UIColor, title: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = background
        self.setTitle(title, for: .normal)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
        
    }
}
