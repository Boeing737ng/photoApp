//
//  DataRequest.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/06/25.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Foundation

enum UnsplashError:Error {
    case noDataAvailable
    case canNotProcessData
}

struct DataRequest {
    let resourceURL:URL
    
    init(searchStr:String) {
        let resourceString = "\(Configuration.shared.baseURL)/photos?client_id=\(Configuration.shared.accessKey)"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        self.resourceURL = resourceURL
    }
    
    func getImageData(completion: @escaping(Result<[ImageDetail], UnsplashError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ImageResponse.self, from: jsonData)
                let imageDetails = response.response.images
                completion(.success(imageDetails))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
