//
//  DataRequest.swift
//  photoApp
//
//  Created by Kihyun Choi on 2020/06/26.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Foundation

struct SearchRequest {
    let resourceURL:URL
    
    init(searchStr:String, page:Int) {
        let resourceString = "\(Configuration.shared.baseURL)search/photos?page=\(page)&query=\(searchStr)&client_id=\(Configuration.shared.accessKey)"
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
                let response:SearchResult = try JSONDecoder().decode(SearchResult.self, from: jsonData)
                completion(.success(response.results))
            } catch DecodingError.dataCorrupted(let context) {
                print(context)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.valueNotFound(let value, let context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.typeMismatch(let type, let context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        dataTask.resume()
    }
}
