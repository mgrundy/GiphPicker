//
//  GifSearchResponse.swift
//  GiphPicker
//
//  Created by Michael Grundy on 3/4/22.
//

// For a full example Json response from an API call see gphy.json in the UnitTests folder
struct GifSearchResponse: Codable {
    let data: [GifData]
}
extension GifSearchResponse {
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct GifData: Codable, Identifiable  {
    let id: String
    let title: String
    let images: Images
}
extension GifData {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case images
    }
}

struct Images: Codable {
    let original: combinedData
    let preview: mp4Data
    let fixedStill: imgData
}
extension Images {
    enum CodingKeys: String, CodingKey {
        case original
        case preview
        case fixedStill = "fixed_width_still"
    }
}

// You'll see some attributes commented out from here on down. This is because Giphy returns Int data as strings.
// Since I'm not using those attributes it's not necessary to go through the explicit decoding I show in the
// imgData init(). (Yeah, I know, weird flex) I left them in (for now at least) in case I want to do something
// like compare file sizes between the file types.
struct mp4Data: Codable {
//  let height: Int
//  let width: Int
//  let mp4Size: Int
    let url: String
}
extension mp4Data {
    enum CodingKeys: String, CodingKey {
//      case height
//      case width
//      case mp4Size = "mp4_size"
        case url = "mp4"
    }
}
struct imgData: Codable {
    let height: Int
    let width: Int
    let size: Int
    let url: String
}
extension imgData {
    enum CodingKeys: String, CodingKey {
        case height
        case width
        case size
        case url
    }
    // The json coming back from Giphy has ints as strings, so we have to resort to manual parse.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .url)
        let heightString = try container.decode(String.self, forKey: .height)
        height = Int(heightString) ?? 0
        let widthString = try container.decode(String.self, forKey: .width)
        width = Int(widthString) ?? 0
        let sizeString = try container.decode(String.self, forKey: .size)
        size = Int(sizeString) ?? 0
    }
}
struct combinedData: Codable {
//  let height: Int
//  let width: Int
//  let size: Int
    let url: String
//  let mp4Size: Int
    let mp4Url: String
//  let webpSize: Int
    let webpUrl: String
}
extension combinedData {
    enum CodingKeys: String, CodingKey {
//      case height
//      case width
//      case size
        case url
        case mp4Url = "mp4"
//      case mp4Size = "mp4_size"
        case webpUrl = "webp"
//      case webpSize = "webp_size"
    }
}

struct testImages: Codable {
    let fixedStill: imgData
}
extension testImages {
    enum CodingKeys: String, CodingKey {
        case fixedStill = "fixed_width_still"
    }
}
