//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Sabri Belguerma on 11/09/2021.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
	@Published var weatherData: [(currentWeather: CurrentWeather, forecastWeather: ForecastWeatherModel)] = []
	@Published var currentLocation: (currentWeather: CurrentWeather, forecastWeather: ForecastWeatherModel)?

	let dataProvider: WeatherProvider = WeatherProvider()

	func fetch(units: String, lang: String, longitude: Double, latitude: Double, isCurrentLocation: Bool = false) {
		dataProvider.fetchWeather(
			urlParameters:
				["lon" : longitude,
				 "lat" : latitude,
				 "units" : units,
				 "lang" : lang]) { currentWeather, forecastWeather in
			if !currentWeather.city.name.isEmpty {
				if isCurrentLocation {
					self.currentLocation = (currentWeather, forecastWeather)
				} else if !self.weatherData.contains(where: {$0.currentWeather.city.name == currentWeather.city.name}) {
					self.weatherData.append((currentWeather, forecastWeather))
				}
			}
		}
	}
}
