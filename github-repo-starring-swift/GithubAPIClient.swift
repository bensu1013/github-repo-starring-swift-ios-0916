//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

struct GithubAPIClient {
    
    static func getRepositories(with completion: @escaping ([Any]) -> ()) {
        let urlString = "\(baseAPISite)/repositories?client_id=\(githubClientID)&client_secret=\(githubClientSecret)"
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }) 
        task.resume()
    }
    
    static func checkIfRepositoryIsStarred(_ fullName: String, completion: @escaping (Bool) -> () ) {
        let urlString = "\(baseAPISite)/user/starred/\(fullName)"
        let url = URL(string: urlString)
        
        guard let uUrl = url else { return }
        
        var urlRequest = URLRequest(url: uUrl)
        urlRequest.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard data != nil else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 204 {
                completion(true)
            } else {
                completion(false)
            }
            
            
        }
        task.resume()
    }
    
    static func starRepository(named: String, completion: @escaping () -> () ) {
    
        let urlString = "\(baseAPISite)/user/starred/\(named)"
        let url = URL(string: urlString)
        
        guard let uUrl = url else { return }
        
        var urlRequest = URLRequest(url: uUrl)
        urlRequest.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("0", forHTTPHeaderField: "Content-Length")
        urlRequest.httpMethod = "PUT"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            completion()
            
        }
        task.resume()
    }
    
    static func unstarRepository(named: String, completion: @escaping () -> () ) {
        
        let urlString = "\(baseAPISite)/user/starred/\(named)"
        let url = URL(string: urlString)
        
        guard let uUrl = url else { return }
        
        var urlRequest = URLRequest(url: uUrl)
        urlRequest.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "DELETE"
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            completion()
            
        }
        task.resume()
        
    }
    
    
    
    
}













