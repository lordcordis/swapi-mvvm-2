//
//  ThingWithUrl.swift
//  swapi-mvvm-2
//
//  Created by Роман Коренев on 10.04.2023.
//

import Foundation

struct EntityViewModel: Hashable {
    let name: String
    let url: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

//enum Section: String {
//    case main
//}
