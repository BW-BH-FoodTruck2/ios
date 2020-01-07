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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let encoder = JSONEncoder()
        switch role {
        case .diner:
            let consumer = ConsumerSignup(username: username, password: password, email: email, role: role.rawValue, location: "")
            print(consumer)
            do {
                let consumerData = try encoder.encode(consumer)
                request.httpBody = consumerData
            } catch let encodeError {
                completion(encodeError)
                return
            }
        case .truckOperator:
            let vendor = VendorSignup(username: username, password: password, email: email, role: role.rawValue)
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
    
    func login(with username: String, password: String, role: Role, completion: @escaping (ConsumerLogin?, VendorLogin?, Bearer?, Error?) -> ()) {
        guard let requestURL = baseURL?.appendingPathComponent("auth").appendingPathComponent("login") else {
            completion(nil, nil, nil, NSError())
            return
        }
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HTTPMethod.post.rawValue
        let encoder = JSONEncoder()
        switch role {
        case .diner:
            let consumer = ConsumerLogin(username: username, password: password, role: role.rawValue)
            do {
                let consumerData = try encoder.encode(consumer)
                request.httpBody = consumerData
            } catch let encodeError {
                completion(nil, nil, nil, encodeError)
                return
            }
        case .truckOperator:
            let vendor = VendorLogin(username: username, password: password, role: role.rawValue)
            do {
                let vendorData = try encoder.encode(vendor)
                request.httpBody = vendorData
            } catch let encodeError {
                completion(nil, nil, nil, encodeError)
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil, nil, nil, error)
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, nil, nil, NSError())
                    }
                    return
                }
                print(data)
                let decoder = JSONDecoder()
                do {
                    let bearer = try decoder.decode(Bearer.self, from: data)
                    switch role {
                    case .diner:
                        let consumer = ConsumerLogin(username: username, password: password, role: role.rawValue)
                        DispatchQueue.main.async {
                            completion(consumer, nil, bearer, nil)
                            return
                        }
                    case .truckOperator:
                        let vendor = VendorLogin(username: username, password: password, role: role.rawValue)
                        DispatchQueue.main.async {
                            completion(nil, vendor, bearer, nil)
                            return
                        }
                    }
                } catch let decodeError {
                    completion(nil, nil, nil, decodeError)
                    return
                }
            }
        }.resume()
    }
}
