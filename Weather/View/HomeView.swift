//
//  HomeView.swift
//  Weather
//
//  Created by Sabri Belguerma on 16/09/2021.
//

import SwiftUI
import Foundation
import Combine

struct CityListRow: View {
	@EnvironmentObject var weatherViewModel: WeatherViewModel
	@EnvironmentObject var locationViewModel: LocationViewModel
	@EnvironmentObject var userDataStorage: UserDataStorage

	@State var isPresenting: Bool = false

	var body: some View {
		NavigationView {
			VStack {
				List {
					if locationViewModel.authorizationStatus == .authorizedWhenInUse || locationViewModel.authorizationStatus == .authorizedAlways {
						Section(header: Text("Current Position")) {
							if weatherViewModel.currentLocation == nil {
								EmptyView()
							} else {
								CityRow(weather: weatherViewModel.currentLocation)
							}
						}.padding(.bottom, 10)
					}

					Section(header: Text("Cities")) {
						ForEach(Array(weatherViewModel.weatherData), id: \.currentWeather.id) { currentWeather, forecastWeather in
							CityRow(weather: (currentWeather, forecastWeather))
						}.onDelete { indexSet in
							self.weatherViewModel.weatherData.remove(atOffsets: indexSet)
							self.userDataStorage.deleteCity(indexSet: indexSet)
						}
					}

				}.onAppear {
					DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
						if locationViewModel.authorizationStatus == .authorizedWhenInUse
							|| locationViewModel.authorizationStatus == .authorizedAlways {
							if let placemark = locationViewModel.currentPlacemark {
								if let coordinate = placemark.location?.coordinate {
									weatherViewModel.fetch(
										units: "metric", lang: "en",
										longitude: coordinate.longitude,
										latitude: coordinate.latitude,
										isCurrentLocation: true)
								}
							}
						}
					}
				}.refreshable {
					userDataStorage.userWeathersSaved.forEach { data in
//						if weatherViewModel.weatherData.isEmpty {
							weatherViewModel.fetch(units: "metric", lang: "en", longitude: data.longitude, latitude: data.latitude)
//						} else {
//							DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(60)) {
//								weatherViewModel.fetch(units: "metric", lang: "en", longitude: data.longitude, latitude: data.latitude)
//							}
//						}
					}
				}.navigationTitle("Weather")
					.navigationViewStyle(StackNavigationViewStyle())
					.listStyle(GroupedListStyle())
				Spacer()

				HStack {
					Image(systemName: "plus.magnifyingglass")
						.onTapGesture {
							isPresenting = true
						}
					Spacer()
					Text(self.getUserUnits)
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
				.padding()
				.frame(maxWidth: .infinity)
			}.frame(maxHeight: .infinity)
		}.sheet(isPresented: $isPresenting) {
			isPresenting = false
		} content: {
			SearchCityView()
		}
	}
	var getUserUnits: String {
		if userDataStorage.userUnits == "metric" {
			return "°C"
		} else if self.userDataStorage.userUnits == "imperial" {
			return "°F"
		} else {
			return "K"
		}
	}
}

struct CityRow: View {
	var weather: (currentWeather: CurrentWeather, forecastWeather: ForecastWeatherModel)?
	@State var isActive: Bool = false
	@EnvironmentObject var userDataStorage: UserDataStorage

	var body: some View {
		NavigationLink(destination: WeatherView(weather: weather!).navigationBarHidden(true).ignoresSafeArea()) {
			HStack(alignment: .firstTextBaseline) {
				Text(weather?.currentWeather.city.name ?? "Unknown position")
					.lineLimit(nil)
					.font(.title)
				Spacer()
				HStack {
					Image(systemName: (ForecastIcon(rawValue: weather?.currentWeather.weatherDescription.icon ?? "") ?? .unknown).sfSymbolName)
						.renderingMode(.original)
						.font(.title)
					Text(weather?.currentWeather.temp.convertToUserUnits(userDataStorage: userDataStorage) ?? "N/A")
						.foregroundColor(.gray)
						.font(.title)
				}
			}.padding([.trailing, .top, .bottom])
		}
	}
}

struct SearchCityView: View {
	@State var search: String = ""
	@State var isSearching: Bool = false

	@Environment(\.presentationMode) var presentationMode
	@EnvironmentObject var userDataStorage: UserDataStorage
	@StateObject var completer: CityCompletion = CityCompletion()

	var body: some View {
		List {
			Section {
				HStack {
					TextField("Search City", text: $search)
						.onChange(of: search, perform: { newValue in
							self.isSearching = true
							DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
								self.completer.search(self.search)
								self.isSearching = false
							})
						})
					if isSearching {
						Image(systemName: "clock")
							.foregroundColor(Color.gray)
					}
				}
			}

			Section {
				ForEach(completer.predictions) { prediction in
					Text(prediction.description)
						.foregroundColor(.primary)
						.onTapGesture {
							let splitAddress: [String] = prediction.description.components(separatedBy: [",", "-"])
							let city: String = splitAddress[0]
							let country: String = splitAddress[1]

							Utils.getCoordinateFrom(address: prediction.description) { coordinate, error in
								if let coordinate = coordinate {
									let place = WeatherUserModel(city: city, country: country, longitude: coordinate.longitude, latitude: coordinate.latitude)
									userDataStorage.addCity(weatherUser: place)
								}
							}
							self.presentationMode.wrappedValue.dismiss()
						}
				}
			}.listStyle(GroupedListStyle())
		}
	}
}
