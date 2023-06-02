//
//  JsonDecoder.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 19.05.2022.
//

import Foundation
import UIKit

struct JsonService {
    
    static func decodeJsonToDictionary (data: Data) -> Dictionary<String, String>? {
        let jsonDec = JSONDecoder()
        guard let response = try? jsonDec.decode(Dictionary<String, String>.self, from: data) else {return nil}
        return response
    }
    
    // MARK: - Json To Name
    
    static func decodeJsonToName(data: Data, contentType: ContentType, completion: @escaping (String?) -> Void) {
        guard let response = JsonService.decodeJsonToNetworkResponse(data: data, contentType: contentType) else {
            print("decodeJsonToName \(contentType.rawValue) failed")
            return completion(nil)
        }
        
        let name: String?
        switch contentType {
        case .Films:
            name = (response as? FilmNetworkResponse)?.title
        case .People:
            name = (response as? PersonNetworkResponse)?.name
        case .Planets:
            name = (response as? PlanetNetworkResponse)?.name
        case .Species:
            name = (response as? SpeciesNetworkResponse)?.name
        case .Starships:
            name = (response as? StarshipNetworkResponse)?.name
        case .Vehicles:
            name = (response as? VehicleNetworkResponse)?.name
        }
        
        completion(name)
    }
    
    
    // MARK: - Json To Network Response
    
    static func decodeJsonToNetworkResponse(data: Data, contentType: ContentType) -> NetworkResponse? {
        let jsondec = JSONDecoder()
        let responseType: NetworkResponse.Type = contentType.intoNetworkResponseType()
        guard let result = try? jsondec.decode(responseType.self, from: data) else {
            print("decodeJsonToNetworkResponse \(contentType) failed")
            return nil}
        return result
    }
    
    
//    JSON to list of entities
    
    static func decodeJsonToEntityList(data: Data, contentType: ContentType) -> EntityListViewModelProtocol? {
        let jsonDec = JSONDecoder()
        var entitiesArray: [EntityViewModel] = []
        var urlNext = String()
        
        var viewModel: EntityListViewModelProtocol? = nil
        
        switch contentType {
        case .Planets:
            if let result = try? jsonDec.decode(PlanetsListNetworkResponse.self, from: data) {
                urlNext = result.next ?? ""
                entitiesArray = result.results.map { EntityViewModel(name: $0.name, url: $0.url) }
                viewModel = EntityListViewModel(contentType: .Planets, nextUrl: urlNext, entitiesArray: entitiesArray)
            } else {
                print("\(contentType) decoding error")
            }
            
        case .People:
            if let result = try? jsonDec.decode(CharacterListNetworkResponse.self, from: data) {
                urlNext = result.next ?? ""
                entitiesArray = result.results.map { EntityViewModel(name: $0.name, url: $0.url) }
                viewModel = EntityListViewModel(contentType: .People, nextUrl: urlNext, entitiesArray: entitiesArray)
            } else {
                print("\(contentType) decoding error")
            }
            
        case .Starships:
            if let result = try? jsonDec.decode(StarshipListNetworkResponse.self, from: data) {
                urlNext = result.next ?? ""
                entitiesArray = result.results.map { EntityViewModel(name: $0.name, url: $0.url) }
                viewModel = EntityListViewModel(contentType: .Starships, nextUrl: urlNext, entitiesArray: entitiesArray)
            } else {
                print("\(contentType) decoding error")
            }
            
        case .Vehicles:
            if let result = try? jsonDec.decode(VehicleListNetworkResponse.self, from: data) {
                urlNext = result.next ?? ""
                entitiesArray = result.results.map { EntityViewModel(name: $0.name, url: $0.url) }
                viewModel = EntityListViewModel(contentType: .Vehicles, nextUrl: urlNext, entitiesArray: entitiesArray)
            } else {
                print("\(contentType) decoding error")
            }
            
        case .Films:
            if let result = try? jsonDec.decode(FilmListNetworkResponse.self, from: data) {
                urlNext = result.next ?? ""
                entitiesArray = result.results.map { EntityViewModel(name: $0.title, url: $0.url) }
                viewModel = EntityListViewModel(contentType: .Films, nextUrl: urlNext, entitiesArray: entitiesArray)
            } else {
                print("\(contentType) decoding error")
            }
            
        case .Species:
            if let result = try? jsonDec.decode(SpeciesListNetworkResponse.self, from: data) {
                urlNext = result.next ?? ""
                entitiesArray = result.results.map { EntityViewModel(name: $0.name, url: $0.url) }
                viewModel = EntityListViewModel(contentType: .Species, nextUrl: urlNext, entitiesArray: entitiesArray)
            } else {
                print("\(contentType) decoding error")
            }
        }
        return viewModel
    }
}
