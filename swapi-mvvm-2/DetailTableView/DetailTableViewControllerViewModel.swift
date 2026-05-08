//
//  TestViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 29.05.2022.
//

import Foundation

class DetailTableViewControllerViewModel {

    var contentType: ContentType

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

    private func fetchEntities(urls: [String], contentType: ContentType) async -> [EntityViewModel] {
        await withTaskGroup(of: EntityViewModel?.self) { group in
            for url in urls {
                group.addTask {
                    guard let data = try? await Networking.getData(url: url),
                          let name = JsonService.decodeJsonToName(data: data, contentType: contentType) else {
                        return nil
                    }
                    return EntityViewModel(name: name, url: url)
                }
            }
            var results = [EntityViewModel]()
            for await entity in group {
                if let entity { results.append(entity) }
            }
            return results
        }
    }

    func loadRelatedData(for response: NetworkResponse) async {
        switch contentType {
        case .Films:
            guard let filmResponse = response as? FilmNetworkResponse else { return }
            async let r = fetchEntities(urls: filmResponse.characters, contentType: .People)
            async let v = fetchEntities(urls: filmResponse.vehicles, contentType: .Vehicles)
            async let sp = fetchEntities(urls: filmResponse.species, contentType: .Species)
            async let p = fetchEntities(urls: filmResponse.planets, contentType: .Planets)
            async let st = fetchEntities(urls: filmResponse.starships, contentType: .Starships)
            residents = await r
            vehicles = await v
            species = await sp
            planets = await p
            starships = await st

        case .People:
            guard let characterResponse = response as? PersonNetworkResponse else { return }
            var homeworldURLs = [String]()
            homeworldURLs.append(characterResponse.homeworld)
            async let p = fetchEntities(urls: homeworldURLs, contentType: .Planets)
            async let sp = fetchEntities(urls: characterResponse.species ?? [], contentType: .Species)
            async let v = fetchEntities(urls: characterResponse.vehicles ?? [], contentType: .Vehicles)
            async let f = fetchEntities(urls: characterResponse.films, contentType: .Films)
            async let st = fetchEntities(urls: characterResponse.starships ?? [], contentType: .Starships)
            planets = await p
            species = await sp
            vehicles = await v
            films = await f
            starships = await st

        case .Planets:
            guard let planetResponse = response as? PlanetNetworkResponse else { return }
            async let f = fetchEntities(urls: planetResponse.films ?? [], contentType: .Films)
            async let r = fetchEntities(urls: planetResponse.residents ?? [], contentType: .People)
            films = await f
            residents = await r

        case .Species:
            guard let speciesResponse = response as? SpeciesNetworkResponse else { return }
            var homeworldURLs = [String]()
            if let hw = speciesResponse.homeworld { homeworldURLs.append(hw) }
            async let p = fetchEntities(urls: homeworldURLs, contentType: .Planets)
            async let r = fetchEntities(urls: speciesResponse.people ?? [], contentType: .People)
            async let f = fetchEntities(urls: speciesResponse.films ?? [], contentType: .Films)
            planets = await p
            residents = await r
            films = await f

        case .Starships:
            guard let starshipResponse = response as? StarshipNetworkResponse else { return }
            async let f = fetchEntities(urls: starshipResponse.films, contentType: .Films)
            async let r = fetchEntities(urls: starshipResponse.pilots, contentType: .People)
            films = await f
            residents = await r

        case .Vehicles:
            guard let vehicleResponse = response as? VehicleNetworkResponse else { return }
            async let f = fetchEntities(urls: vehicleResponse.films ?? [], contentType: .Films)
            films = await f
        }
    }
    
    //    MARK: InfoViewModel initialization from networkResponse
    
    init(response: NetworkResponse, contentType: ContentType) {
        self.contentType = contentType

        switch contentType {
        case .Films:
            guard let filmResponse = response as? FilmNetworkResponse else { return }
            self.description = DescriptionService.shared.filmDescription(film: filmResponse)
            self.titleForTableView = "\(String(localized: "Film:")) \(filmResponse.title)"

        case .People:
            guard let characterResponse = response as? PersonNetworkResponse else { return }
            self.description = DescriptionService.shared.characterDescription(character: characterResponse) ?? ""
            self.titleForTableView = "\(String(localized: "Character:")) \(characterResponse.name)"

        case .Planets:
            guard let planetResponse = response as? PlanetNetworkResponse else { return }
            self.titleForTableView = "\(String(localized: "Planet:")) \(planetResponse.name)"
            self.description = DescriptionService.shared.planetDescription(planet: planetResponse) ?? ""

        case .Species:
            guard let speciesResponse = response as? SpeciesNetworkResponse else { return }
            self.titleForTableView = "\(String(localized: "Species:")) \(speciesResponse.name)"
            self.description = DescriptionService.shared.speciesDescription(species: speciesResponse)

        case .Starships:
            guard let starshipResponse = response as? StarshipNetworkResponse else { return }
            self.titleForTableView = "\(String(localized: "Starship:")) \(starshipResponse.name)"
            self.description = DescriptionService.shared.starshipDescription(starship: starshipResponse)

        case .Vehicles:
            guard let vehicleResponse = response as? VehicleNetworkResponse else { return }
            self.titleForTableView = "\(String(localized: "Vehicle:")) \(vehicleResponse.name)"
            self.description = DescriptionService.shared.vehicleDescription(vehicle: vehicleResponse)
        }
    }
}
