//
//  StringExtension.swift
//  Weather
//
//  Created by Sabri Belguerma on 11/09/2021.
//

import Foundation

extension String {

	var toDouble: Double {
		if let value = Double(self) {
			return value
		}
		return -1
	}
}
