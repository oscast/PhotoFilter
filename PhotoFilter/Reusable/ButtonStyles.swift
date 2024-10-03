//
//  ButtonStyles.swift
//  PhotoFilter
//
//  Created by Oscar Castillo on 3/10/24.
//

import SwiftUI

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 11))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
