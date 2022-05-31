//
//  CharacterViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

import Foundation
import UIKit


struct EntityListViewModel: EntityListViewModelProtocol {
    
    func textFor(indexPath: Int) -> String {
        return array[indexPath]
    }
    
    func generateViewModel (indexPath: IndexPath, viewModel: EntityListViewModelProtocol, completion: @escaping (InfoViewModel?)->Void) {
        
        switch viewModel.contentType {
        case .Planets:
            let url = viewModel.urlArray[indexPath.row]
            Networking.getData(url: url) { result in
                switch result {
                case.success(let data):
                    guard let res = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .Planets) else {return}
                    let viewModel = InfoViewModel.init(response: res as! PlanetNetworkResponse, contentType: .Planets)
                    completion(viewModel)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
            
            
        case .Films:
            
            let url = viewModel.urlArray[indexPath.row]
            Networking.getData(url: url) { result in
                switch result {
                case.success(let data):
                    guard let res = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .Films) else {return}
                    let viewModel = InfoViewModel.init(response: res as! FilmNetworkResponse, contentType: .Films)
                    completion(viewModel)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            }

            
            
            
        case .People:
            
            let url = viewModel.urlArray[indexPath.row]
            Networking.getData(url: url) { result in
                switch result {
                case.success(let data):
                    guard let res = JsonService.decodeJsonToNetworkResponse(data: data, contentType: .People) else {return}
                    let viewModel = InfoViewModel.init(response: res as! PersonNetworkResponse, contentType: .People)
                    completion(viewModel)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
            
            
            
            
            
        case .Species:
            print(viewModel.contentType)
        case .Starships:
            print(viewModel.contentType)
        case .Vehicles:
            print(viewModel.contentType)
        }
        
        
    }
    
    
    var contentType: ContentType
    var nextUrl: String = ""
    var array: [String] = []
    var urlArray: [String] = []
    
//    init(url: String, type: ContentType) {
//        EntityListViewModel.createViewModel(url: url, type: type) {
//            result in
//            self.array.append(contentsOf: result.array)
//            self.urlArray.append(contentsOf: result.urlArray)
////                print(self.viewModel.array.count)
//            self.nextUrl = result.nextUrl
////                print(self.viewModel.nextUrl)
//
//
//        }
//    }
    
    static func createViewModel(url: String, type: ContentType, completion: @escaping (EntityListViewModelProtocol) -> Void) {
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
