//
//  ImageDownload.swift
//
//  Created by Michael Grundy on 3/22/22.
//

import Foundation
import OSLog

class AssetDownload: NSObject, ObservableObject {
    var downloadTask: URLSessionDownloadTask?
    var downloadUrl: URL?
    @Published var localUrl: URL?
    @Published var downloadLocation: URL?
    @Published var idString: URL?
    var id: String?
    let sessionLog = Logger()


    lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    func downloadFromUrl(_ url: URL) {
        downloadUrl = url
        if let downloadUrl = downloadUrl {
            downloadTask = urlSession.downloadTask(with: downloadUrl)
            downloadTask?.resume()
        }
    }
}

extension AssetDownload: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let fileManager = FileManager.default
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            sessionLog.error("unable to obtain documentsPath")
            fatalError()
        }
        guard let downloadUrl = downloadUrl else {
            // overkill, but we shouldn't be hitting a blank url here
            sessionLog.error("downloadUrl was nil")
            fatalError()
        }
        let destinationUrl = documentsPath.appendingPathComponent(downloadUrl.lastPathComponent)

        do {
            if fileManager.fileExists(atPath: destinationUrl.path) {
                // remove old file before moving in new one
                try fileManager.removeItem(at: destinationUrl)
            }
            try fileManager.copyItem(at: location, to: destinationUrl)
            DispatchQueue.main.async {
                self.downloadLocation = destinationUrl
            }
        } catch {
            print("AssetDownload \(error)")
        }
    }
}
