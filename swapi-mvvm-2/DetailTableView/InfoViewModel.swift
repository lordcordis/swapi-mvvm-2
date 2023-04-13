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
    
    // MARK: - header for section
    
    func headerInSection(section: Int) -> String? {
        switch section {
        case 0:
            return nil
            
        case 1:
            return films.isEmpty ? nil : "Films"
            
        case 2:
            if !residents.isEmpty {
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
                    return residents.isEmpty ? nil : "Pilots"
                }
            } else {
                return nil
            }
            
        case 3:
            guard !planets.isEmpty else {return nil}
            
            switch contentType {
            case .Films:
                return "Planets"
            case .Species, .People :
                return "Homeworld"
            case .Planets, .Vehicles, .Starships:
                return nil
            }
            
        case 4:
            return vehicles.isEmpty ? nil : "Vehicles"
        case 5:
            return species.isEmpty ? nil : "Species"
        case 6:
            return starships.isEmpty ? nil : "Starships"
            
            
        default:
            return "header-in-section"
        }
    }
    
    
    
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
    
    var name: String = ""
    
    var numberOfSections: Int {
        return 7
    }
    
    func filmName(for indexpath: Int) -> String {
        return films[indexpath].name
    }
    
    func residentName(for indexpath: Int) -> String {
        return residents[indexpath].name
    }
    
    func planetName(for indexpath: Int) -> String {
        return planets[indexpath].name
    }
    
    func vehicleName(for indexpath: Int) -> String {
        return vehicles[indexpath].name
    }
    
    func speciesName(for indexpath: Int) -> String{
        return species[indexpath].name
    }
    
    func starshipName(for indexpath: Int) -> String{
        return starships[indexpath].name
    }
    
    
    func giveDescription() -> String {
        return description
    }
    
    private var description: String = ""
    
     var films = [EntityWithUrl]()
     var residents = [EntityWithUrl]()
     var planets = [EntityWithUrl]()
     var vehicles = [EntityWithUrl]()
     var starships = [EntityWithUrl]()
     var species = [EntityWithUrl]()
    
    
    //    MARK: Info Fill to viewmodel using array of urls
    
    func fillInfo(arrayOfUrls: [String], contentType: ContentType) {
        
        for url in arrayOfUrls {
            Networking.getData(url: url) { result in
                switch result {
                case .success(let data):
                    JsonService.decodeJsonToName(data: data, contentType: contentType) { name in
                        if let name = name {
                            switch contentType {
                            case .Films:
                                self.films.append(EntityWithUrl(name: name, url: url))
                            case .People:
                                self.residents.append(EntityWithUrl(name: name, url: url))
                            case .Planets:
                                self.planets.append(EntityWithUrl(name: name, url: url))
                            case .Species:
                                self.species.append(EntityWithUrl(name: name, url: url))
                            case .Starships:
                                self.starships.append(EntityWithUrl(name: name, url: url))
                            case .Vehicles:
                                self.vehicles.append(EntityWithUrl(name: name, url: url))
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
    
    //    MARK: InfoViewModel initialization from networkResponse
    
    init(response: NetworkResponse, contentType: ContentType) {
        
        switch contentType {
        case .Films:
            self.contentType = .Films
            
            let filmResponse = response as? FilmNetworkResponse
            let desc = DescriptionService.shared.filmDescription(film: filmResponse!)
            self.name = filmResponse?.title ?? ""
            self.description = desc
            

            fillInfo(arrayOfUrls: filmResponse?.characters ?? [], contentType: .People)
            fillInfo(arrayOfUrls: filmResponse?.vehicles ?? [], contentType: .Vehicles)
            fillInfo(arrayOfUrls: filmResponse?.species ?? [], contentType: .Species)
            fillInfo(arrayOfUrls: filmResponse?.planets ?? [], contentType: .Planets)
            fillInfo(arrayOfUrls: filmResponse?.vehicles ?? [], contentType: .Vehicles)
            
            
        case .People:
            self.contentType = .People
            let characterResponse = response as? PersonNetworkResponse
            guard let desc = DescriptionService.shared.characterDescription(character: characterResponse!) else {return}
            self.description = desc
            self.name = characterResponse?.name ?? ""

            
            
            guard let homeworldURL = characterResponse?.homeworld else {return}
            var array = [String]()
            array.append(homeworldURL)

            fillInfo(arrayOfUrls: array, contentType: .Planets)
            fillInfo(arrayOfUrls: characterResponse?.species ?? [], contentType: .Species)
            fillInfo(arrayOfUrls: characterResponse?.vehicles ?? [], contentType: .Vehicles)
            fillInfo(arrayOfUrls: characterResponse?.films ?? [], contentType: .Films)

            
            
        case .Planets:
            self.contentType = .Planets
            let planetResponse = response as? PlanetNetworkResponse
            
            self.name = planetResponse?.name ?? "planet name"

            guard let desc = DescriptionService.shared.planetDescription(planet: planetResponse!) else {return}
            self.description = desc
            
            fillInfo(arrayOfUrls: planetResponse?.films ?? [], contentType: .Films)
            fillInfo(arrayOfUrls: planetResponse?.residents ?? [], contentType: .People)
            
            
            
        case .Species:
            self.contentType = .Species
            let speciesResponse = response as? SpeciesNetworkResponse
            self.name = speciesResponse?.name ?? "unknown"
            let desc = DescriptionService.shared.speciesDescription(species: speciesResponse!)
            self.description = desc
            
            fillInfo(arrayOfUrls: speciesResponse?.films ?? [], contentType: .Films)
            
            
            guard let homeworldURL = speciesResponse?.homeworld else {return}
            var array = [String]()
            array.append(homeworldURL)
            
            fillInfo(arrayOfUrls: array, contentType: .Planets)
            fillInfo(arrayOfUrls: speciesResponse?.people ?? [], contentType: .People)
            
            
            
        case .Starships:
            self.contentType = .Starships
            guard let starshipResponse = response as? StarshipNetworkResponse else {return}
            self.name = starshipResponse.name
            self.description = DescriptionService.shared.starshipDescription(starship: starshipResponse)
            
            
            //            self.description = starshipResponse?.description ?? "description is empty"
            //            films
//            self.filmURLArray = starshipResponse.films
//            fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
            //            pilots
//            self.residentsURLArray = starshipResponse.pilots ?? []
//            fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
            
        case .Vehicles:
            self.contentType = .Vehicles
            let vehicleResponse = response as? VehicleNetworkResponse
            self.name = vehicleResponse?.name ?? "vehicle name"
//            self.filmURLArray = vehicleResponse?.films.sorted() ?? []
//            self.residentsURLArray = vehicleResponse?.pilots?.sorted() ?? []
            guard let vehicle = vehicleResponse else {return}
            let desc = DescriptionService.shared.vehicleDescription(vehicle: vehicle)
            self.description = desc
//            fillInfo(arrayOfUrls: filmURLArray, contentType: .Films)
//            fillInfo(arrayOfUrls: residentsURLArray, contentType: .People)
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
