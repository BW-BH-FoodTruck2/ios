//
//  APIController.swift
//  FoodTruckTracker
//
//  Created by Chad Rutherford on 1/7/20.
//  Copyright © 2020 Lamdba School. All rights reserved.
//

import CoreData
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
    
    func register(with username: String, password: String, role: Role, location: String? = "", completion: @escaping (Error?) -> ()) {
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
            let consumer = ConsumerLogin(username: username, password: password, role: role.rawValue)
            do {
                let consumerData = try encoder.encode(consumer)
                request.httpBody = consumerData
            } catch let encodeError {
                completion(nil, nil, encodeError)
                return
            }
        case .truckOperator:
            let vendor = VendorLogin(username: username, password: password, role: role.rawValue)
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
                    let consumer = ConsumerLogin(id: bearer.id, username: username, password: password, role: role.rawValue, bearer: bearer)
                    DispatchQueue.main.async {
                        completion(consumer, nil, nil)
                        return
                    }
                case .truckOperator:
                    let vendor = VendorLogin(id: bearer.id, username: username, password: password, role: role.rawValue, bearer: bearer)
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
    
    func fetchAllTrucks(bearer: Bearer, completion: @escaping ([TruckRepresentation]?, Error?) -> ()) {
        guard let requestURL = baseURL?.appendingPathComponent("trucks") else {
            completion(nil, NSError())
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(bearer.token, forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                DispatchQueue.main.async {
                    completion(nil, NSError())
                }
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, NSError())
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let trucksData = try decoder.decode([TruckRepresentation].self, from: data)
                DispatchQueue.main.async {
                    completion(trucksData, nil)
                }
            } catch let decodeError {
                DispatchQueue.main.async {
                    completion(nil, decodeError)
                    return
                }
            }
        }.resume()
    }
    
    func fetchTruck(for id: Int, with bearer: Bearer, completion: @escaping (TruckRepresentation?, Error?) -> ()) {
        guard let requestURL = baseURL?.appendingPathComponent("trucks").appendingPathComponent("\(id)") else {
            completion(nil, NSError())
            return
        }
        
        print(requestURL)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue(bearer.token, forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                print(response.statusCode)
                DispatchQueue.main.async {
                    completion(nil, NSError())
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, NSError())
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let truck = try decoder.decode(TruckRepresentation.self, from: data)
                DispatchQueue.main.async {
                    completion(truck, nil)
                }
            } catch let decodeError {
                DispatchQueue.main.async {
                    completion(nil, decodeError)
                }
                return
            }
        }.resume()
    }
    
    func addTruck(truck: TruckRepresentation, with bearer: Bearer, completion: @escaping (Error?) -> ()) {
        guard let requestURL = baseURL?.appendingPathComponent("trucks") else {
            completion(NSError())
            return
        }
        print(requestURL)
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(bearer.token, forHTTPHeaderField: "authorization")
        
        
        let encoder = JSONEncoder()
        do {
            let truckData = try encoder.encode(truck)
            request.httpBody = truckData
        } catch let encodeError {
            print(encodeError)
            completion(encodeError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                print(response.statusCode)
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    func updateTruck(truck: TruckRepresentation, with bearer: Bearer, completion: @escaping (Error?) -> ()) {
        guard let id = truck.id, let requestURL = baseURL?.appendingPathComponent("trucks").appendingPathComponent("\(id)") else {
            completion(NSError())
            return
        }
        
        print(requestURL)
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(bearer.token, forHTTPHeaderField: "authorization")
        
        let encoder = JSONEncoder()
        do {
            let truckData = try encoder.encode(truck)
            request.httpBody = truckData
        } catch let encodeError {
            completion(encodeError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    func deleteTruck(_ truck: TruckRepresentation, with bearer: Bearer, completion: @escaping (Error?) -> ()) {
        guard let id = truck.id, let requestURL = baseURL?.appendingPathComponent("trucks").appendingPathComponent("\(id)") else {
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(bearer.token, forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 201 {
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    func addFavorite(truck: TruckRepresentation, with dinerID: Int, bearer: Bearer, completion: @escaping(Error?) -> ()) {
        guard let id = truck.id, let requestURL = baseURL?.appendingPathComponent("favoritetrucks") else {
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue(bearer.token, forHTTPHeaderField: "authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        do {
            let favoriteTruck = FavoriteTruckRepresentation(dinerID: dinerID, truckID: id)
            let favoriteData = try encoder.encode(favoriteTruck)
            request.httpBody = favoriteData
        } catch let encodeError {
            completion(encodeError)
            return
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
                    completion(NSError())
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchFavorites(for diner: ConsumerLogin, with bearer: Bearer, completion: @escaping (Error?) -> ()) {
        guard let id = diner.id, let requestURL = baseURL?.appendingPathComponent("favoritetrucks").appendingPathComponent("\(id)") else {
            completion(NSError())
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(bearer.token, forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let favoriteTrucks = try decoder.decode([FavoriteTruckRepresentation].self, from: data)
                let moc = CoreDataStack.shared.container.newBackgroundContext()
                moc.perform {
                    for truck in favoriteTrucks {
                        FavoriteTruck(dinerID: Int64(truck.dinerID), truckID: Int64(truck.truckID))
                    }
                }
                try CoreDataStack.shared.save(context: moc)
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let decodeError {
                DispatchQueue.main.async {
                    completion(decodeError)
                    return
                }
            }
        }.resume()
    }
}
