//
//  Networking.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 19.05.2022.
//

import Foundation

struct Networking {
    
    enum NetworkingError: Error{
        case badURL
        case badData
    }
    
    static func getData(url: String) async throws -> Data {
        guard let url = URL(string: url) else { throw NetworkingError.badURL }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
