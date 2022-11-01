//
//  JsonDecoder.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 19.05.2022.
//

import Foundation

protocol NetworkResponse: Decodable {
    var url: String {get}
}

struct JsonService {
    
    static func decodeJsonToDictionary (data: Data) -> Dictionary<String, String>? {
        let jsonDec = JSONDecoder()
        guard let response = try? jsonDec.decode(Dictionary<String, String>.self, from: data) else {return nil}
        return response
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
            guard let response = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .Starships) as! StarshipNetworkResponse? else {
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
        
        var entitiesArray: [EntityModel] = [] {
            didSet {
//                print("entities array: \(entitiesArray.last?.name) end")
            }
        }
        
        var urlNext: String = String() {
            didSet {
//                print("urlNext changed: \(urlNext) \n end of urlNext")
//                decode(url: urlNext)
            }
        }
        
//        var provideURL: String?
        
//        func decode(url: String) {
//            guard let result = try? jsonDec.decode(PlanetsListNetworkResponse.self, from: data) else {return}
//            urlNext = result.next ?? ""
//            result.results.forEach { planet in
//                entitiesArray.append(EntityModel(name: planet.name, url: planet.url, type: .Planets))
//            }
//            print(entitiesArray)
//        }
        
        switch contentType {
            
        case .Planets:
            entitiesArray = []
            var planetsArray: [EntityModel] = [] {
                didSet {
//                    print("planetsArray: \(planetsArray.last?.name) end")
                }
            }
            guard let result = try? jsonDec.decode(PlanetsListNetworkResponse.self, from: data) else {return nil}
//            urlNext = result.next ?? ""
            result.results.forEach { planet in
                planetsArray.append(EntityModel(name: planet.name, url: planet.url, type: .Planets))
            }
            let viewModel = EntityListViewModel(contentType: .Planets, nextUrl: result.next ?? "", entityArray: planetsArray)
//            print("decodeJsonToEntityList viewmodel: \(viewModel)")
            return viewModel
        case .People:
            guard let result = try? jsonDec.decode(CharacterListNetworkResponse.self, from: data) else {return nil}
            urlNext = result.next ?? ""
            result.results.forEach { planet in
                entitiesArray.append(EntityModel(name: planet.name, url: planet.url, type: .People))
            }
            let viewModel = EntityListViewModel(contentType: .People, nextUrl: urlNext, entityArray: entitiesArray)
//            print(viewModel)
            return viewModel
        case .Starships:
            guard let result = try? jsonDec.decode(StarshipListNetworkResponse.self, from: data) else {return nil}
            urlNext = result.next ?? ""
            result.results.forEach { planet in
                entitiesArray.append(EntityModel(name: planet.name, url: planet.url, type: .Starships))
            }
            let viewModel = EntityListViewModel(contentType: .Starships, nextUrl: urlNext, entityArray: entitiesArray)
//            print(viewModel)
            return viewModel
        case .Vehicles:
            guard let result = try? jsonDec.decode(VehicleListNetworkResponse.self, from: data) else {return nil}
            urlNext = result.next ?? ""
            result.results.forEach { planet in
                entitiesArray.append(EntityModel(name: planet.name, url: planet.url, type: .Vehicles))
            }
            let viewModel = EntityListViewModel(contentType: .Vehicles, nextUrl: urlNext, entityArray: entitiesArray)
            return viewModel
        case .Films:
            guard let result = try? jsonDec.decode(FilmListNetworkResponse.self, from: data) else { print("\(FilmListNetworkResponse.self) FAIL")
                return nil}
            urlNext = result.next ?? ""
            result.results.forEach { planet in
                entitiesArray.append(EntityModel(name: planet.title, url: planet.url, type: .Films))
            }
            let viewModel = EntityListViewModel(contentType: .Films, nextUrl: urlNext, entityArray: entitiesArray)
//            print(viewModel)
            return viewModel
        case .Species:
            guard let result = try? jsonDec.decode(SpeciesListNetworkResponse.self, from: data) else {
                print("error spec")
                return nil}
            urlNext = result.next ?? ""
            result.results.forEach { planet in
                entitiesArray.append(EntityModel(name: planet.name, url: planet.url, type: .Species))
            }
            let viewModel = EntityListViewModel(contentType: .Species, nextUrl: urlNext, entityArray: entitiesArray)
//            print(viewModel)
            return viewModel
        }
    }
}
