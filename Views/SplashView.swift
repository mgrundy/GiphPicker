//
//  SplashView.swift
//  GiphPicker (iOS)
//
//  Created by Michael Grundy on 3/6/22.
//

import AVKit
import Combine
import Foundation
import SwiftUI
import UIKit

struct SplashView: View {
    @Binding var sheetIsShowing: Bool
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let frame1Url = Bundle.main.url(forResource: "frame1", withExtension: "mp4")
    let frame2Url = Bundle.main.url(forResource: "frame2", withExtension: "mp4")

    let helpString1 = NSLocalizedString("Help Screen 1", tableName: "Settings", comment: "String for first Frame")
    let helpString2 = NSLocalizedString("Help Screen 2", tableName: "Settings", comment: "String for second Frame")

    var body: some View {
        ZStack {
            // Display panel layout based on orientation
            if verticalSizeClass == .regular && horizontalSizeClass == .compact {
                VStack {
                    splashCell(url: frame1Url!, title: helpString1 )
                        .padding()
                    splashCell(url: frame2Url!, title: helpString2)
                        .padding()
                }
            } else {
                HStack {
                    splashCell(url: frame1Url!, title: helpString1 )
                        .padding()
                    splashCell(url: frame2Url!, title: helpString2)
                        .padding()
                }
            }
            // Close sheet button (X)
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        sheetIsShowing = false
                    }) {
                        SmallRoundButton(systemName: "xmark")
                            .padding(.top, 10.0)
                            .padding(.trailing, 10.0)
                    }
                }
                Spacer()
            }
        }
    }
}


struct splashCell: View {
    var url: URL
    var title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .bold()
            AVPlayerControllerRepresented(url: url)
        }
    }
}

struct SplashPreviewWrapper: View {
    @State private var sheetIsShowing: Bool = true
    var body: some View {
        SplashView(sheetIsShowing: $sheetIsShowing)
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SplashPreviewWrapper()
                .previewDevice("iPhone SE (1st generation)")
                .previewInterfaceOrientation(.landscapeRight)
            SplashPreviewWrapper()
                .previewDevice("iPhone SE (1st generation)")
                .previewInterfaceOrientation(.portrait)
            SplashPreviewWrapper()
                .previewDevice("iPhone 12 Pro Max")
                .previewInterfaceOrientation(.portrait)
            SplashPreviewWrapper()
                .previewDevice("iPhone 12 Pro Max")
                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}
