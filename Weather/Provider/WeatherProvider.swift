//
//  WeatherProvider.swift
//  Weather
//
//  Created by Sabri Belguerma on 22/08/2021.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftUI

class WeatherProvider: ObservableObject {
	let httpHeaders: HTTPHeaders = [
		"X-RapidAPI-Key" : Bundle.main.infoDictionary!["API_KEY"] as! String,
	]

	let currentWeatherURL: String = Bundle.main.infoDictionary!["CURRENT_WEATHER_URL"] as! String
	let forecastWeatherURL: String = Bundle.main.infoDictionary!["FORECAST_WEATHER_URL"] as! String
	let forecastDailyWeatherURL: String = Bundle.main.infoDictionary!["FORECAST_DAILY_WEATHER_URL"] as! String

	func fetchWeather(urlParameters: [String: Any], completion: @escaping((CurrentWeather, ForecastWeatherModel) -> ())) {
		var currentWeatherJsonResponse: Data??
		var forecastWeatherJsonResponse: Data??
		var forecastDailyWeatherJsonResponse: Data??

		let group: DispatchGroup = DispatchGroup()
		let group2: DispatchGroup = DispatchGroup()
		let group3: DispatchGroup = DispatchGroup()

		var currentWeather: CurrentWeather?
		var forecastDailyWeather: ForecastWeatherModel?
		var anotherForecastWeather: [AnotherForecast] = []

		group.enter()
		DispatchQueue.main.async {
			AF.request(self.currentWeatherURL, method: .get, parameters: urlParameters, headers: self.httpHeaders).response { response in
				switch response.result {
					case .success:
						currentWeatherJsonResponse = response.value
					case let .failure(error):
						print("Alamofire error: \(error)")
				}
				group.leave()
			}
		}

		group.notify(queue: .main) {
			if currentWeatherJsonResponse != nil {
				if let json = try? JSON(data: currentWeatherJsonResponse!!) {
					let jsonCoord = json["coord"]
					let jsonMainWeather = json["main"]
					let jsonWeatherDescription = json["weather"][0]
					let jsonCloud = json["clouds"]
					let jsonSys = json["sys"]
					let jsonWind = json["wind"]

					currentWeather = CurrentWeather(
						city: City(
							name: json["name"].stringValue, country: nil, population: nil,
							longitude: jsonCoord["lon"].doubleValue, latitude: jsonCoord["lat"].doubleValue),

						temp: jsonMainWeather["temp"].intValue, feelsLike: jsonMainWeather["feels_like"].intValue,
						tempMin: jsonMainWeather["temp_min"].intValue, tempMax: jsonMainWeather["temp_max"].intValue,
						pressure: jsonMainWeather["pressure"].intValue, seaLevel: jsonMainWeather["sea_level"].intValue,
						groundLevel: jsonMainWeather["grnd_level"].intValue, humidity: jsonMainWeather["humidity"].intValue,
						cloud: jsonCloud["all"].intValue,
						visibility: json["visibility"].intValue,

						weatherSystem:
							WeatherSystem(
								id: jsonSys["id"].intValue,
								country: jsonSys["country"].stringValue,
								sunrise: jsonSys["sunrise"].intValue,
								sunset: jsonSys["sunset"].intValue),

						weatherDescription:
							WeatherDescription(
								id: jsonWeatherDescription["id"].intValue,
								main: jsonWeatherDescription["main"].stringValue,
								description: jsonWeatherDescription["description"].stringValue,
								icon: jsonWeatherDescription["icon"].stringValue),

						weatherWind:
							WeatherWind(
								speed: jsonWind["speed"].intValue,
								degrees: jsonWind["deg"].intValue)
					)
				}
			}
		}

		group2.enter()
		DispatchQueue.main.async {
			var params = urlParameters

			params["cnt"] = 8
			AF.request(self.forecastWeatherURL, method: .get, parameters: params, headers: self.httpHeaders).response { response in
				switch response.result {
					case .success:
						forecastWeatherJsonResponse = response.value
					case let .failure(error):
						print("Alamofire error: \(error)")
				}
				group2.leave()
			}
		}

		group2.notify(queue: .main) {
			if forecastWeatherJsonResponse != nil {
				if let json = try? JSON(data: forecastWeatherJsonResponse!!) {
					let jsonForecastList = json["list"]

					if let forecastArray = jsonForecastList.array {
						for fc in forecastArray {

							let forecast = AnotherForecast(
								temp: fc["main"]["temp"].intValue,
								icon: fc["weather"][0]["icon"].stringValue,
								dateTime: fc["dt"].intValue)

							anotherForecastWeather.append(forecast)
						}
					}
				}
			}
		}

		group3.enter()
		DispatchQueue.main.async {
			AF.request(self.forecastDailyWeatherURL, method: .get, parameters: urlParameters, headers: self.httpHeaders).response { response in
				switch response.result {
					case .success:
						forecastDailyWeatherJsonResponse = response.value
					case let .failure(error):
						print("Alamofire error: \(error)")
				}
				group3.leave()
			}
		}

		group3.notify(queue: .main) {
			if forecastDailyWeatherJsonResponse != nil {
				if let json = try? JSON(data: forecastDailyWeatherJsonResponse!!) {
					let jsonCity = json["city"]
					let jsonCoords = json["city"]["coord"]
					let jsonForecastList = json["list"]

					var forecastList: [ForecastWeather] = []

					if let forecastArray = jsonForecastList.array {
						for fc in forecastArray {
							let jsonTemp = fc["temp"]
							let jsonFeelsLike = fc["feels_like"]
							let jsonWeatherDescription = fc["weather"][0]

							let forecast =
								ForecastWeather(
									dateTime: fc["dt"].intValue,
									sunrise: fc["sunrise"].intValue,
									sunset: fc["sunset"].intValue,
									pressure: fc["pressure"].intValue,
									humidity: fc["humidity"].intValue,

									weatherDescription:
										WeatherDescription(
											id: jsonWeatherDescription["id"].intValue,
											main: jsonWeatherDescription["main"].stringValue,
											description: jsonWeatherDescription["description"].stringValue,
											icon: jsonWeatherDescription["icon"].stringValue),
									temp:
										ForecastTemp(
											day: jsonTemp["day"].intValue,
											min: jsonTemp["min"].intValue,
											max: jsonTemp["max"].intValue,
											night: jsonTemp["night"].intValue,
											eve: jsonTemp["eve"].intValue,
											morn: jsonTemp["morn"].intValue),
									feelsLike:
										ForecastFeelsLike(
											day: jsonFeelsLike["day"].intValue,
											night: jsonFeelsLike["night"].intValue,
											eve: jsonFeelsLike["eve"].intValue,
											morn: jsonFeelsLike["morn"].intValue),
									weatherWind:
										WeatherWind(
											speed: fc["speed"].intValue,
											degrees: fc["deg"].intValue),
									gust: fc["gust"].intValue,
									clouds: fc["clouds"].intValue,
									pop: fc["pop"].intValue,
									rain: fc["rain"].intValue)

							forecastList.append(forecast)
						}
					}

					forecastDailyWeather = ForecastWeatherModel(
						city:
							City(
								name: jsonCity["name"].stringValue,
								country: jsonCity["country"].stringValue,
								population: jsonCity["population"].intValue,
								longitude: jsonCoords["lon"].doubleValue,
								latitude: jsonCoords["lat"].doubleValue),
						anotherForecastWeather: anotherForecastWeather,
						forecastWeather:
							forecastList
					)
				}
			}
			
			if let currentWeather = currentWeather {
				if let forecastDailyWeather = forecastDailyWeather {
					if !anotherForecastWeather.isEmpty {
						completion(currentWeather, forecastDailyWeather)
					}
				}
			}
		}
	}
}
