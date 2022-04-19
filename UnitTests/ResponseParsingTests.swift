//
//  ResponseParsingTests.swift
//  Tests iOS
//
//  Created by Michael Grundy on 3/5/22.
//

import XCTest

class ResponseParsingTests: XCTestCase {

    // Checks the GifSearchResponse parse structs against a complete search API response
    func test_full_Response_Decoding() throws {
        // Set up mock Giphy query response.
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "gphy", withExtension: "json")
        else {
            XCTFail("Unable to bundle mock json response")
            return
        }
        guard let data = try? Data(contentsOf: url)
        else {
            XCTFail("Unable Datastream mock json response")
            return
        }

        let decoder = JSONDecoder()

        // Check that we can parse the mock data.
        guard let parsedResponse = try? decoder.decode(GifSearchResponse.self, from: data) else {
            XCTFail("Unable to parse json response")
            return
        }

        let gifData = parsedResponse.data

        // Check that we parse the mock data correctly
        XCTAssertEqual(gifData.count, 2)
        XCTAssertEqual(gifData[0].id, "nDSlfqf0gn5g4")
        XCTAssertEqual(gifData[1].title, "Scared Nervous GIF by SpongeBob SquarePants")
    }

    // The next three tests test the individual image record parsers. If the full response test fails
    // these tests will point at the most probably problem child.
    func test_mp4Data_parsing() throws {
        // Example is preview object in images.
        let mockData = """
         {
          "height": "164",
          "width": "215",
          "mp4_size": "22111",
          "mp4": "https://media0.giphy.com/media/nDSlfqf0gn5g4/giphy-preview.mp4"
        }
        """

        guard let data = mockData.data(using: .utf8) else {
            XCTFail("Unable get data of json mock string")
            return
        }

        let decoder = JSONDecoder()

        guard let parsedResponse = try? decoder.decode(mp4Data.self, from: data) else {
            XCTFail("Unable to parse json response")
            return
        }

        XCTAssertEqual(parsedResponse.url, "https://media0.giphy.com/media/nDSlfqf0gn5g4/giphy-preview.mp4")
    }

    func test_imgData_parsing() throws {
        // Example is fixed_height_still in images.
        let mockData = """
        {
          "height": "152",
          "width": "200",
          "size": "13538",
          "url": "https://media0.giphy.com/media/nDSlfqf0gn5g4/200w_s.gif"
        }
        """

        guard let data = mockData.data(using: .utf8) else {
            XCTFail("Unable get data of json mock string")
            return
        }

        let decoder = JSONDecoder()

        guard let parsedResponse = try? decoder.decode(imgData.self, from: data) else {
            XCTFail("Unable to parse json response")
            return
        }

        XCTAssertEqual(parsedResponse.url, "https://media0.giphy.com/media/nDSlfqf0gn5g4/200w_s.gif")
        XCTAssertEqual(parsedResponse.height, 152)
        XCTAssertEqual(parsedResponse.size, 13538)
        XCTAssertEqual(parsedResponse.width, 200)
    }

    func test_combinedData_parsing() throws {
        // Example is original in Images.
        let mockData = """
        {
          "height": "380",
          "width": "500",
          "size": "489040",
          "url": "https://media0.giphy.com/media/nDSlfqf0gn5g4/giphy.gif",
          "mp4_size": "198396",
          "mp4": "https://media0.giphy.com/media/nDSlfqf0gn5g4/giphy.mp4",
          "webp_size": "260622",
          "webp": "https://media0.giphy.com/media/nDSlfqf0gn5g4/giphy.webp",
          "frames": "6",
          "hash": "aca973fb8cad726e007a9d0b49d69c17"
        }
        """

        guard let data = mockData.data(using: .utf8) else {
            XCTFail("Unable get data of json mock string")
            return
        }

        let decoder = JSONDecoder()

        guard let parsedResponse = try? decoder.decode(combinedData.self, from: data) else {
            XCTFail("Unable to parse json response")
            return
        }

        XCTAssertEqual(parsedResponse.url, "https://media0.giphy.com/media/nDSlfqf0gn5g4/giphy.gif")
        XCTAssertEqual(parsedResponse.mp4Url, "https://media0.giphy.com/media/nDSlfqf0gn5g4/giphy.mp4")
        XCTAssertEqual(parsedResponse.webpUrl, "https://media0.giphy.com/media/nDSlfqf0gn5g4/giphy.webp")
    }
}
