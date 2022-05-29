//
//  JsonDecoder.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 19.05.2022.
//

import Foundation

protocol EntityViewModelProtocol {
    var description: String {get}
    var desc: String {get}
}

struct JsonDecoderService {
    static func decodeJsonToDictionary (data: Data) -> Dictionary<String, String>? {
        let jsonDec = JSONDecoder()
        guard let res = try? jsonDec.decode(Dictionary<String, String>.self, from: data) else {return nil}
        return res
    }
    
    static func decodeJsonToEntity(data: Data, contentType: ContentType) -> PlanetNetworkResponse? {
        let jsondec = JSONDecoder()
        switch contentType {
        case .Films:
            return nil
        case .People:
            return nil
        case .Planets:
            guard let result = try? jsondec.decode(PlanetNetworkResponse.self, from: data) else {
                print("planet nope")
                return nil}
            return result
        case .Species:
            return nil
        case .Starships:
            return nil
        case .Vehicles:
            return nil
        }
        
    }
    
    static func decodeJsonToEntityList(data: Data, contentType: ContentType) -> EntityListViewModelProtocol? {
        let jsonDec = JSONDecoder()
        var array: [String] = []
        var urlArray: [String] = []
        var urlNext = String()
        
        switch contentType {
        case .Planets:
            guard let result = try? jsonDec.decode(PlanetsListNetworkResponse.self, from: data) else {
                print("planets nope")
                return nil}
            urlNext = result.next
            result.results.forEach { planet in
                array.append(planet.name)
                urlArray.append(planet.url)
            }
            let viewModel = EntityListViewModel(contentType: .Planets, nextUrl: urlNext, array: array, urlArray: urlArray)
            print(viewModel)
            return viewModel
        case .People:
            guard let result = try? jsonDec.decode(CharacterListNetworkResponse.self, from: data) else {return nil}
            urlNext = result.next
            result.results.forEach { planet in
                array.append(planet.name)
                urlArray.append(planet.url)
            }
            let viewModel = EntityListViewModel(contentType: .People, nextUrl: urlNext, array: array, urlArray: urlArray)
            print(viewModel)
            return viewModel
        case .Starships:
            guard let result = try? jsonDec.decode(StarshipListNetworkResponse.self, from: data) else {return nil}
            urlNext = result.next
            result.results.forEach { planet in
                array.append(planet.name)
                urlArray.append(planet.url)
            }
            let viewModel = EntityListViewModel(contentType: .Starships, nextUrl: urlNext, array: array, urlArray: urlArray)
            print(viewModel)
            return viewModel
        case .Vehicles:
            guard let result = try? jsonDec.decode(VehicleListNetworkResponse.self, from: data) else {return nil}
            urlNext = result.next
            result.results.forEach { planet in
                array.append(planet.name)
                urlArray.append(planet.url)
            }
            let viewModel = EntityListViewModel(contentType: .Vehicles, nextUrl: urlNext, array: array, urlArray: urlArray)
            return viewModel
        case .Films:
            guard let result = try? jsonDec.decode(FilmListNetworkResponse.self, from: data) else { print("\(FilmListNetworkResponse.self) FAIL")
                return nil}
            urlNext = result.next ?? ""
            result.results.forEach { planet in
                array.append(planet.title)
                urlArray.append(planet.url)
            }
            let viewModel = EntityListViewModel(contentType: .Films, nextUrl: urlNext, array: array, urlArray: urlArray)
            print(viewModel)
            return viewModel
        case .Species:
            guard let result = try? jsonDec.decode(SpeciesListNetworkResponse.self, from: data) else {
                print("error spec")
                return nil}
            urlNext = result.next
            result.results.forEach { species in
                array.append(species.name)
                urlArray.append(species.url)
            }
            let viewModel = EntityListViewModel(contentType: .Species, nextUrl: urlNext, array: array, urlArray: urlArray)
            print(viewModel)
            return viewModel
        }
    }
}
