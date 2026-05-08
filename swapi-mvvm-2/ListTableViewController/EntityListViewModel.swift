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

    func generateViewModelHelperDiff(entity: EntityViewModel, viewModel: EntityListViewModelProtocol) async -> DetailTableViewControllerViewModel? {
        await Generator.generateViewModelHelper(url: entity.url, contentType: viewModel.contentType)
    }

    static func createEntityListViewModel(url: String, type: ContentType) async -> EntityListViewModelProtocol? {
        guard let data = try? await Networking.getData(url: url) else { return nil }
        return JsonService.decodeJsonToEntityList(data: data, contentType: type)
    }
}
