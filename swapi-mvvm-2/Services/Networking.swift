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
    
    static func getData(url: String, completion: @escaping (Result<Data, NetworkingError>) -> Void) {
        
        guard let url = URL(string: url) else {completion(.failure(NetworkingError.badURL))
            return
        }
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.badData))
                return
            }
            completion(.success(data))
        }
        session.resume()
    }
}
