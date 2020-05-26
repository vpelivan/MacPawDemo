//
//  NetworkManager.swift
//  MacPaw
//
//  Created by Victor Pelivan on 5/14/20.
//  Copyright © 2020 Victor Pelivan. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Using Singleton Pattern for creating a universal single API request manager

class NetworkService {
    static let shared = NetworkService() // One of conditions of Singleton (Allows accessing a class without creating a class instance)
    private let apiKey = "20f127c2-e474-4193-b83a-d435377693ae" // The key, that I got during the catapi.com registration
    private let animations = Animations()
    public var imageCache = NSCache<NSString, UIImage>() //Image Cache Class
    private init() {} // One of conditions of Singleton (Allows keeping a class in a single example)
    
    
    // MARK: - Using A Generic Argument in this method to be able to create universal function for parsing any model type with completion handler closure escaping condition
    public func getData<T: Decodable>(into type: T.Type, from url: URL, completion: @escaping (Any) -> ()) {
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 20)
        request.httpMethod = "GET"
        request.setValue(self.apiKey, forHTTPHeaderField: "x-api-key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                do
                {
                    print("Status code: ", httpResponse.statusCode)
                    guard let data = data else { return }
                    let decodedData = try JSONDecoder().decode(type.self, from: data)
                    completion(decodedData)
                }
                catch let error {
                    print(error.localizedDescription)
                }
            } else {
                let alertMessage = "For some reasons the request could not be performed"
                self.alert(withTitle: "Request Error", message: alertMessage)
                return
            }
        }
        task.resume()
    }
    
    //MARK: - Next method performs image load request in case if it is not cached already, and if it is cached, it just pulls it from cache
    public func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            request.httpMethod = "GET"
            request.setValue(self.apiKey, forHTTPHeaderField: "x-api-key")
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    guard let data = data, let image = UIImage(data: data) else { return }
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        completion(image)
                } else {
                    let alertMessage = "For some reasons the request could not be performed"
                    self.alert(withTitle: "Request Error", message: alertMessage)
                    return
                }
            }
            task.resume()
        }
    }
    
    //MARK: - This method is supposed to be used to avoid image shuffling during tableView cell image loading. The main idea is to cancel the URLSession task being performed during prepareForReuse() method in custom cell class, so the correct image should be loaded from API or cache, when scrolling the tableView. It also saves traffic
    public func downloadCellImage(url string: String, id: String, completion: @escaping (UIImage, URL?) -> ()) -> URLSessionDataTask? {
        
        var task: URLSessionDataTask?
        
        if let catURL = URL(string: "https://api.thecatapi.com/v1/images/search?breed_id=\(id)") {
            getData(into: [CatModel].self, from: catURL) { (data) in
                guard let catData = data as? [CatModel],
                    let imageURLString = catData.first?.url,
                    let imageURL = URL(string: imageURLString)
                    else { return }
                if let cachedImage = self.imageCache.object(forKey: imageURL.absoluteString as NSString) {
                    completion(cachedImage, imageURL)
                } else {
                    var request = URLRequest(url: imageURL, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
                    request.httpMethod = "GET"
                    request.setValue(self.apiKey, forHTTPHeaderField: "x-api-key")
                    task = URLSession.shared.dataTask(with: request) {
                        (data, response, error) in
                        if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                            guard let data = data, let image = UIImage(data: data) else { return }
                            self.imageCache.setObject(image, forKey: imageURL.absoluteString as NSString)
                                completion(image, imageURL)
                        } else {
                            let alertMessage = "For some reasons the request could not be performed"
                            self.alert(withTitle: "Request Error", message: alertMessage)
                            return
                        }
                    }
                    task?.resume()
                }
            }
        }
        return task
    }

    //MARK: - This alert shows in case if the response status code is not valid for loading data
    private func alert(withTitle title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        ac.addAction(ok)
        UIApplication.topViewController()?.present(ac, animated: true)
    }
}
