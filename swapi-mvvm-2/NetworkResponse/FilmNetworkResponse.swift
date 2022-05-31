//
//  Film.swift
//  SWAPI
//
//  Created by Wheatley on 20.04.2022.
//

import Foundation

////struct FilmNetworkResponse: Codable, NetworkResponse {
////    let title: String
////    let episodeID: Int
////    let openingCrawl, director, producer, releaseDate: String
////    let characters, planets, starships, vehicles: [String]
////    let species: [String]
////    let created, edited: String
////    let url: String
////
////    enum CodingKeys: String, CodingKey {
////        case title
////        case episodeID = "episode_id"
////        case openingCrawl = "opening_crawl"
////        case director, producer
////        case releaseDate = "release_date"
////        case characters, planets, starships, vehicles, species, created, edited, url
////    }
////}
////
////struct FilmListNetworkResponse: Codable {
////    let count: Int
////    let next: String?
////    let previous: String?
////    let results: [FilmNetworkResponse]
////}
//
//
//struct FilmListNetworkResponse: Codable {
//    let count: Int
//    let next, previous: String?
//    let results: [FilmNetworkResponse]
//}
//
//// MARK: - Result
//struct FilmNetworkResponse: Codable, NetworkResponse {
//    let title: String
//    let episodeID: Int
//    let openingCrawl, director, producer, releaseDate: String
//    let characters, planets, starships, vehicles: [String]
//    let species: [String]
//    let created, edited: String
//    let url: String
//
//    enum CodingKeys: String, CodingKey {
//        case title
//        case episodeID = "episode_id"
//        case openingCrawl = "opening_crawl"
//        case director, producer
//        case releaseDate = "release_date"
//        case characters, planets, starships, vehicles, species, created, edited, url
//    }
//}
//
//
//


struct FilmNetworkResponse: Codable, NetworkResponse {
    let title: String
    let episodeID: Int
    let openingCrawl, director, producer, releaseDate: String
    let characters, planets, starships, vehicles: [String]
    let species: [String]
    let created, edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case title
        case episodeID = "episode_id"
        case openingCrawl = "opening_crawl"
        case director, producer
        case releaseDate = "release_date"
        case characters, planets, starships, vehicles, species, created, edited, url
    }
}


struct FilmListNetworkResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [FilmNetworkResponse]
}
