//
//  SearchViewController.swift
//  Dessert App
//
//  Created by Mayra Cortez on 6/23/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    let logoImageView = UIImageView()
    let logoNameImageView = UIImageView()
    let dessertActionButton = DAButton(background: .systemOrange, title: "Desserts")
    
    let padding: CGFloat = 50
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureLogoNameImageView()
        configureDessertActionButton()

    }
    
    override func viewWillAppear(_ animated: Bool) {  //using viewWillAppear calls this every time the view appears
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true) //will remove search title when return to search is selected
    }
    
    @objc func pushDessertListVC() {
        let dessertListVC = DessertListViewController()
        navigationController?.pushViewController(dessertListVC, animated: true)
    }
    
    
    
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "meal-icon")
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func configureLogoNameImageView() {
        view.addSubview(logoNameImageView)
        logoNameImageView.translatesAutoresizingMaskIntoConstraints = false
        logoNameImageView.image = UIImage(named: "logo-small")
        
        NSLayoutConstraint.activate([
            logoNameImageView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: -padding),
            logoNameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoNameImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            logoNameImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            logoNameImageView.heightAnchor.constraint(equalToConstant: padding)
        ])
    }
    
    func configureDessertActionButton() {
        view.addSubview(dessertActionButton)
        dessertActionButton.addTarget(self, action: #selector(pushDessertListVC), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            dessertActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            dessertActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dessertActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dessertActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
