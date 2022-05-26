//
//  ViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 19.05.2022.
//

import Foundation


class MainCollectionViewControllerViewModel: MainCollectionViewControllerViewModelProtocol {
    
    
    func textForButton(at indexPath: Int) -> String {
        return buttonNames[indexPath]
    }
    
    
    var buttonNames: [String] = []
    
    var buttonURLs: [String] = []
    
    init(completion: @escaping ()->Void) {
        getData(completion: completion)
    }
    
    func getData(completion: @escaping ()-> Void) {
        Networking.getData(url: Keys.initalURL) { [weak self] result in
            switch result {
            case .failure(.badData):
                print("SWAPI is down / Your connection is offline. Try again later.")
            case.failure(.badURL):
                print("Bad URL")
            case .success(let data):
                guard let jsonOutput = JsonDecoderService.decodeJsonToDictionary(data: data) else {return}
                for (name, path) in jsonOutput.sorted(by: <) {
                    self?.buttonNames.append(name.capitalized)
                    self?.buttonURLs.append(path)
                }
                completion()
            }
        }
    }
    
    
}


