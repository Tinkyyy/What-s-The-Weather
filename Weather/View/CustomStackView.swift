//
//  CustomStackView.swift
//  Weather
//
//  Created by Sabri Belguerma on 18/08/2021.
//

import SwiftUI

struct CustomStackView<Title: View, Content: View>: View {
	var titleView: Title
	var contentView: Content

	init(@ViewBuilder titleView: @escaping () -> Title, @ViewBuilder contentView: @escaping () -> Content) {
		self.contentView = contentView()
		self.titleView = titleView()
	}

	var body: some View {
		VStack(spacing : 0) {
			titleView
				.font(.callout)
				.lineLimit(1)
				.frame(height: 40)
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.leading)
				.background(Color(UIColor.darkGray))
				.clipShape(
					CustomCornerShape(
						corners: [.topLeft, .topRight],
						radius: 12)
				)
			Divider()
			VStack {
				contentView
					.padding()
			}.background(Color(UIColor.darkGray))
			.contentShape(
				CustomCornerShape(
					corners: [.bottomLeft, .bottomRight],
					radius: 12)
			)
		}.colorScheme(.dark)
	}
}
