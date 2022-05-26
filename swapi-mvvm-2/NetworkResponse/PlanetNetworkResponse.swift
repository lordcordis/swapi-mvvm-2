//
//  Planet.swift
//  SWAPI
//
//  Created by Wheatley on 14.04.2022.
//

import Foundation


struct PlanetNetworkResponse: Codable {
    let name, rotationPeriod, orbitalPeriod, diameter: String
    let climate, gravity, terrain, surfaceWater: String
    let population: String
    let residents: [String]?
    let films: [String]
    let created, edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter, climate, gravity, terrain
        case surfaceWater = "surface_water"
        case population, residents, films, created, edited, url
    }
}

struct PlanetsListNetworkResponse: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [PlanetNetworkResponse]
}



