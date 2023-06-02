//
//  GlobalValues.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 19.05.2022.
//

import Foundation

struct Keys {
    static let initalURL = "https://swapi.dev/api/"
    static let mainScreenCellIdentificator = "mainScreenCellIdentificator"
    static let listTableViewCellId = "listTableViewCellId"
    static let detailViewInfoCell = "detailViewInfoCell"
//    static let planetsRootUrl = "https://swapi.dev/api/planets/"
}

enum ContentType: String, CaseIterable, RawRepresentable {
    case Films
    case People
    case Planets
    case Species
    case Starships
    case Vehicles
    
    func intoNetworkResponseType() -> NetworkResponse.Type {
        switch self {
        case .Films: return FilmNetworkResponse.self
        case .People:
            return PersonNetworkResponse.self
        case .Planets:
            return PlanetNetworkResponse.self
        case .Species:
            return SpeciesNetworkResponse.self
        case .Starships:
            return StarshipNetworkResponse.self
        case .Vehicles:
            return VehicleNetworkResponse.self
        }
    }
    
    func convertContentIntoSectionType() {
        
    }
    
    func intoSectionType() -> DetailTableViewController.Section {
        switch self {
        case .Films:
            return DetailTableViewController.Section.Films
        case .People:
            return DetailTableViewController.Section.People
        case .Planets:
            return DetailTableViewController.Section.Planets
        case .Species:
            return DetailTableViewController.Section.Species
        case .Starships:
            return DetailTableViewController.Section.Starships
        case .Vehicles:
            return DetailTableViewController.Section.Vehicles
        }
    }
}
