//
//  Generator.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 05.06.2022.
//

import Foundation

struct Generator {
    static func generateViewModelHelper(url: String, contentType: ContentType, completion: @escaping (DetailTableViewControllerViewModel?) -> Void) {
        Networking.getData(url: url) { result in
            switch result {
            case .success(let data):
                guard let res = JsonService.decodeJsonToNetworkResponse(data: data, contentType: contentType) else {
                    completion(nil)
                    return
                }

                let viewModel: DetailTableViewControllerViewModel?
                switch contentType {
                case .Films:
                    viewModel = (res as? FilmNetworkResponse).map { DetailTableViewControllerViewModel(response: $0, contentType: .Films) }
                case .People:
                    viewModel = (res as? PersonNetworkResponse).map { DetailTableViewControllerViewModel(response: $0, contentType: .People) }
                case .Planets:
                    viewModel = (res as? PlanetNetworkResponse).map { DetailTableViewControllerViewModel(response: $0, contentType: .Planets) }
                case .Species:
                    viewModel = (res as? SpeciesNetworkResponse).map { DetailTableViewControllerViewModel(response: $0, contentType: .Species) }
                case .Starships:
                    viewModel = (res as? StarshipNetworkResponse).map { DetailTableViewControllerViewModel(response: $0, contentType: .Starships) }
                case .Vehicles:
                    viewModel = (res as? VehicleNetworkResponse).map { DetailTableViewControllerViewModel(response: $0, contentType: .Vehicles) }
                }
                if let viewModel {
                    viewModel.onLoaded { completion(viewModel) }
                } else {
                    completion(nil)
                }

            case .failure:
                completion(nil)
            }
        }
    }
}
