//
//  TestViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 29.05.2022.
//

import Foundation

class TestViewModel {
    
    static func planetDescriptionString (planet: PlanetNetworkResponse) -> String {
        
        let description: String = """
        Rotation period: \(planet.rotationPeriod) \n
        Orbital period: \(planet.orbitalPeriod) \n
        Diameter: \(planet.diameter) \n
        Climate: \(planet.climate.capitalized) \n
        Gravity: \(planet.gravity.capitalized) \n
        Terrain: \(planet.terrain.capitalized) \n
        Surface water level: \(planet.surfaceWater.capitalized) \n
        Population: \(planet.population) \n
        """
        
        return description
        
    }

    
    var name: String
    
    var numberOfSections: Int {
        var output = 1
        if !filmURLArray.isEmpty {
            output += 1
        }
        
        return output
    }
    
    func filmName(for indexpath: Int) -> String {
        return filmURLArray[indexpath]
    }
    
    var description: String
    private var filmURLArray: [String]
    
    var films: [String] {
        return filmURLArray
    }
    
    init(planetResponse: PlanetNetworkResponse) {
        self.description = TestViewModel.planetDescriptionString(planet: planetResponse)
        self.filmURLArray = planetResponse.films
        self.name = planetResponse.name
    }
}
