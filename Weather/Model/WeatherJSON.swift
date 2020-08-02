//
//  WeatherJSON.swift
//  Weather
//
//  Created by Noel Espino Córdova on 01/08/20.
//  Copyright © 2020 slingercode. All rights reserved.
//

import Foundation

struct WeatherJSON: Codable {
    let name: String
    let weather: [WeatherProp]
    let main: MainProp
}

struct WeatherProp: Codable {
    // swiftlint:disable:next identifier_name
    let id: Int
    let description: String
}

struct MainProp: Codable {
    let temp: Double
}
