//
//  EntityViewModelProtocol.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

import Foundation


protocol EntityListViewModelProtocol {
    var array: [String] {get set}
    var urlArray: [String] {get set}
    var nextUrl: String {get set}
    var contentType: ContentType {get}
    static func createViewModel(url: String, type: ContentType, completion: @escaping (EntityListViewModelProtocol) -> Void)
//    func updateViewModel(url: String, type: ContentType)
}


