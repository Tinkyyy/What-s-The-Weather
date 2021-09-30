//
//  UserDataStorage.swift
//  Weather
//
//  Created by Sabri Belguerma on 21/09/2021.
//

import Foundation
import CoreLocation

class UserDataStorage: ObservableObject {

	@Published var userUnits: String = "metric"

	@Published var userWeathersSaved: [WeatherUserModel] = [] {
		didSet {
			saveData()
		}
	}

	let weatherKey: String = "weather_key"
	let unitsKey: String = "units_key"

	let userDefaults = UserDefaults.standard

	init() {
		self.getWeatherData()
		self.getUserUnits()
	}

	func getWeatherData() {
		guard
			let dataStore = userDefaults.data(forKey: weatherKey),
			let savedData = try? JSONDecoder().decode([WeatherUserModel].self , from: dataStore)
		else {
			return
		}

		self.userWeathersSaved = savedData
	}

	func setImperialUnits() {
		self.userDefaults.setValue("imperial", forKey: self.unitsKey)
		self.userUnits = "imperial"
	}

	func setMetricUnits() {
		self.userDefaults.setValue("metric", forKey: self.unitsKey)
		self.userUnits = "metric"
	}

	func setKelvinUnits() {
		self.userDefaults.setValue("kelvin", forKey: self.unitsKey)
		self.userUnits = "kelvin"
	}

	private func getUserUnits() {
		if let units = self.userDefaults.string(forKey: self.unitsKey) {
			self.userUnits = units
		}
	}

	func deleteCity(weatherUser: WeatherUserModel) {
		if let index = self.userWeathersSaved.firstIndex(where: { $0 == weatherUser }) {
			self.userWeathersSaved.remove(at: index)
			self.saveData()
		}
	}

	func deleteCity(indexSet: IndexSet) {
		self.userWeathersSaved.remove(atOffsets: indexSet)
		self.saveData()
	}

	func addCity(weatherUser: WeatherUserModel) {
		if !self.userWeathersSaved.contains(weatherUser) {
			self.userWeathersSaved.append(weatherUser)
			self.saveData()
		}
	}

	func removeAllCity() {
		self.userWeathersSaved.removeAll()
		self.saveData()
	}

	func saveData() {
		if let encodeData = try? JSONEncoder().encode(userWeathersSaved) {
			self.userDefaults.set(encodeData , forKey: self.weatherKey)
		}
	}

}

struct WeatherUserModel: Equatable, Codable {
	var city: String
	var country: String
	var longitude: Double
	var latitude: Double
}
