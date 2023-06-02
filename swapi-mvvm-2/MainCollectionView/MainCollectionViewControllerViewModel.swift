//
//  ViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 19.05.2022.
//

import Foundation


class MainCollectionViewControllerViewModel: MainCollectionViewControllerViewModelProtocol {
    
    
    func getData(completion: @escaping () -> Void) {
        
    }
    
    
    
//    DEL
    func textForButton(at indexPath: Int) -> String {
        return buttonNames[indexPath]
    }

    
//    DEL
    var buttonNames: [String] = []
    
//    DEL
    var buttonURLs: [String] = []
    
    
    
    init(completion: @escaping (Result<[EntityViewModel]?, Networking.NetworkingError>?)-> Void) {
        getData(completion: completion)
    }
    
    
    
    func getData(completion: @escaping (Result<[EntityViewModel]?, Networking.NetworkingError>?)-> Void) {
        Networking.getData(url: Keys.initalURL) { [weak self] result in
            switch result {
            case .failure(.badData):
                print("SWAPI is down / Your connection is offline. Try again later.")
                completion (.failure(.badData))
                
            case.failure(.badURL):
                print("Bad URL")
                completion(.failure(.badURL))
            case .success(let data):
                guard let jsonOutput = JsonService.decodeJsonToDictionary(data: data) else {return}
                var arrayOfEntities: [EntityViewModel] = []
                for (name, path) in jsonOutput.sorted(by: <) {
                    arrayOfEntities.append(EntityViewModel(name: name, url: path))
                }
                completion(.success(arrayOfEntities))

            }
        }
    }
    
    
}


