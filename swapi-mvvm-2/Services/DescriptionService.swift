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
    
    func filmDescription (film: FilmNetworkResponse) -> String {
        let output = """
        Opening crawl: \n \n \(film.openingCrawl)\n
        Director: \(film.director)\n
        Producer: \(film.producer)\n
        Release date: \(film.releaseDate)\n
        """
        return output
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
    
    func vehicleDescription(vehicle: VehicleNetworkResponse) -> String {
        let output = """
            Cargo capacity: \(vehicle.cargoCapacity) \n
            Consumables: \(vehicle.consumables) \n
            Cost in credits: \(vehicle.costInCredits)\n
            Crew: \(vehicle.crew)\n
            Length: \(vehicle.length)\n
            Manufacturer: \(vehicle.manufacturer.capitalized)\n
            Max Atmosphering Speed: \(vehicle.maxAtmospheringSpeed)\n
            Model: \(vehicle.model.capitalized)\n
            Passengers: \(vehicle.passengers)\n
            Vehicle Class: \(vehicle.vehicleClass.capitalized) \n
            """
        return output
        
    }
    
    func speciesDescription(species: SpeciesNetworkResponse) -> String {
        
        let output = """
        Name: \(species.name)\n
        Classification: \(species.classification.capitalized)\n
        Average height: \(species.averageHeight)\n
        Skin colors: \(species.skinColors.capitalized)\n
        Hair colors: \(species.hairColors)\n
        Eye colors: \(species.eyeColors.capitalized)\n
        Average lifespan: \(species.averageLifespan) years \n
        Language: \(species.language)\n
        """
        
        return output
    }
    
    func starshipDescription (starship: StarshipNetworkResponse) -> String {
        let output = """
            MGLT: \(starship.mglt)\n
            Cargo capacity: \(starship.cargoCapacity)\n
            Consumables: \(starship.consumables)\n
            Cost in credits: \(starship.costInCredits)\n
            Crew: \(starship.crew)\n
            Hyperdrive rating: \(starship.hyperdriveRating)\n
            Length: \(starship.length)\n
            Manufacturer: \(starship.manufacturer)\n
            Max atmosphering speed: \(starship.maxAtmospheringSpeed)\n
            Model: \(starship.model)\n
            Name: \(starship.name)\n
            Passengers: \(starship.passengers)\n
            Starship class: \(starship.starshipClass)
            """
        return output
    }
    
    
}
