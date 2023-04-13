//
//  EntityViewModelProtocol.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

import Foundation


protocol EntityListViewModelProtocol {
    func generateViewModel (indexPath: IndexPath, viewModel: EntityListViewModelProtocol, completion: @escaping (InfoViewModel?)->Void)
    var array: [String] {get set}
    func textFor(indexPath: Int) -> String
    var urlArray: [String] {get set}
    var nextUrl: String? {get set}
    var contentType: ContentType {get set}
    static func createEntityListViewModel(url: String, type: ContentType, completion: @escaping (EntityListViewModelProtocol) -> Void)
}


