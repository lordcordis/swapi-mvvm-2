//
//  Protocols.swift
//  swapi-mvvm-2
//
//  Created by Роман Коренев on 30.05.2023.
//

import Foundation

protocol NetworkResponse: Codable {
    var url: String {get}
}

protocol ListNetworkResponse: Codable {
    var count: Int { get }
    var next: String? { get }
    var previous: String? { get }
    var results: [NetworkResponse] { get }
}
