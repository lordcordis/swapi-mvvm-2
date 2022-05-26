//
//  Species.swift
//  SWAPI
//
//  Created by Wheatley on 25.04.2022.
//

import Foundation

struct SpeciesNetworkResponse: Codable {
    let averageHeight, averageLifespan, classification, created: String
    let designation, edited, eyeColors, hairColors: String
    let homeworld: String
    let language, name: String
    let people, films: [String]
    let skinColors: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case averageHeight = "average_height"
        case averageLifespan = "average_lifespan"
        case classification, created, designation, edited
        case eyeColors = "eye_colors"
        case hairColors = "hair_colors"
        case homeworld, language, name, people, films
        case skinColors = "skin_colors"
        case url
    }
}

struct SpeciesListNetworkResponse: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [SpeciesNetworkResponse]
}
