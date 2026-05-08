//
//  MainCollectionViewControllerViewModelProtocol.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 23.05.2022.
//

import Foundation

protocol MainCollectionViewControllerViewModelProtocol {
    func getData() async throws -> [EntityViewModel]
}
