//
//  WeatherViewController.swift
//  Weather
//
//  Created by Noel Espino Córdova on 01/08/20.
//  Copyright © 2020 slingercode. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherManager.delegate = self
        searchTextField.delegate = self
        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

}

// MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(city)
        }

        searchTextField.text = ""
    }

}

// MARK: - WeatherDelegate
extension WeatherViewController: WeatherDelegate {

    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionLogo)
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = "\(weather.city), \(weather.description)"
        }
    }

    func didFailWithError(_ error: Error) {
        print(error)
    }

}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {

    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()

            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude

            weatherManager.fetchWeather(lat, long)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}
