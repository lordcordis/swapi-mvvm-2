//
//  DescriptionService.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 04.06.2022.
//

import Foundation
class DescriptionService {
    
    static var shared = DescriptionService()
    
    func planetDescription (planet: PlanetNetworkResponse) -> String? {
        
        let description: String = """
        Rotation period: \(planet.rotationPeriod) \n
        Orbital period: \(planet.orbitalPeriod) \n
        Diameter: \(planet.diameter) \n
        Climate: \(planet.climate.capitalized) \n
        Gravity: \(planet.gravity.capitalized) \n
        Terrain: \(planet.terrain.capitalized) \n
        Surface water level: \(planet.surfaceWater.capitalized) \n
        Population: \(planet.population)
        """
        
        return description
        
    }
    
    func characterDescription (character: PersonNetworkResponse) -> String? {
        
        let output = """
    Height: \(character.height) \n
    Mass: \(character.mass) \n
    Hair color: \(character.hairColor.capitalized) \n
    Skin color: \(character.skinColor.capitalized) \n
    Eye color: \(character.eyeColor.capitalized) \n
    Birth year: \(character.birthYear) \n
    Gender: \(character.gender.capitalized) \n
    Species: \([character.species]) \n
    Starships: \(character.starships) \n
    """
        
        
        return output
    }
    
    func filmDescription (film: FilmNetworkResponse) -> String {
        let output = """
        Opening crawl: \n \n \(film.openingCrawl)\n
        Director: \(film.director)\n
        Producer: \(film.producer)\n
        Release date: \(film.releaseDate)\n
        Starships: \(film.planets)\n
        Vehicles: \(film.planets)\n
        Species: \(film.species)\n
        """
        return output
    }
    
    func speciesDescription(species: SpeciesNetworkResponse) -> String {
        
        let output = """
name \(species.name)\n
classification \(species.classification)\n
designation: Designation\n
averageHeight \(species.averageHeight)\n
skinColors \(species.skinColors)\n
hairColors \(species.hairColors)\n
eyeColors: \(species.eyeColors)\n
averageLifespan: \(species.averageLifespan)\n
homeworld: String \(species.homeworld ?? "unknown")\n
language: \(species.language)\n
people \(species.people)\n
films \(species.films)\n
"""
        
        return output
        
        
//        enum Designation: String, Codable {
//            case reptilian = "reptilian"
//            case sentient = "sentient"
//        }
    }
    
}
