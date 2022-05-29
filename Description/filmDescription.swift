//
//  FilmDescription.swift
//  SWAPI
//
//  Created by Wheatley on 26.04.2022.
//

import Foundation

func filmDescription (film: FilmNetworkResponse) -> String {
    let output = """
    Opening crawl: \n \n \(film.openingCrawl)\n
    Director: \(film.director)\n
    Producer: \(film.producer)\n
    Release date: \(film.releaseDate)\n
    Characters: \(film.characters)\n
    Planets: \(film.planets)\n
    Starships: \(film.planets)\n
    Vehicles: \(film.planets)\n
    Species: \(film.species)\n
    """
    return output
}
