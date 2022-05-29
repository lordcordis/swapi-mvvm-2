//
//  PeopleDescription.swift
//  SWAPI
//
//  Created by Wheatley on 25.04.2022.
//

import Foundation

func characterDescription (character: CharacterNetworkResponse) -> String {
    
    let output = """
Height: \(character.height) \n
Mass: \(character.mass) \n
Hair color: \(character.hairColor.capitalized) \n
Skin color: \(character.skinColor.capitalized) \n
Eye color: \(character.eyeColor.capitalized) \n
Birth year: \(character.birthYear) \n
Gender: \(character.gender.capitalized) \n
Films: \([character.films]) \n
Species: \([character.species]) \n
Vehicles: \(character.vehicles) \n
Starships: \(character.starships) \n
"""
    
    
    return output
}
