//
//  FavoritesCell.swift
//  Dessert App
//
//  Created by Mayra Cortez on 6/23/23.
//

import UIKit

class DessertsCell: UITableViewCell {

    static let reuseID = "FavCell"
    let dessertImageView = DessertsImageView(frame: .zero)
    let dessertName = DANameLabel(textAlignment: .left, fontSize: 26)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(dessert: Dessert) {
        dessertName.text = dessert.strMeal
        dessertImageView.downloadImage(from: dessert.strMealThumb!)
    }
    
    private func configure() {
        addSubview(dessertImageView)
        addSubview(dessertName)
        
        accessoryType = .disclosureIndicator //tells user this is tappable and there is more to see " > "
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            dessertImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dessertImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            dessertImageView.heightAnchor.constraint(equalToConstant: 60),
            dessertImageView.widthAnchor.constraint(equalToConstant: 60),
            
            dessertName.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dessertName.leadingAnchor.constraint(equalTo: dessertImageView.trailingAnchor, constant: 24),
            dessertName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            dessertName.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }

}
