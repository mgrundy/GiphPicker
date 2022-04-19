//
//  PreviewView.swift
//  GiphPicker (iOS)
//
//  Created by Michael Grundy on 3/7/22.
//

import SwiftUI

struct Preview: View {
    var gifData: GifData

    var body: some View {
        Text(gifData.id)
        Text(gifData.title)
        Text(gifData.images.original.mp4Url)
    }
}

//q
//Gfunc getTestData() -> GifData? {
//    let testResponse = """
//    "data": [
//      {
//        "id": "nDSlfqf0gn5g4",
//        "title": "Dance Reaction GIF by SpongeBob SquarePants",
//        "images": {
//          "original": {
//            "mp4": "https://media0.giphy.com/media/nDSlfqf0gn5g4/giphy.mp4",
//          }}}]
//    """
//
//    guard let data = testResponse.data(using: .utf8)
//    else {
//        print("Unable Datastream mock json response")
//        return nil
//    }
//
//    let decoder = JSONDecoder()
//
//    // Check that we can parse the mock data.
//    guard let parsedResponse = try? decoder.decode(GifSearchResponse.self, from: data) else {
//        print("Unable to parse json response")
//        return nil
//    }
//
//    return parsedResponse.data[0]
//}
