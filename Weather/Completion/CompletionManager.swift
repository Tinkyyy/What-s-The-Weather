//
//  CompletionManager.swift
//  Weather
//
//  Created by Sabri Belguerma on 22/09/2021.
//

import Foundation
import CoreLocation

class CityCompletionManager: NSObject {

	var completionTask: URLSessionDataTask?

	func getCompletion(for search: String, _ completion: @escaping (_ results: [CityCompletion.Prediction]) -> Void) {
		guard let url = URL(string: NetworkManager.API.cityCompletion(for: search, type: "cities")) else {
			completion([])
			return
		}

		completionTask?.cancel()

		completionTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard let data = data else {
				completion([])
				return
			}

			do {
				let decoder = JSONDecoder()
				let result = try decoder.decode(CityCompletion.Result.self, from: data)
				completion(result.predictions)
			} catch {
				completion([])
			}
		}

		completionTask?.resume()
	}

}

extension CityCompletion {

	struct Result: Codable {

		var predictions: [Prediction]

		enum CodingKeys: String, CodingKey {

			case predictions = "predictions"

		}

	}

	struct Prediction: Codable, Identifiable {

		var id: String
		var description: String

		enum CodingKeys: String, CodingKey {

			case id = "place_id"
			case description = "description"

		}

	}

}

class NetworkManager: NSObject {
	static var placesAPIEndpoint: String = Bundle.main.infoDictionary!["PLACES_API_URL"] as! String
	static var placesAPIKey: String = Bundle.main.infoDictionary!["PLACES_API_KEY"] as! String

	struct API {
		static func cityCompletion(for search: String, type: String) -> String {
			var stringURL: String = placesAPIEndpoint

			stringURL.append("?input=\(search)&")
			stringURL.append("types=(\(type))&")
			stringURL.append("key=\(placesAPIKey)")

			return stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
		}
	}
}
