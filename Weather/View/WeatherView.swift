//
//  HomeView.swift
//  Weather
//
//  Created by Sabri Belguerma on 18/08/2021.
//

import SwiftUI

struct WeeklyWeatherForecastView: View {
	var weatherForecast: [ForecastWeather]
	@EnvironmentObject var userDataStorage: UserDataStorage

	var forecastColumns: [GridItem] = [
		GridItem(.flexible(), alignment: .leading),
		GridItem(.flexible()),
		GridItem(.flexible(), alignment: .trailing)
	]

	var stuck: [GridItem] = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]

	var body: some View {
		CustomStackView {
			Label {
				Text("Weekly Forecast")
			} icon: {
				Image(systemName: "calendar")
			}
		} contentView: {
			LazyVGrid(columns: forecastColumns, spacing: 15) {
				ForEach(Array(weatherForecast), id: \.id) { weatherForecast in
					HStack {
						Text(Date(timeIntervalSince1970: TimeInterval(weatherForecast.dateTime)).getDay())
					}

					HStack {
						Image(systemName: (ForecastIcon(rawValue: weatherForecast.weatherDescription.icon) ?? .unknown).sfSymbolName)
							.renderingMode(.original)
						if let rain = weatherForecast.rain {
							if rain > 0 {
								Text("\(weatherForecast.rain)%")
									.font(.caption)
									.foregroundColor(
										Color(red: 0.4627, green: 0.8392, blue: 1.0))
							}
						}
					}.frame(maxWidth: 110, alignment: .leading)
						.padding(.leading, 50)

					HStack {
						Text("\(weatherForecast.temp.max.convertToUserUnits(userDataStorage: userDataStorage).components(separatedBy:CharacterSet.decimalDigits.inverted).joined())")
						Text("\(weatherForecast.temp.min.convertToUserUnits(userDataStorage: userDataStorage).components(separatedBy:CharacterSet.decimalDigits.inverted).joined())")
					}
				}
			}
		}
	}
}

struct CurrentWeatherView: View {
	@EnvironmentObject var userDataStorage: UserDataStorage
	var currentWeather: CurrentWeather

	var body: some View {
		VStack(alignment: .center, spacing: 5) {
			Text(currentWeather.city.name)
				.font(.system(size: 30))
				.foregroundColor(.white)
				.shadow(radius: 5)

			Text(currentWeather.weatherDescription.description.firstUppercased)
				.font(.system(size: 15))
				.foregroundColor(.white)
				.shadow(radius: 5)

			Text("\(currentWeather.temp.convertToUserUnits(userDataStorage: userDataStorage).components(separatedBy:CharacterSet.decimalDigits.inverted).joined())°")
				.font(.system(size: 80, weight: .ultraLight))
				.foregroundColor(.white)
				.onTapGesture {
					if self.userDataStorage.userUnits == "metric" {
						self.userDataStorage.setImperialUnits()
					} else if self.userDataStorage.userUnits == "imperial" {
						self.userDataStorage.setKelvinUnits()
					} else {
						self.userDataStorage.setMetricUnits()
					}
				}
		}
	}
}

struct HourlyWeatherForecastView: View {
	@EnvironmentObject var userDataStorage: UserDataStorage
	var forecastWeather: ForecastWeatherModel

	var body: some View {
		CustomStackView {
			Label {
				Text("Hourly Forecast")
			} icon: {
				Image(systemName: "clock")
			}
		} contentView: {
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 30) {
					ForEach(forecastWeather.anotherForecastWeather, id: \.id) { forecast in
						VStack(spacing: 16) {
							Text(Date(timeIntervalSince1970 : TimeInterval(forecast.dateTime)).getHours() + "h")
								.font(.callout)
								.foregroundColor(.white)

							Image(systemName: (ForecastIcon(rawValue: forecast.icon) ?? .unknown).sfSymbolName)
								.renderingMode(.original)

							Text("\(forecast.temp.convertToUserUnits(userDataStorage: userDataStorage).components(separatedBy:CharacterSet.decimalDigits.inverted).joined())°")
								.font(.callout.bold())
								.foregroundColor(.white)
						}.frame(maxHeight: .infinity)
					}
				}
			}
		}
	}
}

struct WeatherPrecipitationView: View {
	var weather: (currentWeather: CurrentWeather, forecastWeather: ForecastWeatherModel)

