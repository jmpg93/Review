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
    
    private func request<T>(endpoint: Endpoint) -> SignalProducer<T, NetworkError>  {
        return SignalProducer { observer, disposable in
            Alamofire
                .request(endpoint.url,
                         method: endpoint.method,
                         parameters: endpoint.params,
                         encoding: endpoint.encoding,
                         headers: endpoint.headers)
                .responseJSON(completionHandler: { response in
                    
                    switch response.result {
                    case .failure(let error):
                        if response.response?.statusCode == 200 {
                             observer.sendCompleted()
                        }else {
                            print(error)
                             observer.send(error: .httpError)
                        }
                    case .success(let json):
                        if let value =  json as? T {
                            observer.send(value: value)
                            observer.sendCompleted()
                        } else {
                            observer.send(error: .httpError)
                        }
                    }

                    
                })
            
        }
    }
    
    func retrieveAllUsers() -> SignalProducer<[User], NetworkError> {
        let jsonsRequest: SignalProducer<[JSON], NetworkError> = self.request(endpoint: .retrieveAllUsers)
        return jsonsRequest.map { jsons in jsons.map { User.init(from: $0) } }
    }
    
    func retrieveUser(id: Int) -> SignalProducer<User, NetworkError> {
        return toUserProducer(pro: request(endpoint: .retrieveUser(id: id)))
    }
    
    func addUser(_ user: AddingUser) -> SignalProducer<User, NetworkError> {
        return toUserProducer(pro: request(endpoint: .addUser(user)))
    }
    
    func updateUser(_ user: User) -> SignalProducer<User, NetworkError> {
        return toUserProducer(pro: request(endpoint: .updateUser(user)))
    }
    
    func removeUser(id: Int) -> SignalProducer<Void, NetworkError> {
        return request(endpoint: .removeUser(id: id))
    }
    
    private func toUserProducer(pro: SignalProducer<JSON, NetworkError>) -> SignalProducer<User, NetworkError> {
        return pro.map { User(from: $0) }
    }
}
