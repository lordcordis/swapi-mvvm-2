//
//  vehicleDescription.swift
//  SWAPI
//
//  Created by Wheatley on 26.04.2022.
//

import Foundation

func vehicleDescription (vehicle: VehicleNetworkResponse) -> String {
    
    let output = """

    cargoCapacity \(vehicle.cargoCapacity) \n
    consumables \n
    costInCredits \n
    created \n
    crew \n
    edited \n
    length \n
    manufacturer \n
    maxAtmospheringSpeed \n
    model \n
    name \n
    passengers \n
    let pilots: [String]? \n
    let films: [String] \n
    let url: String \n
    let vehicleClass: String \n
"""
    
    
    return output
}