	var weatherInformationsColumns: [GridItem] = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]

	var body: some View {
		let currentWeather = weather.currentWeather
		let forecastWeather = weather.forecastWeather

		CustomStackView {
			Label {
				Text("Precipitations")
			} icon: {
				Image(systemName: "wind")
			}
		} contentView: {
			LazyVGrid(columns: weatherInformationsColumns, alignment: .leading) {
				VStack(alignment: .leading, spacing: 0) {
					Text("SUNRISE")
						.font(.system(.caption, design: .rounded))
						.foregroundColor(.gray)
					Text(Date(timeIntervalSince1970 : TimeInterval(currentWeather.weatherSystem.sunrise)).getHour())
						.font(.system(.title, design: .rounded))
					Divider()
						.background(Color.white)
				}

				VStack(alignment: .leading, spacing: 0) {
					Text("SUNSET")
						.font(.system(.caption, design: .rounded))
						.foregroundColor(.gray)
					Text(Date(timeIntervalSince1970 : TimeInterval(currentWeather.weatherSystem.sunset)).getHour())
						.font(.system(.title, design: .rounded))
					Divider()
						.background(Color.white)
				}

				VStack(alignment: .leading, spacing: 0) {
					Text("RISK OF RAIN")
						.font(.system(.caption, design: .rounded))
						.foregroundColor(.gray)
					Text("\(forecastWeather.forecastWeather[0].rain) %")
						.font(.system(.title, design: .rounded))
					Divider()
						.background(Color.white)
				}

				VStack(alignment: .leading, spacing: 0) {
					Text("CLOUDY")
						.font(.system(.caption, design: .rounded))
						.foregroundColor(.gray)
					Text("\(currentWeather.cloud) %")
						.font(.system(.title, design: .rounded))
					Divider()
						.background(Color.white)
				}

				VStack(alignment: .leading, spacing: 0) {
					Text("ATMOSPHERIC PRESSURE")
						.font(.system(.caption, design: .rounded))
						.foregroundColor(.gray)
					Text("\(currentWeather.pressure) hPa")
						.font(.system(.title, design: .rounded))
					Divider()
						.background(Color.white)
				}

				VStack(alignment: .leading, spacing: 0) {
					Text("HUMIDITY")
						.font(.system(.caption, design: .rounded))
						.foregroundColor(.gray)
					Text("\(currentWeather.humidity) %")
						.font(.system(.title, design: .rounded))
					Divider()
						.background(Color.white)
				}

				VStack(alignment: .leading, spacing: 0) {
					Text("WIND")
						.font(.system(.caption, design: .rounded))
						.foregroundColor(.gray)
					Text("\(CGFloat(currentWeather.weatherWind.degrees).direction.rawValue) \(currentWeather.weatherWind.speed) km/h")
						.font(.system(.title, design: .rounded))
					Divider()
						.background(Color.white)
				}

				VStack(alignment: .leading, spacing: 0) {
					Text("VISIBILITY")
						.font(.system(.caption, design: .rounded))
						.foregroundColor(.gray)

					let visibility = String(format:"%.1f", Double(currentWeather.visibility / 1000))
					Text("\(visibility) km")
						.font(.system(.title, design: .rounded))
					Divider()
						.background(Color.white)
				}
			}
		}
	}
}

struct WeatherView: View {
	@Environment(\.presentationMode) var presentationMode

	var weather: (currentWeather: CurrentWeather, forecastWeather: ForecastWeatherModel)?

	var body: some View {
		let currentWeather = weather!.currentWeather
		let forecastWeather = weather!.forecastWeather

		ZStack {
			GeometryReader { reader in
				Image(currentWeather.weatherDescription.description.replacingOccurrences(of: " ", with: "_"))
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(width: reader.size.width,
						   height: reader.size.height)
					.blur(radius: 15.0)
			}.ignoresSafeArea()
			ScrollView(.vertical, showsIndicators: false) {
				VStack(spacing: 8) {
					CurrentWeatherView(currentWeather: currentWeather)
						.padding(.top, 20)
					HourlyWeatherForecastView(forecastWeather: forecastWeather)
						.frame(maxWidth: .infinity, maxHeight: .infinity)

					WeeklyWeatherForecastView(weatherForecast: forecastWeather.forecastWeather)
						.frame(maxWidth: .infinity, maxHeight: .infinity)

					WeatherPrecipitationView(weather: weather!)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
			}.padding([.top, .bottom], 25)
			.padding([.horizontal, .bottom])
			VStack {
				Spacer()
				HStack {
					Spacer()
					Image(systemName: "list.dash")
						.resizable()
						.foregroundColor(.white)
						.frame(width: 16, height: 16, alignment: .trailing)
						.onTapGesture {
							presentationMode.wrappedValue.dismiss()
						}
				}.padding()
				.frame(maxWidth: .infinity)
			}.frame(maxHeight: .infinity)
		}
	}
}
