//
//  IntExtension.swift
//  Weather
//
//  Created by Sabri Belguerma on 23/09/2021.
//

import Foundation

extension Int {
	func convertToUserUnits(userDataStorage: UserDataStorage) -> String {
		var format: String = ""

		if userDataStorage.userUnits == "metric" {
			format = "\(self) °C"
		} else if userDataStorage.userUnits == "kelvin" {
			format = "\(self + 273) K"
		} else {
			format = "\((self * 9 / 5) + 32) °F"
		}

		return format
	}

	func convertSpeedToUserUnits(userDataStorage: UserDataStorage) -> String {
		var format: String = ""

		if userDataStorage.userUnits == "metric" {
			format = "\(self) KM"
		} else {
			format = "\(Double(self) / Double(1.609)) M"
		}

		return format
	}
}


extension Double {
	func round(to places: Int) -> Double {
		let divisor = pow(10.0, Double(places))
		return Darwin.round(self * divisor) / divisor
	}
}

extension BinaryFloatingPoint {
	var angle: Self {
		(truncatingRemainder(dividingBy: 360) + 360)
			.truncatingRemainder(dividingBy: 360)
	}
	var direction: Direction { .init(self) }
}

extension Date {
	func getDay() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE"

		return dateFormatter.string(from: self)
	}

	func getHour() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:HH"

		return dateFormatter.string(from: self)
	}

	func getHours() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH"

		return dateFormatter.string(from: self)
	}
}

extension StringProtocol {
	var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
	var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}

