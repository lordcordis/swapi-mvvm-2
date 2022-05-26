//
//  MainCollectionViewControllerViewModelProtocol.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

import Foundation

protocol MainCollectionViewControllerViewModelProtocol {
    var buttonNames: [String] {get}
    var buttonURLs: [String] {get}
    func getData(completion: @escaping ()-> Void)
//    func createViewModel(url: String, type: ContentType, completion: @escaping (EntityListViewModelProtocol)->Void)
}
