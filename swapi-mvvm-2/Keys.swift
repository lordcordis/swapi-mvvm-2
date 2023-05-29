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
    
    static func convertContentTypeIntoSectionType (type: ContentType) -> DetailTableViewControllerDiff.Section {
        switch type {
        case .Films:
            return DetailTableViewControllerDiff.Section.Films
        case .People:
            return DetailTableViewControllerDiff.Section.People
        case .Planets:
            return DetailTableViewControllerDiff.Section.Planets
        case .Species:
            return DetailTableViewControllerDiff.Section.Species
        case .Starships:
            return DetailTableViewControllerDiff.Section.Starships
        case .Vehicles:
            return DetailTableViewControllerDiff.Section.Vehicles
        }
    }
    
    static func convertContentTypeIntoNetworkResponseType(for type: ContentType) -> NetworkResponse.Type {
        switch type {
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
}
