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

class APIController {
    private let baseURL = URL(string: "https://food-truck-trackr.herokuapp.com/api")
    
    func register(with username: String, password: String, email: String, role: Role, location: String? = "", completion: @escaping (Error?) -> ()) {
        guard let requestURL = baseURL?.appendingPathComponent("auth").appendingPathComponent("register") else {
            completion(NSError())
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        let encoder = JSONEncoder()
        switch role {
        case .diner:
            let consumer = ConsumerSignup(username: username, password: password, email: email, role: role)
            do {
                let consumerData = try encoder.encode(consumer)
                request.httpBody = consumerData
            } catch let encodeError {
                completion(encodeError)
                return
            }
        case .truckOperator:
            let vendor = VendorSignup(username: username, password: password, email: email, role: role)
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
        let encoder = JSONEncoder()
        switch role {
        case .diner:
            let consumer = ConsumerLogin(username: username, password: password, role: role)
            do {
                let consumerData = try encoder.encode(consumer)
                request.httpBody = consumerData
            } catch let encodeError {
                completion(nil, nil, encodeError)
                return
            }
        case .truckOperator:
            let vendor = VendorLogin(username: username, password: password, role: role)
            do {
                let vendorData = try encoder.encode(vendor)
                request.httpBody = vendorData
            } catch let encodeError {
                completion(nil, nil, encodeError)
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, nil, NSError())
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let bearer = try decoder.decode(Bearer.self, from: data)
                    switch role {
                    case .diner:
                        let consumer = ConsumerLogin(username: username, password: password, role: role, bearer: bearer)
                        DispatchQueue.main.async {
                            completion(consumer, nil, nil)
                            return
                        }
                    case .truckOperator:
                        let vendor = VendorLogin(username: username, password: password, role: role, bearer: bearer)
                        DispatchQueue.main.async {
                            completion(nil, vendor, nil)
                            return
                        }
                    }
                } catch let decodeError {
                    completion(nil, nil, decodeError)
                    return
                }
            }
        }.resume()
    }
}
