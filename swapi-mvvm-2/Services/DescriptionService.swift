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
        """
        \(String(localized: "Rotation period:")) \(planet.rotationPeriod) \n
        \(String(localized: "Orbital period:")) \(planet.orbitalPeriod) \n
        \(String(localized: "Diameter:")) \(planet.diameter) \n
        \(String(localized: "Climate:")) \(planet.climate.capitalized) \n
        \(String(localized: "Gravity:")) \(planet.gravity.capitalized) \n
        \(String(localized: "Terrain:")) \(planet.terrain.capitalized) \n
        \(String(localized: "Surface water level:")) \(planet.surfaceWater.capitalized) \n
        \(String(localized: "Population:")) \(planet.population)
        """
    }
    
    func filmDescription (film: FilmNetworkResponse) -> String {
        """
        \(String(localized: "Opening crawl:")) \n \n \(film.openingCrawl)\n
        \(String(localized: "Director:")) \(film.director)\n
        \(String(localized: "Producer:")) \(film.producer)\n
        \(String(localized: "Release date:")) \(film.releaseDate)
        """
    }
    
    func characterDescription (character: PersonNetworkResponse) -> String? {
    """
    \(String(localized: "Height:")) \(character.height) \n
    \(String(localized: "Mass:")) \(character.mass) \n
    \(String(localized: "Hair color:")) \(character.hairColor.capitalized) \n
    \(String(localized: "Skin color:")) \(character.skinColor.capitalized) \n
    \(String(localized: "Eye color:")) \(character.eyeColor.capitalized) \n
    \(String(localized: "Birth year:")) \(character.birthYear) \n
    \(String(localized: "Gender:")) \(character.gender.capitalized)
    """
    }
    
    func vehicleDescription(vehicle: VehicleNetworkResponse) -> String {
            """
            \(String(localized: "Cargo capacity:")) \(vehicle.cargoCapacity) \n
            \(String(localized: "Consumables:")) \(vehicle.consumables) \n
            \(String(localized: "Cost in credits:")) \(vehicle.costInCredits)\n
            \(String(localized: "Crew:")) \(vehicle.crew)\n
            \(String(localized: "Length:")) \(vehicle.length)\n
            \(String(localized: "Manufacturer:")) \(vehicle.manufacturer.capitalized)\n
            \(String(localized: "Max atmosphering speed:")) \(vehicle.maxAtmospheringSpeed)\n
            \(String(localized: "Model:")) \(vehicle.model.capitalized)\n
            \(String(localized: "Passengers:")) \(vehicle.passengers)\n
            \(String(localized: "Vehicle class:")) \(vehicle.vehicleClass.capitalized)
            """
    }
    
    func speciesDescription(species: SpeciesNetworkResponse) -> String {
        """
        \(String(localized: "Name:")) \(species.name)\n
        \(String(localized: "Classification:")) \(species.classification.capitalized)\n
        \(String(localized: "Average height:")) \(species.averageHeight)\n
        \(String(localized: "Skin colors:")) \(species.skinColors.capitalized)\n
        \(String(localized: "Hair colors:")) \(species.hairColors)\n
        \(String(localized: "Eye colors:")) \(species.eyeColors.capitalized)\n
        \(String(localized: "Average lifespan:")) \(species.averageLifespan) \(String(localized: "years")) \n
        \(String(localized: "Language:")) \(species.language)
        """
    }
    
    func starshipDescription (starship: StarshipNetworkResponse) -> String {
            """
            \(String(localized: "MGLT:")) \(starship.mglt)\n
            \(String(localized: "Cargo capacity:")) \(starship.cargoCapacity)\n
            \(String(localized: "Consumables:")) \(starship.consumables)\n
            \(String(localized: "Cost in credits:")) \(starship.costInCredits)\n
            \(String(localized: "Crew:")) \(starship.crew)\n
            \(String(localized: "Hyperdrive rating:")) \(starship.hyperdriveRating)\n
            \(String(localized: "Length:")) \(starship.length)\n
            \(String(localized: "Manufacturer:")) \(starship.manufacturer)\n
            \(String(localized: "Max atmosphering speed:")) \(starship.maxAtmospheringSpeed)\n
            \(String(localized: "Model:")) \(starship.model)\n
            \(String(localized: "Name:")) \(starship.name)\n
            \(String(localized: "Passengers:")) \(starship.passengers)\n
            \(String(localized: "Starship class:")) \(starship.starshipClass)
            """
    }
    
    
}
