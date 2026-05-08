//
//  TestViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 29.05.2022.
//

import Foundation

protocol InfoViewModelDelegate {
    func addItemToSnapshot(type: ContentType, item: EntityViewModel)
}

class DetailTableViewControllerViewModel {
    
    var contentType: ContentType
    
    var delegate: InfoViewModelDelegate?
    
    // MARK: - header for section
    
    func displayHeaderForSection(section: DetailTableViewController.Section) -> Bool {
        
        switch section {
        case .main:
            return false
        case .Films:
            return !films.isEmpty
        case .People:
            return !residents.isEmpty
        case .Planets:
            return !planets.isEmpty
        case .Species:
            return !species.isEmpty
        case .Starships:
            return !starships.isEmpty
        case .Vehicles:
            return !vehicles.isEmpty
        }
        
        
        
//        if section == 0 {return false}
//        else if section == 1 { return !films.isEmpty}
//        else if section == 2 { return !residents.isEmpty}
//        else if section == 3 { return !planets.isEmpty}
//        else if section == 4 { return !vehicles.isEmpty}
//        else if section == 5 { return !species.isEmpty}
//        else if section == 6 { return !starships.isEmpty}
//        else {return false}
    }
        
    func textForHeaderInSection(section: DetailTableViewController.Section) -> String? {
        
        switch section {
            
        case .main:
            return "nil"
            
        case .Films:
            if films.isEmpty {
                return nil
            } else if films.count == 1 {
                return String(localized: "Film")
            } else {
                return String(localized: "Films")
            }

        case .People:
            guard !residents.isEmpty else {return nil}

            switch contentType {
            case .Films:
                return String(localized: "Characters")
            case .People:
                return nil
            case .Vehicles:
                return String(localized: "Pilots")
            case .Planets:
                return String(localized: "Residents")
            case .Starships:
                return residents.isEmpty ? nil : String(localized: "Pilots")
            case .Species:
                return String(localized: "Representatives")
            }
        case .Planets:
            guard !planets.isEmpty else {return nil}

            switch contentType {
            case .Films:
                return String(localized: "Planets")
            case .Species, .People :
                return String(localized: "Homeworld")
            case .Planets, .Vehicles, .Starships:
                return nil
            }

        case .Species:
            return species.isEmpty ? nil : String(localized: "Species")
        case .Starships:
            return starships.isEmpty ? nil : String(localized: "Starships")
        case .Vehicles:
            return vehicles.isEmpty ? nil : String(localized: "Vehicles")
        }
        
    }
        
        
        
        
//        switch section {
//        case 0:
//            return nil
//
//        case 1:
//            return films.isEmpty ? nil : "Films"
//
//        case 2:
//            if !residents.isEmpty {
//                switch contentType {
//                case .Films:
//                    return "Characters"
//                case .People:
//                    return nil
//                case .Vehicles:
//                    return "Pilots"
//                case .Planets:
//                    return "Residents"
//                case .Starships:
//                    return residents.isEmpty ? nil : "Pilots"
//                case .Species:
//                    return "Representatives"
//                }
//            } else {
//                return nil
//            }
//
//        case 3:
//            guard !planets.isEmpty else {return nil}
//
//            switch contentType {
//            case .Films:
//                return "Planets"
//            case .Species, .People :
//                return "Homeworld"
//            case .Planets, .Vehicles, .Starships:
//                return nil
//            }
//
//        case 4:
//            return vehicles.isEmpty ? nil : "Vehicles"
//        case 5:
//            return species.isEmpty ? nil : "Species"
//        case 6:
//            return starships.isEmpty ? nil : "Starships"
//
//
//        default:
//            return "header-in-section"
//        }
    
    
    
    
    func rowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.films.count
        case 2:
            return self.residents.count
        case 3:
            return self.planets.count
        case 4:
            return self.vehicles.count
        case 5:
            return self.species.count
        case 6:
            return self.starships.count
        default:
            return 1
        }
    }
    
    var titleForTableView: String = ""
    
    var numberOfSections: Int {
        return 7
    }
    
    func nameForEntity(_ type: ContentType, for indexpath: Int) -> String {
        switch contentType {
        case .Films:
            return films[indexpath].name
        case .People:
            return residents[indexpath].name
        case .Planets:
            return planets[indexpath].name
        case .Species:
            return species[indexpath].name
        case .Starships:
            return starships[indexpath].name
        case .Vehicles:
            return vehicles[indexpath].name
        }
    }
    
    
    func isSectionEmpty(section: DetailTableViewController.Section) -> Bool {
        switch section {
        case .main:
            return true
        case .Films:
            return !films.isEmpty
        case .People:
            return !residents.isEmpty
        case .Planets:
            return !planets.isEmpty
        case .Species:
            return !species.isEmpty
        case .Starships:
            return starships.isEmpty
        case .Vehicles:
            return !vehicles.isEmpty
        }
    }
    
    
    func giveDescription() -> String {
        return description
    }
    
    private var description: String = ""
    
     var films = [EntityViewModel]()
     var residents = [EntityViewModel]()
     var planets = [EntityViewModel]()
     var vehicles = [EntityViewModel]()
     var starships = [EntityViewModel]()
     var species = [EntityViewModel]()

    private let loadGroup = DispatchGroup()

    func onLoaded(completion: @escaping () -> Void) {
        loadGroup.notify(queue: .main, execute: completion)
    }

    func fillInfo(arrayOfUrls: [String], contentType: ContentType) {
        for url in arrayOfUrls {
            loadGroup.enter()
            Networking.getData(url: url) { result in
                defer { self.loadGroup.leave() }
                switch result {
                case .success(let data):
                    JsonService.decodeJsonToName(data: data, contentType: contentType) { name in
                        if let name = name {
                            let entity = EntityViewModel(name: name, url: url)
                            switch contentType {
                            case .Films:
                                self.films.append(entity)
                            case .People:
                                self.residents.append(entity)
                            case .Planets:
                                self.planets.append(entity)
                            case .Species:
                                self.species.append(entity)
                            case .Starships:
                                self.starships.append(entity)
                            case .Vehicles:
                                self.vehicles.append(entity)
                            }
                            self.delegate?.addItemToSnapshot(type: contentType, item: entity)
                        }
                    }
                case .failure:
                    break
                }
            }
        }
    }
    
    //    MARK: InfoViewModel initialization from networkResponse
    
    init(response: NetworkResponse, contentType: ContentType) {
        
        switch contentType {
        case .Films:
            self.contentType = .Films
            
            let filmResponse = response as? FilmNetworkResponse
            self.description = DescriptionService.shared.filmDescription(film: filmResponse!)
            self.titleForTableView = "\(String(localized: "Film:")) \(filmResponse?.title ?? "")"
            

            fillInfo(arrayOfUrls: filmResponse?.characters ?? [], contentType: .People)
            fillInfo(arrayOfUrls: filmResponse?.vehicles ?? [], contentType: .Vehicles)
            fillInfo(arrayOfUrls: filmResponse?.species ?? [], contentType: .Species)
            fillInfo(arrayOfUrls: filmResponse?.planets ?? [], contentType: .Planets)
            fillInfo(arrayOfUrls: filmResponse?.vehicles ?? [], contentType: .Starships)
            
            
        case .People:
            self.contentType = .People
            let characterResponse = response as? PersonNetworkResponse
            self.description = DescriptionService.shared.characterDescription(character: characterResponse!) ?? ""
            self.titleForTableView = "\(String(localized: "Character:")) \(characterResponse?.name ?? "")"
            guard let homeworldURL = characterResponse?.homeworld else {return}
            var array = [String]()
            array.append(homeworldURL)

            fillInfo(arrayOfUrls: array, contentType: .Planets)
            fillInfo(arrayOfUrls: characterResponse?.species ?? [], contentType: .Species)
            fillInfo(arrayOfUrls: characterResponse?.vehicles ?? [], contentType: .Vehicles)
            fillInfo(arrayOfUrls: characterResponse?.films ?? [], contentType: .Films)
            fillInfo(arrayOfUrls: characterResponse?.starships ?? [], contentType: .Starships)

            
            
        case .Planets:
            self.contentType = .Planets
            let planetResponse = response as? PlanetNetworkResponse
            self.titleForTableView = "\(String(localized: "Planet:")) \(planetResponse?.name ?? "")"
            guard let desc = DescriptionService.shared.planetDescription(planet: planetResponse!) else {return}
            self.description = desc
            
            fillInfo(arrayOfUrls: planetResponse?.films ?? [], contentType: .Films)
            fillInfo(arrayOfUrls: planetResponse?.residents ?? [], contentType: .People)
            
            
        case .Species:
            self.contentType = .Species
            let speciesResponse = response as? SpeciesNetworkResponse
            self.titleForTableView = "\(String(localized: "Species:")) \(speciesResponse?.name ?? "")"
            let desc = DescriptionService.shared.speciesDescription(species: speciesResponse!)
            self.description = desc
        
            guard let homeworldURL = speciesResponse?.homeworld else {return}
            var array = [String]()
            array.append(homeworldURL)
            
            fillInfo(arrayOfUrls: array, contentType: .Planets)
            fillInfo(arrayOfUrls: speciesResponse?.people ?? [], contentType: .People)
            fillInfo(arrayOfUrls: speciesResponse?.films ?? [], contentType: .Films)
            
            
        case .Starships:
            self.contentType = .Starships
            guard let starshipResponse = response as? StarshipNetworkResponse else {return}
            self.titleForTableView = "\(String(localized: "Starship:")) \(starshipResponse.name)"
            self.description = DescriptionService.shared.starshipDescription(starship: starshipResponse)
            fillInfo(arrayOfUrls: starshipResponse.films, contentType: .Films)
            fillInfo(arrayOfUrls: starshipResponse.pilots, contentType: .People)
            
        case .Vehicles:
            self.contentType = .Vehicles
            let vehicleResponse = response as? VehicleNetworkResponse
            self.titleForTableView = "\(String(localized: "Vehicle:")) \(vehicleResponse?.name ?? "")"
            guard let vehicle = vehicleResponse else {return}
            let desc = DescriptionService.shared.vehicleDescription(vehicle: vehicle)
            self.description = desc
            fillInfo(arrayOfUrls: vehicleResponse?.films ?? [], contentType: .Films)
        }
    }
}
