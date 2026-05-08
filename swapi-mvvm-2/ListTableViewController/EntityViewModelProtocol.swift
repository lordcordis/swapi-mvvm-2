//
//  EntityViewModelProtocol.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

import Foundation
import UIKit


protocol EntityListViewModelProtocol {
    func generateViewModelHelperDiff(entity: EntityViewModel, viewModel: EntityListViewModelProtocol) async -> DetailTableViewControllerViewModel?
    func textFor(indexPath: Int) -> String
    var entitiesArray: [EntityViewModel] { get set }
    var nextUrl: String? { get set }
    var contentType: ContentType { get set }
    static func createEntityListViewModel(url: String, type: ContentType) async -> EntityListViewModelProtocol?
}


