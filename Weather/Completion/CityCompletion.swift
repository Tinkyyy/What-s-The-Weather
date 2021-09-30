//
//  CityCompletion.swift
//  Weather
//
//  Created by Sabri Belguerma on 22/09/2021.
//

import SwiftUI
import Combine

class CityCompletion: NSObject, ObservableObject {

	private var completionManager: CityCompletionManager

	@Published var predictions: [CityCompletion.Prediction] = []

	override init() {
		predictions = []
		completionManager = CityCompletionManager()
		super.init()
	}

	func search(_ search: String) {
		completionManager.getCompletion(for: search) { (predictions) in
			DispatchQueue.main.async {
				self.predictions = predictions
			}
		}
	}

}
