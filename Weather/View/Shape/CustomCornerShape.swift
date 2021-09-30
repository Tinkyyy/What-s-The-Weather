//
//  CustomCornerShape.swift
//  Weather
//
//  Created by Sabri Belguerma on 18/08/2021.
//

import SwiftUI

struct CustomCornerShape: Shape {
	var corners: UIRectCorner
	var radius: CGFloat

	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(
			roundedRect: rect,
			byRoundingCorners: corners,
			cornerRadii: CGSize(width: radius, height: radius))

		return Path(path.cgPath)
	}
}
