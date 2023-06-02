//
//  Generator.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 05.06.2022.
//

import Foundation

struct Generator {
    static func generateViewModelHelper (url: String, contentType: ContentType, responseType: NetworkResponse.Type, completion: @escaping (DetailTableViewControllerViewModel?)->Void) {
        
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
}
