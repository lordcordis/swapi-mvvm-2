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
//    static let planetsRootUrl = "https://swapi.dev/api/planets/"
}

enum ContentType: String, CaseIterable {
    case Films
    case People
    case Planets
    case Species
    case Starships
    case Vehicles
}
