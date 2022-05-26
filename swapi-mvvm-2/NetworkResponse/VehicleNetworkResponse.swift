//
//  Vehicle.swift
//  SWAPI
//
//  Created by Wheatley on 25.04.2022.
//

import Foundation

struct VehicleNetworkResponse: Codable {
    let cargoCapacity, consumables, costInCredits, created: String
    let crew, edited, length, manufacturer: String
    let maxAtmospheringSpeed, model, name, passengers: String
    let pilots: [String]?
    let films: [String]
    let url: String
    let vehicleClass: String

    enum CodingKeys: String, CodingKey {
        case cargoCapacity = "cargo_capacity"
        case consumables
        case costInCredits = "cost_in_credits"
        case created, crew, edited, length, manufacturer
        case maxAtmospheringSpeed = "max_atmosphering_speed"
        case model, name, passengers, pilots, films, url
        case vehicleClass = "vehicle_class"
    }
}

struct VehicleListNetworkResponse: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [VehicleNetworkResponse]
}
