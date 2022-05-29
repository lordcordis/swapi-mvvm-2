//
//  TestViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 29.05.2022.
//

import Foundation

protocol PlanetInfoViewModelDelegate {
    func updateView()
}

class PlanetInfoViewModel {
    
    var delegate: PlanetInfoViewModelDelegate?
    
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
        if !residentsURLArray.isEmpty {
            output += 1
        }
        
        return output
    }
    
    func filmName(for indexpath: Int) -> String {
        return filmURLArray[indexpath]
    }
    
    func residentName(for indexpath: Int) -> String {
        return residentNames[indexpath]
    }
    
    var description: String
    
    private var filmURLArray: [String]
    private var residentsURLArray: [String]
    
//    private var filmNames: String
    var residentNames: [String] = []
    
    var films: [String] {
        return filmURLArray
    }
    
    var residents: [String] {
        return residentNames
    }
    
    
    init(planetResponse: PlanetNetworkResponse) {
        self.description = PlanetInfoViewModel.planetDescriptionString(planet: planetResponse)
        self.filmURLArray = planetResponse.films
        self.residentsURLArray = planetResponse.residents ?? []
        self.name = planetResponse.name
        
        for url in residentsURLArray {
            Networking.getData(url: url) { result in
                switch result {
                case .success(let data):
                    JsonDecoderService.decodeJsonToName(data: data, contentType: .People) { name in
                        if let name = name {
                            self.residentNames.append(name)
                            self.delegate?.updateView()
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
