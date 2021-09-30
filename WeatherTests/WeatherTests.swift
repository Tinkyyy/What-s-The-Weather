//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Sabri Belguerma on 05/08/2021.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {

	func testInitCity() {
		let city = City(name: "Paris", country: "France", population: 1000, longitude: 29.00, latitude: 51.00)

		XCTAssertEqual("Paris", city.name)
		XCTAssertEqual("France", city.country)
		XCTAssertEqual(29.00, city.longitude)
		XCTAssertEqual(51.00, city.latitude)
	}
}
