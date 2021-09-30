//
//  WeatherApp.swift
//  Weather
//
//  Created by Sabri Belguerma on 05/08/2021.
//

import SwiftUI

@main
struct WeatherApp: App {
	@StateObject var weatherProvider: WeatherProvider = WeatherProvider()
	@StateObject var weatherViewModel: WeatherViewModel = WeatherViewModel()
	@StateObject var locationViewModel: LocationViewModel = LocationViewModel()
	@StateObject var userDataStorage: UserDataStorage = UserDataStorage()

	var body: some Scene {
		WindowGroup {
			switch locationViewModel.authorizationStatus {
				case .notDetermined:
					RequestLocationView()
						.environmentObject(locationViewModel)
				default:
					CityListRow()
						.preferredColorScheme(.dark)
						.environmentObject(weatherProvider)
						.environmentObject(weatherViewModel)
						.environmentObject(locationViewModel)
				.environmentObject(userDataStorage)
			}
		}
	}
}

struct RequestLocationView: View {
	@EnvironmentObject var locationViewModel: LocationViewModel

	var body: some View {
		VStack {
			VStack {
				Image(systemName: "location.circle")
					.resizable()
					.frame(width: 100, height: 100, alignment: .center)
					.foregroundColor(.white)

				Button(action: {
					locationViewModel.requestPermission()
				}, label: {
					Label("Allow tracking", systemImage: "location")
				}).padding(10)
				.foregroundColor(.white)
				.background(Color.blue)
				.overlay(
					RoundedRectangle(cornerRadius: 20)
						.stroke(Color.white, lineWidth: 2)
				)
			}

			Text("We need your permission to track you.")
				.foregroundColor(.white)
				.font(.caption)

		}.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(Color.blue)
		.ignoresSafeArea()
	}
}
