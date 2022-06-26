//
//  Starship.swift
//  SWAPI
//
//  Created by Wheatley on 25.04.2022.
//

import Foundation

struct StarshipNetworkResponse: Codable, NetworkResponse {
    let mglt, cargoCapacity, consumables, costInCredits: String
    let created, crew, edited, hyperdriveRating: String
    let length, manufacturer, maxAtmospheringSpeed, model: String
    let name, passengers: String
    let films: [String]
    let pilots: [String]?
    let starshipClass: String
    let url: String
    
//    var description: String {
//        let output = """
//        MGLT: \(mglt)\n
//        Cargo capacity: \(cargoCapacity)\n
//        Consumables: \(consumables)\n
//        Cost in credits: \(costInCredits)\n
//        Crew: \(crew)\n
//        Hyperdrive rating: \(hyperdriveRating)\n
//        Length: \(length)\n
//        Manufacturer: \(manufacturer)\n
//        Max atmosphering speed: \(maxAtmospheringSpeed)\n
//        Model: \(model)\n
//        Name: \(name)\n
//        Passengers: \(passengers)\n
//        Starship class: \(starshipClass)
//        """
//        return output
//    }

    enum CodingKeys: String, CodingKey {
        case mglt = "MGLT"
        case cargoCapacity = "cargo_capacity"
        case consumables
        case costInCredits = "cost_in_credits"
        case created, crew, edited
        case hyperdriveRating = "hyperdrive_rating"
        case length, manufacturer
        case maxAtmospheringSpeed = "max_atmosphering_speed"
        case model, name, passengers, films, pilots
        case starshipClass = "starship_class"
        case url
    }
}

struct StarshipListNetworkResponse: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [StarshipNetworkResponse]
}
