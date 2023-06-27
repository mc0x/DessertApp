//
//  DescriptionsViewController.swift
//  Dessert App
//
//  Created by Mayra Cortez on 6/26/23.
//

import UIKit

class DescriptionsViewController: UIViewController {
    
    private let dessertImageView = UIImageView()
    let dessert:Dessert
    let heartButton = UIButton(type: .system)

    var tappedDesserts: [String] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureLogoImageView()

        configureIngredients()
        configureInstructions()
        addImageToSubview()

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(instructionsLabel)
        
        setupConstraints()
    }
    
    
    
    init(_ dessert: Dessert){
        self.dessert = dessert
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //if the user switches between screens, want to make sure this page refreshes
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true) //to show the the "<- Seach" top navigation bar
    }
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 2000)
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = dessert.strMeal
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureLogoImageView( ) {
        contentView.addSubview(dessertImageView)
        dessertImageView.translatesAutoresizingMaskIntoConstraints = false
        dessertImageView.layer.cornerRadius = 30
        dessertImageView.clipsToBounds = true
        
        let imageURL =  dessert.strMealThumb!
        
        NetworkManager.shared.downloadImage(from: imageURL) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self!.dessertImageView.image = image
                }
            case .failure(let error):
                print("Image download error: \(error)")
            }
        }
        
        NSLayoutConstraint.activate([
            dessertImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            dessertImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dessertImageView.heightAnchor.constraint(equalToConstant: 200),
            dessertImageView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func addImageToSubview() {
        let heartImage = UIImage(systemName: "heart")?.withTintColor(.red).withRenderingMode(.alwaysTemplate)
        heartImage?.withTintColor(.systemRed)
        heartButton.setImage(heartImage, for: .normal)
        heartButton.frame = CGRect(x: 0, y: 0, width: 400, height: 120)
        heartButton.tintColor = .systemRed
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        
        heartButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        contentView.addSubview(heartButton)
        
        // Set up constraints to position and size the image view within the subview
        NSLayoutConstraint.activate([
                heartButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                heartButton.widthAnchor.constraint(equalToConstant: 40),
                heartButton.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    @objc func buttonTapped() {
        let idMeal = dessert.idMeal!
        tappedDesserts.append(idMeal)
        
        let newImage = UIImage(systemName: "heart.fill")?.withTintColor(.red)
        heartButton.setImage(newImage, for: .normal)
        heartButton.tintColor = .systemRed        
    }
    
    private let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .left
        //label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    func configureIngredients(){
        view.addSubview(ingredientsLabel)
        let idMeal = dessert.idMeal!
        
        NetworkManager.shared.getIngredients(for: idMeal) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let ingredients):
                let combinedIngredients = ingredients.joined(separator: "\n")
                DispatchQueue.main.async {
                    let comb = "Ingredients:\n\n\(combinedIngredients)"
                    self.ingredientsLabel.text = comb
                    self.showIngredients(ingredients: comb)
                }
            case .failure(let error):
                print("Download error: \(error)")
            }
        }
    }
    
    
    func showIngredients(ingredients: String) {
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.text = ingredients
    }
    
    func showInstructions(instructions: String) {
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.text = instructions
    }
    
    func configureInstructions() {
        view.addSubview(instructionsLabel)
        let idMeal = dessert.idMeal!
        
        NetworkManager.shared.getDescriptions(for: idMeal) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let instructions):
                //let combinedIngredients = instructions.joined(separator: "\n")
                let comb = "Instructions:\n\n\(instructions)"

                DispatchQueue.main.async {
                    self.instructionsLabel.text = comb
                    self.showInstructions(instructions: comb)
                }
            case .failure(let error):
                print("Download error: \(error)")
            }
        }
    }
    
    func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(lessThanOrEqualTo: scrollView.widthAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            ingredientsLabel.topAnchor.constraint(equalTo: dessertImageView.bottomAnchor, constant: 20),
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ingredientsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            instructionsLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 30),
            instructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            instructionsLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    
}





