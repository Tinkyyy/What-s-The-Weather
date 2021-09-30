//
//  Weather.swift
//  Weather
//
//  Created by Sabri Belguerma on 11/09/2021.
//

import Foundation

struct CurrentWeather {
	let id: UUID = UUID()
	let city: City

	let temp: Int
	let feelsLike: Int
	let tempMin: Int
	let tempMax: Int
	let pressure: Int
	let seaLevel: Int
	let groundLevel: Int
	let humidity: Int

	let cloud: Int
	let visibility: Int

	let weatherSystem: WeatherSystem
	let weatherDescription: WeatherDescription
	let	weatherWind: WeatherWind
}

struct City {
	let name: String
	let country: String? //Forecast
	let population: Int? //Forecast
	let longitude: Double
	let latitude: Double
}

struct WeatherWind {
	let speed: Int
	let degrees: Int
}

struct WeatherSystem {
	let id: Int
	let country: String
	let sunrise: Int
	let sunset: Int
}

struct WeatherDescription {
	let id: Int
	let main: String
	let description: String
	let icon: String
}
