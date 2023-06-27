//
//  NetworkManager.swift
//  Dessert App
//
//  Created by Mayra Cortez on 6/23/23.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://www.themealdb.com/api/json/"

    private init(){}
    
    func getDesserts(completed: @escaping (Result<[Dessert], DAError>) -> Void) {
        let endpoint = baseURL + "v1/1/filter.php?c=Dessert"

        guard let url = URL(string: endpoint) else {
            completed(.failure(.unableToComplete))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))

                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let desserts = try decoder.decode(DessertResponse.self, from: data)
                
                completed(.success(desserts.meals))
            }catch {
                print("4")
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    
    func getDescriptions(for idMeal: String, completed: @escaping (Result<String, DAError>) -> Void) {
        let descriptionEndpoint = baseURL + "v1/1/lookup.php?i=\(idMeal)"

        guard let url = URL(string: descriptionEndpoint) else {
            completed(.failure(.unableToComplete))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))

                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let desserts = try decoder.decode(DessertResponse.self, from: data)
                
                //filter null and empty values
                _ = desserts.meals.map { dessert -> Dessert in
                let filteredInstructions = dessert.strInstructions?.replacingOccurrences(of: "\n", with: "")
                                                                  .replacingOccurrences(of: "\r", with: "")
                let updatedDessert = Dessert(strMeal: dessert.strMeal,
                                             strCategory: dessert.strCategory,
                                             strInstructions: filteredInstructions
                                             )
                completed(.success(updatedDessert.strInstructions!))
                return updatedDessert
                }
            }catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func downloadImage(from urlString: String, completed: @escaping (Result<UIImage, DAError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completed(.failure(.invalidData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                completed(.failure(.unableToComplete))
                return
            }
            completed(.success(image))
        }
        task.resume()
    }
    
    
    func getIngredients(for idMeal: String, completed: @escaping (Result<[String], DAError>) -> Void) {
        let endpoint = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(idMeal)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidData))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.unableToComplete))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(DessertResponse.self, from: data)

                if let dessert = response.meals.first {
                    var ingredients: [String] = []
                    let dessertMirror = Mirror(reflecting: dessert)

                    for case let (label?, value) in dessertMirror.children {
                        if let ingredient = value as? String, !ingredient.isEmpty,
                           label.starts(with: "strIngredient"),
                           let index = Int(label.dropFirst("strIngredient".count)),
                           let measurement = dessertMirror.children.first(where: { $0.label == "strMeasure\(index)" })?.value as? String, !measurement.isEmpty {
                            let combinedIngredient = "\(measurement) \(ingredient)"
                            ingredients.append(combinedIngredient)
                        }
                    }

                    completed(.success(ingredients))
                } else {
                    completed(.failure(.invalidResponse))
                }
            } catch {
                        completed(.failure(.invalidResponse))
            }
               
        }
        task.resume()
    }
}
