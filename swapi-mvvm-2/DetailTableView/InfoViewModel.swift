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
            return contentType == .Films ? nil : "Films"
        case 2:
//            return contentType == .People ? nil : "Residents"
            switch contentType {
            case .Films:
                return "Characters"
            case .People:
                return nil
            case .Vehicles:
                return "Pilots"
            case .Planets, .Species:
                return "Residents"
            case .Starships:
                return residentNames.isEmpty ? nil : "Pilots"
            }
        case 3:
            switch contentType {
            case .Films:
                return "Planets"
            case .Species, .People :
                return "Homeworld"
            case .Planets, .Vehicles, .Starships:
                return nil
            }
        case 4:
//            return "Vehicles"
            return vehicleNames.isEmpty ? nil : "Vehicles"
            
            
        default:
            return "header-in-section"
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
        case 3:
            return self.planetNames.count
        case 4:
            return self.vehicleNames.count
        default:
            return 1
        }
    }
    
    //    MARK: Character description string generation
    
    static func characterDescription (character: PersonNetworkResponse) -> String? {
        
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
    
    //    MARK: Planet description string generation
    
    static func planetDescription (planet: PlanetNetworkResponse) -> String? {
        
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
        return 5
    }
    
    func filmName(for indexpath: Int) -> String {
        return filmNames[indexpath]
    }
    
    func residentName(for indexpath: Int) -> String {
        return residentNames[indexpath]
    }
    
    func planetName(for indexpath: Int) -> String {
        return planetNames[indexpath]
    }
    
    func vehicleName(for indexpath: Int) -> String {
        return vehicleNames[indexpath]
    }
    
    
    func giveDescription() -> String {
        return description
    }
    
    private var description: String = ""
    
    private var filmURLArray: [String] = []
    private var residentsURLArray: [String] = []
    private var planetURLArray: [String] = []
    private var vehicleURLArray: [String] = []
    private var starshipsURLArray: [String] = []
    
    private var filmNames: [String] = []
    private var residentNames: [String] = []
    private var planetNames: [String] = []
    private var vehicleNames: [String] = []
    private var starshipNames: [String] = []
    
    //    MARK: Info Fill
    
    func fillInfo(arrayOfUrls: [String], contentType: ContentType) {
        for url in arrayOfUrls {
            Networking.getData(url: url) { result in
                switch result {
                case .success(let data):
                    JsonService.decodeJsonToName(data: data, contentType: contentType) { name in
                        if let name = name {
                            switch contentType {
                            case .Films:
                                self.filmNames.append(name)
                            case .People:
                                self.residentNames.append(name)
                            case .Planets:
                                self.planetNames.append(name)
//                                print(self.planetNames)
                            case .Species:
                                return
                            case .Starships:
                                self.starshipNames.append(name)
                            case .Vehicles:
                                self.vehicleNames.append(name)
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
    
    //    MARK: InfoViewModel initialization
    
    init(response: NetworkResponse, contentType: ContentType) {
        
        switch contentType {
        case .Films:
            self.contentType = .Films
            
            let filmResponse = response as? FilmNetworkResponse
            let desc = filmDescription(film: filmResponse!)
            self.name = filmResponse?.title ?? ""
            self.description = desc
            
            //
            self.residentsURLArray = filmResponse?.characters ?? []
            print(residentsURLArray)
            fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
//            print(residentNames)
            
            self.vehicleURLArray = filmResponse?.vehicles ?? []
            print(vehicleURLArray)
            fillInfo(arrayOfUrls: vehicleURLArray, contentType: .Vehicles)
            print(vehicleNames)
            
            guard let planetURL = filmResponse?.planets else {return}
            self.planetURLArray.append(contentsOf: planetURL)
            fillInfo(arrayOfUrls: self.planetURLArray, contentType: .Planets)
            
            
        case .People:
            self.contentType = .People
            let characterResponse = response as? PersonNetworkResponse
            guard let desc = InfoViewModel.characterDescription(character: characterResponse!) else {return}
            self.description = desc
            self.name = characterResponse?.name ?? ""
            self.filmURLArray = characterResponse?.films ?? []

            fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
            let homeworldURL = characterResponse?.homeworld
            self.planetURLArray.append(homeworldURL ?? "")
                fillInfo(arrayOfUrls: self.planetURLArray, contentType: .Planets)
            print(self.planetNames)
            
            self.vehicleURLArray = characterResponse?.vehicles ?? []
            print(vehicleURLArray)
            fillInfo(arrayOfUrls: vehicleURLArray, contentType: .Vehicles)
            print(vehicleNames)
            
            
        case .Planets:
            self.contentType = .Planets
            let planetResponse = response as? PlanetNetworkResponse
            
            self.name = planetResponse?.name ?? "planet name"
            self.filmURLArray = planetResponse?.films ?? []
            self.residentsURLArray = planetResponse?.residents ?? []
            
            guard let desc = InfoViewModel.planetDescription(planet: planetResponse!) else {return}
            self.description = desc
            
            fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
            fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
        case .Species:
            self.contentType = .Species
        case .Starships:
            self.contentType = .Starships
            let starshipResponse = response as? StarshipNetworkResponse
            self.name = starshipResponse?.name ?? "starship name"
            self.description = starshipResponse?.description ?? "description is empty"
//            films
            self.filmURLArray = starshipResponse?.films ?? []
            fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
//            pilots
            self.residentsURLArray = starshipResponse?.pilots ?? []
            fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
            
        case .Vehicles:
            self.contentType = .Vehicles
            
            let vehicleResponse = response as? VehicleNetworkResponse
            
            self.name = vehicleResponse?.name ?? "vehicle name"
            self.filmURLArray = vehicleResponse?.films ?? []
            self.residentsURLArray = vehicleResponse?.pilots ?? []
            
            guard let desc = vehicleResponse?.descriptionString
            else {return}
            self.description = desc
            
            fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
            fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
            
            
            
            
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
