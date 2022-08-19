//
//  TestViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 29.05.2022.
//

import Foundation
import UIKit

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
//            return contentType == .Films ? nil : "Films"
            if contentType == .Films {
                return nil
            } else if filmNames.isEmpty {
                return nil
            } else {
                return "Films"
            }
        case 2:
            switch contentType {
            case .Films:
                return "Characters"
            case .People:
                return nil
            case .Vehicles:
                return residentNames.isEmpty ? nil : "Pilots"
            case .Planets, .Species:
                return residentNames.isEmpty ? nil : "Residents"
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
            return vehicleNames.isEmpty ? nil : "Vehicles"
        case 5:
            return speciesNames.isEmpty ? nil : "Species"
        case 6:
            return starshipNames.isEmpty ? nil : "Starships"
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
        case 5:
            return self.speciesNames.count
        case 6:
            return self.starshipNames.count
        default:
            return 1
        }
    }
    
    var name: String = ""
    
    var numberOfSections: Int {
        return 7
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
    
    func speciesName(for indexpath: Int) -> String{
        return speciesNames[indexpath]
    }
    
    func starshipName(for indexpath: Int) -> String{
        return starshipNames[indexpath]
    }
    
    
    func giveDescription() -> String {
        return description
    }
    
    private var description: String = ""
    
    private var films: [EntityModel] = []
    private var residents: [EntityModel] = []
    private var planets: [EntityModel] = []
    private var vehicles: [EntityModel] = []
    private var starships: [EntityModel] = []
    private var species: [EntityModel] = []
    
    var filmURLArray: [String] = []
    var residentsURLArray: [String] = []
    var planetURLArray: [String] = []
    var vehicleURLArray: [String] = []
    var starshipsURLArray: [String] = []
    var speciesURLArray: [String] = []
    
    private var filmNames: [String] = []
    private var residentNames: [String] = []
    private var planetNames: [String] = []
    private var vehicleNames: [String] = []
    private var starshipNames: [String] = []
    private var speciesNames: [String] = []
    
    func clear() {
        self.filmURLArray.removeAll()
        self.filmNames.removeAll()
        self.residentsURLArray.removeAll()
        self.residentNames.removeAll()
        self.planetURLArray.removeAll()
        self.planetNames.removeAll()
        self.vehicleURLArray.removeAll()
        self.vehicleNames.removeAll()
        self.starshipsURLArray.removeAll()
        self.starshipNames.removeAll()
        self.speciesURLArray.removeAll()
    }
    
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
                            case .Species:
                                self.speciesNames.append(name)
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
            
            clear()
            let filmResponse = response as? FilmNetworkResponse
            let desc = DescriptionService.shared.filmDescription(film: filmResponse!)
            self.name = filmResponse?.title ?? ""
            self.description = desc
            
            self.residentsURLArray = filmResponse?.characters ?? []
            fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
            
            self.vehicleURLArray = filmResponse?.vehicles ?? []
            fillInfo(arrayOfUrls: vehicleURLArray, contentType: .Vehicles)
            
            self.speciesURLArray = filmResponse?.species ?? []
            fillInfo(arrayOfUrls: speciesURLArray, contentType: .Species)
            
            guard let planetURL = filmResponse?.planets else {return}
            self.planetURLArray.append(contentsOf: planetURL)
            fillInfo(arrayOfUrls: self.planetURLArray, contentType: .Planets)
            
            self.vehicleURLArray = filmResponse?.vehicles ?? []
            fillInfo(arrayOfUrls: vehicleURLArray, contentType: .Vehicles)
            
            
        case .People:
            self.contentType = .People
            
            clear()
            let characterResponse = response as? PersonNetworkResponse
            guard let desc = DescriptionService.shared.characterDescription(character: characterResponse!) else {return}
            self.description = desc
            self.name = characterResponse?.name ?? ""
            
            self.filmURLArray = characterResponse?.films ?? []
            fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
            
            let homeworldURL = characterResponse?.homeworld
            self.planetURLArray.append(homeworldURL ?? "")
            fillInfo(arrayOfUrls: self.planetURLArray, contentType: .Planets)
            
            self.speciesURLArray = characterResponse?.species ?? []
            fillInfo(arrayOfUrls: speciesURLArray, contentType: .Species)
            
            self.vehicleURLArray = characterResponse?.vehicles ?? []
            fillInfo(arrayOfUrls: vehicleURLArray, contentType: .Vehicles)

            self.starshipsURLArray = characterResponse?.starships ?? []
            fillInfo(arrayOfUrls: starshipsURLArray, contentType: .Starships)
            
            
        case .Planets:
            self.contentType = .Planets
            clear()
            let planetResponse = response as? PlanetNetworkResponse
            self.name = planetResponse?.name ?? "planet name"
            self.filmURLArray = planetResponse?.films ?? []
            self.residentsURLArray = planetResponse?.residents ?? []
            
            guard let desc = DescriptionService.shared.planetDescription(planet: planetResponse!) else {return}
            self.description = desc
            
            fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
            fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
        case .Species:
            self.contentType = .Species
            clear()
            let speciesResponse = response as? SpeciesNetworkResponse
            self.name = speciesResponse?.name ?? "unknown"
            let desc = DescriptionService.shared.speciesDescription(species: speciesResponse!)
            self.description = desc
            self.filmURLArray = speciesResponse?.films ?? []
            fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
            
            let homeworldURL = speciesResponse?.homeworld
            self.planetURLArray.append(homeworldURL ?? "")
            fillInfo(arrayOfUrls: self.planetURLArray, contentType: .Planets)
            
            self.residentsURLArray = speciesResponse?.people ?? []
            //            print(residentsURLArray)
            fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
            
            
        case .Starships:
            self.contentType = .Starships
            clear()
            guard let starshipResponse = response as? StarshipNetworkResponse else {return}
            self.name = starshipResponse.name
            self.description = DescriptionService.shared.starshipDescription(starship: starshipResponse)
            self.filmURLArray = starshipResponse.films
            fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
            self.residentsURLArray = starshipResponse.pilots ?? []
            fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
            
        case .Vehicles:
            self.contentType = .Vehicles
            clear()
            let vehicleResponse = response as? VehicleNetworkResponse
            self.name = vehicleResponse?.name ?? "vehicle name"
            self.filmURLArray = vehicleResponse?.films.sorted() ?? []
            self.residentsURLArray = vehicleResponse?.pilots?.sorted() ?? []
            guard let vehicle = vehicleResponse else {return}
            let desc = DescriptionService.shared.vehicleDescription(vehicle: vehicle)
            self.description = desc
            fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
            fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
        }
    }
}
