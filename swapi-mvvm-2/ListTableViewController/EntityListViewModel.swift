//
//  CharacterViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

//import Foundation
import UIKit


struct EntityListViewModel: EntityListViewModelProtocol {
    
//    var nextUrl: String
    
    var provideURL: String?
    
    func textFor(indexPath: Int) -> String {
        return entityArray[indexPath].name
    }
    
    func loadMore(completion: @escaping (([EntityModel], String?))->Void) {
        
        var entityList: [EntityModel] = []
        
        EntityListViewModel.createEntityListViewModel(url: nextUrl, type: contentType) { result in
            let res = result.entityArray
            entityList.append(contentsOf: res)
            completion((entityList, result.nextUrl))
        }
    }
    
    
    mutating func loadAdditional(completion: @escaping (([EntityModel])?)->Void) {
        
    }
    
    func generateViewModelHelper (viewModel: EntityListViewModelProtocol, indexPath: IndexPath, contentType: ContentType, responseType: NetworkResponse.Type, completion: @escaping (InfoViewModel?)->Void) {
        
        
        let url = viewModel.entityArray[indexPath.row].url
        
        
        Networking.getData(url: url) { result in
            switch result {
            case.success(let data):
                guard let res = JsonService.decodeJsonToNetworkResponse(data: data, contentType: contentType) else {return}
                
                switch contentType {
                case .Films:
                    let viewModel = InfoViewModel.init(response: res as! FilmNetworkResponse, contentType: .Films)
                    completion(viewModel)
                case .People:
                    let viewModel = InfoViewModel.init(response: res as! PersonNetworkResponse, contentType: .People)
                    completion(viewModel)
                case .Planets:
                    let viewModel = InfoViewModel.init(response: res as! PlanetNetworkResponse, contentType: .Planets)
                    completion(viewModel)
                case .Species:
                    let viewModel = InfoViewModel.init(response: res as! SpeciesNetworkResponse, contentType: .Species)
                    completion(viewModel)
                case .Starships:
                    let viewModel = InfoViewModel.init(response: res as! StarshipNetworkResponse, contentType: .Starships)
                    completion(viewModel)
                case .Vehicles:
                    let viewModel = InfoViewModel.init(response: res as! VehicleNetworkResponse, contentType: .Vehicles)
                    completion(viewModel)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
//    MARK: - Generating detail view ViewModel from a network response
    
    func generateViewModel (indexPath: IndexPath, viewModel: EntityListViewModelProtocol, completion: @escaping (InfoViewModel?) -> Void) {
        
        switch viewModel.contentType {
            
        case .Planets:
            generateViewModelHelper(viewModel: viewModel, indexPath: indexPath, contentType: .Planets, responseType: PlanetNetworkResponse.self, completion: completion)
            
        case .Films:
            generateViewModelHelper(viewModel: viewModel, indexPath: indexPath, contentType: .Films, responseType: FilmNetworkResponse.self, completion: completion)
            
        case .People:
            generateViewModelHelper(viewModel: viewModel, indexPath: indexPath, contentType: .People, responseType: PersonNetworkResponse.self, completion: completion)
            
        case .Species:
            generateViewModelHelper(viewModel: viewModel, indexPath: indexPath, contentType: .Species, responseType: SpeciesNetworkResponse.self, completion: completion)
            
        case .Starships:
            generateViewModelHelper(viewModel: viewModel, indexPath: indexPath, contentType: .Starships, responseType: StarshipNetworkResponse.self, completion: completion)
            
        case .Vehicles:
            generateViewModelHelper(viewModel: viewModel, indexPath: indexPath, contentType: viewModel.contentType, responseType: VehicleNetworkResponse.self, completion: completion)
        }
    }
    
    
    var contentType: ContentType
    
    var nextUrl: String = "" {
        didSet{
            print("NEXT URL \(nextUrl)")
        }
    }
    var entityArray: [EntityModel] = []
    
//     MARK: -- Generating a EntityListViewModel with chosen content type
    
    static func createEntityListViewModel(url: String, type: ContentType, completion: @escaping (EntityListViewModelProtocol) -> Void) {
        Networking.getData(url: url) { result in
            switch (result, type) {
            case (.success(let data), .People):
                guard let result = JsonService.decodeJsonToEntityList(data: data, contentType: .People) else {return}
                completion(result)
            case (.success(let data), .Planets):
                guard let result = JsonService.decodeJsonToEntityList(data: data, contentType: .Planets) else {return}
                completion(result)
            case (.success(let data), .Films):
                guard let result = JsonService.decodeJsonToEntityList(data: data, contentType: .Films) else {return}
                completion(result)
            case (.success(let data), .Starships):
                guard let result = JsonService.decodeJsonToEntityList(data: data, contentType: .Starships) else {return}
                completion(result)
            case (.success(let data), .Vehicles):
                guard let result = JsonService.decodeJsonToEntityList(data: data, contentType: .Vehicles) else {return}
                completion(result)
            case (.success(let data), .Species):
                guard let result = JsonService.decodeJsonToEntityList(data: data, contentType: .Species) else {return}
                completion(result)
            case (.failure(let error), _):
                print(error.localizedDescription)
            }
        }
    }
}
