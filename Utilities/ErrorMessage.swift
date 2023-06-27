//
//  ErrorMessage.swift
//  Dessert App
//
//  Created by Mayra Cortez on 6/23/23.
//

import Foundation

enum DAError: String, Error {
    case unableToComplete = "Unable to complete your request, please check your internet connection.🤪"
    case invalidResponse = "Invalid Response from the server. Please try again. 😕"
    case invalidData = "The data received from the server was invalid. Please try again. 🤨"
}
