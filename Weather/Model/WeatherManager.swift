//
//  WeatherManager.swift
//  Weather
//
//  Created by Noel Espino Córdova on 01/08/20.
//  Copyright © 2020 slingercode. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherDelegate: class {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)

    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let api = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid=API_KEY"

    weak var delegate: WeatherDelegate?

    func fetchWeather(_ city: String) {
        let url = "\(api)&q=\(city)"
        apiCall(with: url)
    }

    func fetchWeather(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        let url = "\(api)&lat=\(latitude)&lon=\(longitude)"
        apiCall(with: url)
    }

    func apiCall(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }

                if let response = data {
                    if let weather = self.parceJSON(response) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }

            task.resume()
        }
    }

    func parceJSON(_ weatherData: Data) -> WeatherModel? {
        let decorer = JSONDecoder()

        do {
            let decodedData = try decorer.decode(WeatherJSON.self, from: weatherData)

            // swiftlint:disable:next identifier_name
            let id = decodedData.weather[0].id
            let city = decodedData.name
            let temp = decodedData.main.temp
            let description = decodedData.weather[0].description

            let weather = WeatherModel(conditionId: id, city: city, temperature: temp, description: description)

            return weather
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
