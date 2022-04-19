//
//  ButtonViews.swift
//  GiphPicker (iOS)
//
//  Created by Michael Grundy on 3/4/22.
//

import Foundation
import SwiftUI

struct RoundButton: View {
    var systemName: String

    var body: some View {
        Image(systemName: systemName)
            .font(.title)
            .foregroundColor(Color.white)
            .frame(width: CGFloat(56.0), height: CGFloat(56.0))
            .background(
                Circle()
                    .fill(Color.red)
            )
    }
}

struct SmallRoundButton: View {
    var systemName: String
    private let size = UIScreen.main.bounds.width / 20
    var body: some View {
        Image(systemName: systemName)
            .foregroundColor(Color.white)
            .frame(width: CGFloat(size), height: CGFloat(size))
            .background(
                Circle()
                    .fill(Color.red)
            )
    }
}

struct PreviewView: View {
    var body: some View {
        VStack(spacing: 10) {
            RoundButton(systemName: "brain.head.profile")
            SmallRoundButton(systemName: "xmark")
        }
    }
}

struct ButtonViews_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView()
            .previewDevice("iPhone 8 Plus")

    }
}

