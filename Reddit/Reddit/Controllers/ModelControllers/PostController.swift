//
//  PostController.swift
//  Reddit
//
//  Created by Trevor Bursach on 9/23/20.
//

import Foundation
import UIKit.UIImage

struct StringConstants {
    fileprivate static let baseURL = "https://www.reddit.com"
    fileprivate static let rEndpoint = "r"
    fileprivate static let funnyEndpoint = "funny"
    fileprivate static let jsonExtension = "json"
}

class PostController {
    
    
    static func fetchPosts(completion: @escaping (Result <[Post], PostError>) -> Void) {
        
        guard let baseURL = URL(string: StringConstants.baseURL) else { return completion(.failure(.invalidURL)) }
        let rComponentURL = baseURL.appendingPathComponent(StringConstants.rEndpoint)
        let funnyComponentURL = rComponentURL.appendingPathComponent(StringConstants.funnyEndpoint)
        let finalURL = funnyComponentURL.appendingPathExtension(StringConstants.jsonExtension)
        // Always print final url
        print(finalURL)
        // Data Task
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                let secondLevelDictionary = topLevelDictionary.data
                let thirdLevelObjects = secondLevelDictionary.children
                
                var postsPlaceholderArray: [Post] = []
                
                for object in thirdLevelObjects {
                    let post = object.data
                    postsPlaceholderArray.append(post)
                }
                completion(.success(postsPlaceholderArray))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchThumbnailFor(post: Post, completion: @escaping (Result <UIImage, PostError>) -> Void) {
        guard let url = post.thumbnail else { return completion(.failure(.invalidURL)) }
        print(url)
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else { return completion(.failure(.noData)) }
            guard let thumbnailImage = UIImage(data: data) else { return completion(.failure(.unableToDecode)) }
            
            completion(.success(thumbnailImage))
        }.resume()
    }
} // END OF CLASS
