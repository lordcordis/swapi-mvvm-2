//
//  EntityViewModelProtocol.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

import Foundation
import UIKit


protocol EntityListViewModelProtocol {
    func generateViewModel (indexPath: IndexPath, viewModel: EntityListViewModelProtocol, completion: @escaping (DetailTableViewControllerViewModel?)->Void)
    func generateViewModelHelperDiff (entity: EntityViewModel, viewModel: EntityListViewModelProtocol, completion: @escaping (DetailTableViewControllerViewModel?)->Void)
    func textFor(indexPath: Int) -> String
    var entitiesArray: [EntityViewModel] {get set}
    var nextUrl: String? {get set}
    var contentType: ContentType {get set}
    static func createEntityListViewModel(url: String, type: ContentType, completion: @escaping (EntityListViewModelProtocol) -> Void)
}


