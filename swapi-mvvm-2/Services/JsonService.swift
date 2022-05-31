//
//  JsonDecoder.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 19.05.2022.
//

import Foundation

//protocol EntityViewModelProtocol {
//    var description: String {get}
//    var desc: String {get}
//}

protocol NetworkResponse {
    var url: String {get}
}

struct JsonService {
    
    static func decodeJsonToDictionary (data: Data) -> Dictionary<String, String>? {
        let jsonDec = JSONDecoder()
        guard let res = try? jsonDec.decode(Dictionary<String, String>.self, from: data) else {return nil}
        return res
    }
    
    // MARK: - Json To Name
    
    static func decodeJsonToName(data: Data, contentType: ContentType, completion: @escaping (String?)->()) {
        switch contentType {
        case .Films:
            guard let response = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .Films) as! FilmNetworkResponse? else {print("JsonDecoderService film fucked")
                return completion(nil)}
            completion(response.title)
        case .People:
            guard let response = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .People) as! PersonNetworkResponse? else {
                print("decodeJsonToName .people failed")
                return completion(nil)}
            completion(response.name)
        case .Planets:
            guard let response = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .Planets) as! PlanetNetworkResponse? else {
                print("decodeJsonToName .planet failed")
                return completion(nil)}
            completion(response.name)
        case .Species:
            guard let response = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .Species) as! SpeciesNetworkResponse? else {
                print("decodeJsonToName \(contentType.rawValue) failed")
                return completion(nil)}
            completion(response.name)
        case .Starships:
            guard let response = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .Planets) as! StarshipNetworkResponse? else {
                print("decodeJsonToName \(contentType.rawValue) failed")
                return completion(nil)}
            completion(response.name)
        case .Vehicles:
            guard let response = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .Vehicles) as! VehicleNetworkResponse? else {
                print("decodeJsonToName \(contentType.rawValue) failed")
                return completion(nil)}
            completion(response.name)
        }
    }
    
    // MARK: - Json To Network Response
    
    static func decodeJsonToNetworkResponse(data: Data, contentType: ContentType) -> NetworkResponse? {
        let jsondec = JSONDecoder()
        switch contentType {
        case .Films:
            guard let result = try? jsondec.decode(FilmNetworkResponse.self, from: data) else {
                print("decodeJsonToEntity .film failed")
                return nil}
            return result
        case .People:
            guard let result = try? jsondec.decode(PersonNetworkResponse.self, from: data) else {
                print("decodeJsonToEntity .person failed")
                return nil}
            return result
        case .Planets:
            guard let result = try? jsondec.decode(PlanetNetworkResponse.self, from: data) else {
                print("decodeJsonToEntity .planet failed")
                return nil}
            return result
        case .Species:
            guard let result = try? jsondec.decode(SpeciesNetworkResponse.self, from: data) else {
                print("decodeJsonToEntity .species failed")
                return nil}
            return result
        case .Starships:
            guard let result = try? jsondec.decode(StarshipNetworkResponse.self, from: data) else {
                print("decodeJsonToEntity .starship failed")
                return nil}
            return result
        case .Vehicles:
            guard let result = try? jsondec.decode(VehicleNetworkResponse.self, from: data) else {
                print("decodeJsonToEntity .vehicle failed")
                return nil}
            return result
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
