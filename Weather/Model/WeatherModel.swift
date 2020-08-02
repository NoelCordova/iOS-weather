//
//  WeatherModel.swift
//  Weather
//
//  Created by Noel Espino Córdova on 01/08/20.
//  Copyright © 2020 slingercode. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let city: String
    let temperature: Double
    let description: String

    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }

    var conditionLogo: String {
        switch conditionId {
        case 200...299:
            return "cloud.bolt"

        case 300...399:
            return "cloud.drizzle"

        case 500...599:
            return "cloud.rain"

        case 600...699:
            return "cloud.snow"

        case 700...799:
            return "cloud.fog"

        case 800:
            return "sun.max"

        case 801...899:
            return "cloud.bolt"

        default:
            return "cloud"
        }
    }
}
