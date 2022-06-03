//
//  PEOPLE.swift
//  SWAPI
//
//  Created by Wheatley on 18.04.2022.
//

import Foundation


struct PersonNetworkResponse: Codable, NetworkResponse {
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
    
//    var description: String {
//        let output = """
//    Height: \(height) \n
//    Mass: \(mass) \n
//    Hair color: \(hairColor.capitalized) \n
//    Skin color: \(skinColor.capitalized) \n
//    Eye color: \(eyeColor.capitalized) \n
//    Birth year: \(birthYear) \n
//    Gender: \(gender.capitalized) \n
//    Species: \([species]) \n
//    Vehicles: \(vehicles) \n
//    Starships: \(starships) \n
//    Homeworld: \(homeworld)
//    """
//        
//        
//        return output
//    }
    
    
//    static func characterDescription (character: PersonNetworkResponse) -> String? {
//
//        let output = """
//    Height: \(character.height) \n
//    Mass: \(character.mass) \n
//    Hair color: \(character.hairColor.capitalized) \n
//    Skin color: \(character.skinColor.capitalized) \n
//    Eye color: \(character.eyeColor.capitalized) \n
//    Birth year: \(character.birthYear) \n
//    Gender: \(character.gender.capitalized) \n
//    Species: \([character.species]) \n
//    Vehicles: \(character.vehicles) \n
//    Starships: \(character.starships) \n
//    Homeworld: \(character.homeworld)
//    """
//
//
//        return output
//    }
}

struct CharacterListNetworkResponse: Codable {
    let count: Int
    let next: String
    let previous: String?
    let results: [PersonNetworkResponse]
}






