//
//  GiphyApi.swift
//  GiphPicker
//
//  Created by Michael Grundy on 3/4/22.
//
// Giphy API documentation available at:
// https://developers.giphy.com/docs/api#quick-start-guide

import Combine
import Foundation
import OSLog

struct GiphyApiConfig {
    // TODO Put in your API key (until I put in a secrets loader)
    var apiKey: String = "Put your APIKey here"
    var resultsLimit: Int = 25
    var rating: String = "G"
    var lang: String = NSLocale.current.languageCode ?? "en"
}

class GiphyApi: ObservableObject {
    @Published var queryString = ""
    @Published var searchResults: [GifData] = []
    var apiConfig: GiphyApiConfig
    var subscriptions: Set<AnyCancellable> = []
    var trendingUrl: URLComponents
    var searchUrl: URLComponents
    var apiSession: URLSession
    var sessionConfig: URLSessionConfiguration
    let sessionLog = Logger()

    init(config: GiphyApiConfig) {
        let apiBase = "https://api.giphy.com"
        let searchPath = "/v1/gifs/search"
        let trendPath = "/v1/gifs/trending"

        apiConfig = config
        searchUrl = URLComponents(string: apiBase)!
        searchUrl.queryItems = [
            URLQueryItem(name: "api_key", value: apiConfig.apiKey),
            URLQueryItem(name: "rating", value: apiConfig.rating),
            URLQueryItem(name: "lang", value: apiConfig.lang)
        ]
        trendingUrl = searchUrl
        searchUrl.path = searchPath
        trendingUrl.path = trendPath

        sessionConfig = URLSessionConfiguration.default
        apiSession = URLSession(configuration: sessionConfig)

        $queryString
            .debounce(for: .milliseconds(700), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink(receiveValue: {query in
                if query.isEmpty {return}
                self.getSearchResults(for: query)
            })
            .store(in: &subscriptions)

        // Populate startup results
        getTrendingGifs()
    }

    convenience init() {
        self.init(config: GiphyApiConfig())
    }

    /// Sets up fetchGifData() for Trending gifs. Our default state gifs.
    func getTrendingGifs() {
        var workingComponents = trendingUrl
        workingComponents.queryItems?.append(URLQueryItem(name: "limit", value: String(10)))
        workingComponents.queryItems?.append(URLQueryItem(name: "offset", value: String(0)))

        // Put in a check instead of forcing
        fetchGifData(url: workingComponents.url!)

    }

    /// Sets up fetchGifData to pull results for search string
    /// - Parameters:
    ///   - searchString: String() search value
    ///   - offset: defaults to 0, index of batches of 25 results.
    func getSearchResults(for searchString: String, offset: Int = 0) {
        var workingComponents = searchUrl
        workingComponents.queryItems?.append(URLQueryItem(name: "limit", value: String(25)))
        workingComponents.queryItems?.append(URLQueryItem(name: "offset", value: String(offset)))
        workingComponents.queryItems?.append(URLQueryItem(name: "q", value: searchString))

        sessionLog.debug("searching for \(searchString)")
        if let url = workingComponents.url {
            fetchGifData(url: url)
        } else {
            sessionLog.error("URL nil for \(searchString)")
        }

    }


    func fetchGifData(url: URL) {
        let task = apiSession.dataTask(with: url) { data, response, error in
            guard let httpsResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpsResponse.statusCode),
                  let data = data else {
                      self.sessionLog.error("https resonse code not in 200s")
                      return
                  }

            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(GifSearchResponse.self, from: data) else {
                self.sessionLog.error("Couldn't decode API response \(String(describing: error))")
                return
            }

            DispatchQueue.main.async {
                self.searchResults = response.data
                self.sessionLog.debug("Search returned \(response.data.count) results.")
            }
        }

        task.resume()

    }
}

