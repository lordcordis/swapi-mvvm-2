//
//  PEOPLE.swift
//  SWAPI
//
//  Created by Wheatley on 18.04.2022.
//

import Foundation


struct CharacterNetworkResponse: Codable {
    let name, height, mass, hairColor: String
    let skinColor, eyeColor, birthYear, gender: String
    let homeworld: String
    let films: [String]
    let species: [String]?
    let vehicles, starships: [String]
    let created, edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, homeworld, films, species, vehicles, starships, created, edited, url
    }
}

struct CharacterListNetworkResponse: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [CharacterNetworkResponse]
}






