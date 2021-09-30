//
//  ForecastWeatherModel.swift
//  Weather
//
//  Created by Sabri Belguerma on 19/09/2021.
//

import SwiftUI

struct ForecastWeatherModel {
	let city: City
	let anotherForecastWeather: [AnotherForecast]
	let forecastWeather: [ForecastWeather]
}

struct AnotherForecast {
	let id: UUID = UUID()

	var temp: Int
	var icon: String
	var dateTime: Int
}

struct ForecastWeather: Identifiable {
	let id: UUID = UUID()

	let dateTime: Int
	let sunrise: Int
	let sunset: Int
	let pressure: Int
	let humidity: Int

	let weatherDescription: WeatherDescription
	let temp: ForecastTemp
	let feelsLike: ForecastFeelsLike
	let	weatherWind: WeatherWind

	let gust: Int
	let clouds: Int
	let pop: Int
	let rain: Int // Optional ? Thanks Open Weather Map
}

struct ForecastTemp {
	let day: Int
	let min: Int
	let max: Int
	let night: Int
	let eve: Int
	let morn: Int
}

struct ForecastFeelsLike {
	let day: Int
	let night: Int
	let eve: Int
	let morn: Int
}
