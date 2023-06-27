//
//  DessertListViewController.swift
//  Dessert App
//
//  Created by Mayra Cortez on 6/24/23.
//

import UIKit

class DessertListViewController: UIViewController {
    
    let tableView = UITableView()
    var desserts: [Dessert] = []
 

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        
    }
    

    //if the user switches between screens, want to make sure this page refreshes
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true) //to show the the "<- Seach" top navigation bar
        getDesserts()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Desserts"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DessertsCell.self, forCellReuseIdentifier: DessertsCell.reuseID)
        
    }

    
    func getDesserts() {
        NetworkManager.shared.getDesserts { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let desserts):
                //print(desserts)
                self.desserts = desserts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView) //make sure tableView is on top of stack
                }
            case .failure(let error):
                print("error has occured hey \(error)")
            }
        }
    }
}

extension DessertListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desserts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DessertsCell.reuseID) as! DessertsCell
        let dessert = desserts[indexPath.row] //indexPath.row - returns an int, which is the index
        cell.set(dessert: dessert)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dessert = desserts[indexPath.row]
        let destVC = DescriptionsViewController(dessert)
        //destVC.username = dessert.strInstructions
        destVC.title = dessert.idMeal
        
        navigationController?.pushViewController(destVC, animated: true)
    }
}
