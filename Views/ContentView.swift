//
//  ContentView.swift
//  Shared
//
//  Created by Michael Grundy on 3/4/22.
//

import AVKit
import Combine
import Foundation
import SwiftUI
import UIKit

struct ContentView: View {
    @ObservedObject var apiSearch = GiphyApi()
    @State private var buttonDisabled = false
    @State private var gifList: [GifData] = []
    @State private var sheetIsShowing: Bool = false

    var body: some View {
        ZStack {
            VStack {
                TextField("Search", text: $apiSearch.queryString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List(apiSearch.searchResults) { gifData in
                    Button(action: {
                        // temporary action
                        print("Load preview for \(gifData.images.original.mp4Url)")
                    }) {
                        previewCell(urlString: gifData.images.preview.url, title: gifData.title)

                    }

                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        sheetIsShowing = true
                    }) {
                        RoundButton(systemName: "face.smiling")
                            .padding()
                    }
                    .sheet(isPresented: $sheetIsShowing, onDismiss: {}, content: {
                        SplashView(sheetIsShowing: $sheetIsShowing)
                    })
                }
            }
        }
    }

    struct previewCell: View {
        var urlString: String
        var title: String

        var body: some View {
            VStack {
                AVPlayerControllerRepresented(url: urlString)
                    .frame(height: 300)
                    .cornerRadius(10.0)
                Text(title)
                    .bold()
            }
        }
    }
}

struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    private var playerLooper: NSObject
    private var playerItem: AVPlayerItem
    private var queuePlayer: AVQueuePlayer

    init(url: String) {
        let newUrl =  URL(string: url)!
        self.init(url: newUrl)
    }

    init(url: URL) {
        let asset = AVAsset(url: url)
        playerItem = AVPlayerItem(asset: asset)
        queuePlayer = AVQueuePlayer(items: [playerItem])
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)

    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = queuePlayer
        controller.showsPlaybackControls = false
        controller.player?.play()
        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone 8 Plus")
                .previewInterfaceOrientation(.portrait)
            ContentView()
                .previewDevice("iPhone 12 Pro Max")
                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}
