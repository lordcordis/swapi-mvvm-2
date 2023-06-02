//
//  CharacterViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

//import Foundation
import UIKit


struct EntityListViewModel: EntityListViewModelProtocol {
    
//    var dataSource: UITableViewDiffableDataSource<Section, EntityViewModel>
    
    
    var contentType: ContentType
    var nextUrl: String?
    
    var entitiesArray: [EntityViewModel] = []

    
//    var dataSource: UITableViewDiffableDataSource<Section, EntityViewModel>! = nil
    
//    func arrayLength() -> Int {
//        return entitiesArray.count
//    }
    
    func textFor(indexPath: Int) -> String {
        return entitiesArray[indexPath].name
    }
    
    func generateViewModelDiff (viewModel: EntityListViewModelProtocol, entity: EntityViewModel, contentType: ContentType, responseType: NetworkResponse.Type, completion: @escaping (DetailTableViewControllerViewModel?)->Void) {

        let url = entity.url
                
                Networking.getData(url: url) { result in
                    switch result {
                    case.success(let data):
                        guard let res = JsonService.decodeJsonToNetworkResponse(data: data, contentType: contentType) else {return}
                        
                        switch contentType {
                        case .Films:
                            let viewModel = DetailTableViewControllerViewModel.init(response: res as! FilmNetworkResponse, contentType: .Films)
                            completion(viewModel)
                        case .People:
                            let viewModel = DetailTableViewControllerViewModel.init(response: res as! PersonNetworkResponse, contentType: .People)
                            completion(viewModel)
                        case .Planets:
                            let viewModel = DetailTableViewControllerViewModel.init(response: res as! PlanetNetworkResponse, contentType: .Planets)
                            completion(viewModel)
                        case .Species:
                            let viewModel = DetailTableViewControllerViewModel.init(response: res as! SpeciesNetworkResponse, contentType: .Species)
                            completion(viewModel)
                        case .Starships:
                            let viewModel = DetailTableViewControllerViewModel.init(response: res as! StarshipNetworkResponse, contentType: .Starships)
                            completion(viewModel)
                        case .Vehicles:
                            let viewModel = DetailTableViewControllerViewModel.init(response: res as! VehicleNetworkResponse, contentType: .Vehicles)
                            completion(viewModel)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(nil)
                    }
                }
            }
    
    
    
    func generateViewModelHelper (viewModel: EntityListViewModelProtocol, indexPath: IndexPath, contentType: ContentType, responseType: NetworkResponse.Type, completion: @escaping (DetailTableViewControllerViewModel?)->Void) {
        
        
//        let url = viewModel.urlArray[indexPath.row]
        let url = viewModel.entitiesArray[indexPath.row].url
        
        
        Networking.getData(url: url) { result in
            switch result {
            case.success(let data):
                guard let res = JsonService.decodeJsonToNetworkResponse(data: data, contentType: contentType) else {return}
                
                switch contentType {
                case .Films:
                    let viewModel = DetailTableViewControllerViewModel.init(response: res as! FilmNetworkResponse, contentType: .Films)
                    completion(viewModel)
                case .People:
                    let viewModel = DetailTableViewControllerViewModel.init(response: res as! PersonNetworkResponse, contentType: .People)
                    completion(viewModel)
                case .Planets:
                    let viewModel = DetailTableViewControllerViewModel.init(response: res as! PlanetNetworkResponse, contentType: .Planets)
                    completion(viewModel)
                case .Species:
                    let viewModel = DetailTableViewControllerViewModel.init(response: res as! SpeciesNetworkResponse, contentType: .Species)
                    completion(viewModel)
                case .Starships:
                    let viewModel = DetailTableViewControllerViewModel.init(response: res as! StarshipNetworkResponse, contentType: .Starships)
                    completion(viewModel)
                case .Vehicles:
                    let viewModel = DetailTableViewControllerViewModel.init(response: res as! VehicleNetworkResponse, contentType: .Vehicles)
                    completion(viewModel)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    func generateViewModel (indexPath: IndexPath, viewModel: EntityListViewModelProtocol, completion: @escaping (DetailTableViewControllerViewModel?)->Void) {

        generateViewModelHelper(viewModel: viewModel, indexPath: indexPath, contentType: viewModel.contentType, responseType: viewModel.contentType.intoNetworkResponseType(), completion: completion)
        
    }
    
    func generateViewModelHelperDiff (entity: EntityViewModel, viewModel: EntityListViewModelProtocol, completion: @escaping (DetailTableViewControllerViewModel?)->Void) {

        generateViewModelDiff(viewModel: viewModel, entity: entity, contentType: viewModel.contentType, responseType: contentType.intoNetworkResponseType(), completion: completion)
        
    }
    
    
//    Creating view model for list table view using ContentType and URL
    
    static func createEntityListViewModel(url: String, type: ContentType, completion: @escaping (EntityListViewModelProtocol) -> Void) {
        Networking.getData(url: url) { result in
            switch result {


            case .success(let data):
                guard let result = JsonService.decodeJsonToEntityList(data: data, contentType: type) else {return}
                completion(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
