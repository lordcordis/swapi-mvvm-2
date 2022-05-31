//
//  TestViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 29.05.2022.
//

import Foundation

protocol InfoViewModelDelegate {
    func updateView()
}

class InfoViewModel {
    
    var contentType: ContentType
    
    var delegate: InfoViewModelDelegate?
    
    func headerInSection(section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "Films"
        case 2:
            return "Residents"
        default:
            return "no"
        }
    }
    
    func rowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.filmNames.count
        case 2:
            return self.residentNames.count
        default:
            return 1
        }
    }
    
    static func planetDescriptionString (planet: PlanetNetworkResponse) -> String? {
        
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

    
    var name: String = ""
    
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
        return filmNames[indexpath]
    }
    
    func residentName(for indexpath: Int) -> String {
        return residentNames[indexpath]
    }
    
    func giveDescription() -> String {
        return description
    }
    
    private var description: String = ""

    private var filmURLArray: [String] = []
    private var residentsURLArray: [String] = []
    
    private var filmNames: [String] = []
    private var residentNames: [String] = []
    
//    var films: [String] {
//        return filmURLArray
//    }
    
//    var residents: [String] {
//        return residentNames
//    }
    
    func fillInfo(arrayOfUrls: [String], contentType: ContentType) {
        for url in arrayOfUrls {
            Networking.getData(url: url) { result in
                switch result {
                case .success(let data):
                    JsonDecoderService.decodeJsonToName(data: data, contentType: contentType) { name in
                        if let name = name {
                            switch contentType {
                            case .Films:
                                self.filmNames.append(name)
                            case .People:
                                self.residentNames.append(name)
                            case .Planets:
                                return
                            case .Species:
                                return
                            case .Starships:
                                return
                            case .Vehicles:
                                return
                            }
                            self.delegate?.updateView()
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    init(response: NetworkResponse, contentType: ContentType) {
        
        switch contentType {
        case .Films:
            self.contentType = .Films
        case .People:
            self.contentType = .People
        case .Planets:
            let planetResponse = response as? PlanetNetworkResponse
            self.contentType = .Planets
            self.name = planetResponse?.name ?? "planet name"
            self.filmURLArray = planetResponse?.films ?? []
            self.residentsURLArray = planetResponse?.residents ?? []

            guard let desc = InfoViewModel.planetDescriptionString(planet: planetResponse!) else {return}
            self.description = desc
            
            fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
            fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
        case .Species:
            self.contentType = .Species
        case .Starships:
            self.contentType = .Starships
        case .Vehicles:
            self.contentType = .Vehicles
        }
        
        
        

        

        
    }
    
    
//    init(planetResponse: PlanetNetworkResponse, contentType: ContentType) {
//        self.contentType = contentType
//        self.description = InfoViewModel.planetDescriptionString(planet: planetResponse)
//        self.filmURLArray = planetResponse.films
//        self.residentsURLArray = planetResponse.residents ?? []
//        self.name = planetResponse.name
//
//
//        fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
//        fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
//    }
}
