//
//  CharacterViewModel.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

//import Foundation
import UIKit


struct EntityListViewModel: EntityListViewModelProtocol {

    var contentType: ContentType
    var nextUrl: String?
    var entitiesArray: [EntityViewModel] = []

    func textFor(indexPath: Int) -> String {
        return entitiesArray[indexPath].name
    }

    func generateViewModel(indexPath: IndexPath, viewModel: EntityListViewModelProtocol, completion: @escaping (DetailTableViewControllerViewModel?) -> Void) {
        let url = viewModel.entitiesArray[indexPath.row].url
        Generator.generateViewModelHelper(url: url, contentType: viewModel.contentType, completion: completion)
    }

    func generateViewModelHelperDiff(entity: EntityViewModel, viewModel: EntityListViewModelProtocol, completion: @escaping (DetailTableViewControllerViewModel?) -> Void) {
        Generator.generateViewModelHelper(url: entity.url, contentType: viewModel.contentType, completion: completion)
    }

    static func createEntityListViewModel(url: String, type: ContentType, completion: @escaping (EntityListViewModelProtocol) -> Void) {
        Networking.getData(url: url) { result in
            switch result {
            case .success(let data):
                guard let result = JsonService.decodeJsonToEntityList(data: data, contentType: type) else { return }
                completion(result)
            case .failure:
                break
            }
        }
    }
}
