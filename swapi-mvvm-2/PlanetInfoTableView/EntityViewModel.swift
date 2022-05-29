//
//  PlanetViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 28.05.2022.
//

import Foundation

struct EntityViewModel: EntityViewModelProtocol {
    
    var description: String = ""
    var type: ContentType
    var response: Any
    
    var desc: String {
        switch type {
        case .Films:
            return "0"
        case .People:
            return "0"
        case .Planets:
            return TestViewModel.planetDescriptionString(planet: response as! PlanetNetworkResponse)
        case .Species:
            return "0"
        case .Starships:
            return "0"
        case .Vehicles:
            return "0"
        }
    }
    
    
    static func createViewModel(url: String, type: ContentType, completion: @escaping (EntityViewModel)->Void) {
        Networking.getData(url: url) { result in
            switch result {
            case .failure(let error): print(error.localizedDescription)
            case .success(let data):
                print(data)
//                let resx = JsonDecoderService.decodeJsonToEntity(data: data, contentType: .Planets)
//                guard let description = resx?.description else {return}
//                completion(EntityViewModel(description: description, type: type, response: resx))
            }
        }
    }
    
}
