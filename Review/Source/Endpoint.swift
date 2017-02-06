//
//  Endpoint.swift
//  Review
//
//  Created by Jose Maria Puerta on 6/2/17.
//  Copyright © 2017 Jose Maria Puerta. All rights reserved.
//

import Foundation
import Alamofire

enum Endpoint {
    private var baseURL : URL {
        return URL(string: "http://hello-world.innocv.com/api/")!
    }
    
    case retrieveAllUsers
    case retrieveUser(id: Int)
    case addUser(Parametrizable)
    case updateUser(Parametrizable)
    case removeUser(id: Int)

    var method: Alamofire.HTTPMethod {
        switch self {
        case .retrieveAllUsers:
            return .get
        case .retrieveUser:
            return .get
        case .addUser:
            return .post
        case .updateUser:
            return .post
        case .removeUser:
            return .get
        }
    }
    
    var url: URL {
        switch self {
        case .retrieveAllUsers:
            return baseURL.appendingPathComponent("user/getall")
        case let .retrieveUser(id):
            return baseURL.appendingPathComponent("user/get/\(id)")
        case .addUser:
            return baseURL.appendingPathComponent("user/create")
        case .updateUser:
            return baseURL.appendingPathComponent("user/update")
        case let .removeUser(id):
            return baseURL.appendingPathComponent("user/remove/\(id)")
        }
    }
    
    var encoding: Alamofire.ParameterEncoding {
        switch self {
        case .retrieveUser, .removeUser, .retrieveAllUsers:
            return URLEncoding.default
        case .addUser, .updateUser:
            return JSONEncoding.default
        }
    }
    
    var params: [String : Any] {
        switch self {
        case let .addUser(user):
            return user.params
        case let .updateUser(user):
            return user.params
        default:
            return [:]
        }
    }
    
    var headers: [String : String] {
        var headers = ["Accept" : "application/json"]
        
        switch self {
        case .addUser, .updateUser:
            headers.merge(dict: ["Content-Type" : "application/json"])
        default:
            break
        }
        
        return headers
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
