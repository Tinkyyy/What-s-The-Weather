//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Sabri Belguerma on 11/09/2021.
//

import Foundation

class WeatherViewModel: ObservableObject {
	@Published var cities: [CityWeather] = []

	let dataProvider: DataProvider = DataProvider()

	func fetch(city: String, count: Int, metric: Bool, type: String, lang: String) {
		dataProvider.fetchWeather(
			city: city,
			count: count,
			metric: metric,
			type: type,
			lang: lang,
			completion: { data in
				self.cities.append(data)
			})
	}

	func parse() {
		guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else { return }
		let url = URL(fileURLWithPath: path)
		let data = try! Data(contentsOf: url as URL)

		let jsonData = try! JSONDecoder().decode([SearchCity].self, from: data)
		jsonData.forEach { city in
			print(city.name)
		}
	}
}
