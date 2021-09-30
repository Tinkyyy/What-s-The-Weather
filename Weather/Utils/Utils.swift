//
//  Utils.swift
//  Weather
//
//  Created by Sabri Belguerma on 23/09/2021.
//

import CoreLocation

class Utils {
	static func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
		CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
	}
}

enum Direction: String, CaseIterable {
	case N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
}

extension Direction: CustomStringConvertible  {
	init<D: BinaryFloatingPoint>(_ direction: D) {
		self =  Self.allCases[Int((direction.angle+11.25).truncatingRemainder(dividingBy: 360)/22.5)]
	}
	var description: String { rawValue.uppercased() }
}
