//
//  APIController.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum Role: Int, Codable {
    case diner = 1
    case truckOperator
}

let baseURL = URL(string: "https://food-truck-trackr.herokuapp.com/api")

class APIController {
    
    func register(with username: String, password: String, email: String, role: Role, location: String? = "", completion: @escaping (Error?) -> ()) {
        guard let requestURL = baseURL?.appendingPathComponent("auth").appendingPathComponent("register") else {
            completion(NSError())
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        switch role {
        case .diner:
            let consumer = ConsumerSignup(username: username, password: password, role: role.rawValue, location: "")
            do {
                let consumerData = try encoder.encode(consumer)
                request.httpBody = consumerData
            } catch let encodeError {
                completion(encodeError)
                return
            }
        case .truckOperator:
            let vendor = VendorSignup(username: username, password: password, role: role.rawValue)
            do {
                let vendorData = try encoder.encode(vendor)
                request.httpBody = vendorData
            } catch let encodeError {
                completion(encodeError)
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                DispatchQueue.main.async {
                    completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                }
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    func login(with username: String, password: String, role: Role, completion: @escaping (ConsumerLogin?, VendorLogin?, Error?) -> ()) {
        guard let requestURL = baseURL?.appendingPathComponent("auth").appendingPathComponent("login") else {
            completion(nil, nil, NSError())
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        switch role {
        case .diner:
            let consumer = ConsumerLogin(username: username, password: password, role: role.rawValue, bearer: nil)
            do {
                let consumerData = try encoder.encode(consumer)
                request.httpBody = consumerData
            } catch let encodeError {
                completion(nil, nil, encodeError)
                return
            }
        case .truckOperator:
            let vendor = VendorLogin(username: username, password: password, role: role.rawValue, bearer: nil)
            do {
                let vendorData = try encoder.encode(vendor)
                request.httpBody = vendorData
            } catch let encodeError {
                completion(nil, nil, encodeError)
                return
            }
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(nil, nil, NSError())
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, nil, NSError(domain: "", code: 500, userInfo: nil))
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let bearer = try decoder.decode(Bearer.self, from: data)
                switch role {
                case .diner:
                    let consumer = ConsumerLogin(username: username, password: password, role: role.rawValue, bearer: bearer)
                    DispatchQueue.main.async {
                        completion(consumer, nil, nil)
                        return
                    }
                case .truckOperator:
                    let vendor = VendorLogin(username: username, password: password, role: role.rawValue, bearer: bearer)
                    DispatchQueue.main.async {
                        completion(nil, vendor, nil)
                        return
                    }
                }
            } catch let decodeError {
                completion(nil, nil, decodeError)
                return
            }
        }.resume()
    }
}
