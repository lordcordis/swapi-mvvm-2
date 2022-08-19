//
//  EntityViewModelProtocol.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

import Foundation


protocol EntityListViewModelProtocol {
    func generateViewModel (indexPath: IndexPath, viewModel: EntityListViewModelProtocol, completion: @escaping (InfoViewModel?)->Void)
    func textFor(indexPath: Int) -> String
    var entityArray: [EntityModel] {get set}
    var nextUrl: String {get set}
    var contentType: ContentType {get set}
    func loadMore(completion: @escaping (([EntityModel], String?))->Void)
    static func createEntityListViewModel(url: String, type: ContentType, completion: @escaping (EntityListViewModelProtocol) -> Void)
    mutating func loadAdditional(completion: @escaping (([EntityModel])?)->Void)
}


