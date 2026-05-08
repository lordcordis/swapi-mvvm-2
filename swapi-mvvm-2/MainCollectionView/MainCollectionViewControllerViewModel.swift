//
//  ViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 19.05.2022.
//

import Foundation

class MainCollectionViewControllerViewModel: MainCollectionViewControllerViewModelProtocol {

    func getData() async throws -> [EntityViewModel] {
        let data = try await Networking.getData(url: Keys.initalURL)
        guard let jsonOutput = JsonService.decodeJsonToDictionary(data: data) else {
            throw Networking.NetworkingError.badData
        }
        return jsonOutput.sorted(by: <).map { EntityViewModel(name: $0.key, url: $0.value) }
    }
}
