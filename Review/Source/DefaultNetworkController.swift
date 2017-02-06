//
//  DefaultNetworkController.swift
//  Review
//
//  Created by Jose Maria Puerta on 6/2/17.
//  Copyright © 2017 Jose Maria Puerta. All rights reserved.
//

import Foundation
import ReactiveSwift
import Alamofire

class DefaultNetworkController : NetworkController {
    let endpoint: String = "hello-world.innocv.com/api/"
    
    private func request(endpoint: Endpoint) -> SignalProducer<[JSON], NetworkError>  {
        return SignalProducer { observer, disposable in
            Alamofire.request(endpoint.url,
                              method: endpoint.method,
                              parameters: endpoint.params,
                              encoding: endpoint.encoding,
                              headers: endpoint.headers)
                .responseJSON(completionHandler: { response in
                    
                    if let json = response.result.value as? JSON {
                        if let type =  json["$type"] as? String, type.range(of: "Error") != nil {
                            observer.send(error: .httpError)
                            return
                        } else {
                            observer.send(value: [json])
                        }
                        
                    } else if let jsons = response.result.value as? [JSON] {
                        observer.send(value: jsons)
                    }
                    
                    observer.sendCompleted()
                })
            
        }
    }
    
    func retrieveAllUsers() -> SignalProducer<[User], NetworkError> {
        return request(endpoint: .retrieveAllUsers)
            .map({ $0.map(User.init) })
    }
    
    func retrieveUser(id: Int) -> SignalProducer<User, NetworkError> {
        return request(endpoint: .retrieveUser(id: id))
            .filter({ !$0.isEmpty })
            .map({ User(from: $0.first!) })
    }
    
    func addUser(_ user: AddingUser) -> SignalProducer<User, NetworkError> {
        return request(endpoint: .addUser(user))
            .filter({ !$0.isEmpty })
            .map({ User(from: $0.first!) })
    }
    
    func updateUser(_ user: User) -> SignalProducer<User, NetworkError> {
        return request(endpoint: .updateUser(user))
            .filter({ !$0.isEmpty })
            .map({ User(from: $0.first!) })
    }
    
    func removeUser(id: Int) -> SignalProducer<Void, NetworkError> {
        return request(endpoint: .removeUser(id: id))
            .map({
                _ in ()
            })
    }
}
