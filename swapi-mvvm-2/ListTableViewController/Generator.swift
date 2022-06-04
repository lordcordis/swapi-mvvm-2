//
//  Generator.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 05.06.2022.
//

import Foundation
struct Generator {
    static func generateViewModelHelper (url: String, contentType: ContentType, responseType: NetworkResponse.Type, completion: @escaping (InfoViewModel?)->Void) {
        
        
//        let url = viewModel.urlArray[indexPath.row]
    
    
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

//    func generateViewModel (url: String, viewModel: EntityListViewModelProtocol, completion: @escaping (InfoViewModel?)->Void) {
//    
//    switch viewModel.contentType {
//    case .Planets:
//        generateViewModelHelper(url: url, contentType: .Planets, responseType: PlanetNetworkResponse.self, completion: completion)
//    case .Films:
//        
//        generateViewModelHelper(viewModel: viewModel, indexPath: indexPath, contentType: .Films, responseType: FilmNetworkResponse.self, completion: completion)
//        
////            let url = viewModel.urlArray[indexPath.row]
////            Networking.getData(url: url) { result in
////                switch result {
////                case.success(let data):
////                    guard let res = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .Films) else {return}
////                    let viewModel = InfoViewModel.init(response: res as! FilmNetworkResponse, contentType: .Films)
////                    completion(viewModel)
////                case .failure(let error):
////                    print(error.localizedDescription)
////                    completion(nil)
////                }
////            }
//        
//        
//        
//        
//    case .People:
//        
////            let url = viewModel.urlArray[indexPath.row]
////            Networking.getData(url: url) { result in
////                switch result {
////                case.success(let data):
////                    guard let res = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .People) else {return}
////                    let viewModel = InfoViewModel.init(response: res as! PersonNetworkResponse, contentType: .People)
////                    completion(viewModel)
////                case .failure(let error):
////                    print(error.localizedDescription)
////                    completion(nil)
////                }
////            }
//        
//        generateViewModelHelper(viewModel: viewModel, indexPath: indexPath, contentType: .People, responseType: PersonNetworkResponse.self, completion: completion)
//    case .Species:
//        generateViewModelHelper(viewModel: viewModel, indexPath: indexPath, contentType: .Species, responseType: SpeciesNetworkResponse.self, completion: completion)
//    case .Starships:
//        generateViewModelHelper(viewModel: viewModel, indexPath: indexPath, contentType: .Starships, responseType: StarshipNetworkResponse.self, completion: completion)
//    case .Vehicles:
//        generateViewModelHelper(viewModel: viewModel, indexPath: indexPath, contentType: viewModel.contentType, responseType: VehicleNetworkResponse.self, completion: completion)
//        
////
////
////            let url = viewModel.urlArray[indexPath.row]
////            Networking.getData(url: url) { result in
////                switch result {
////                case.success(let data):
////                    guard let res = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .Vehicles) else {return}
////                    let viewModel = InfoViewModel.init(response: res as! VehicleNetworkResponse, contentType: .Vehicles)
////                    completion(viewModel)
////                case .failure(let error):
////                    print(error.localizedDescription)
////                    completion(nil)
////                }
////            }
////
//        
//        
//        
//        
//        
//        
//    }
//    
//    
//}
}
