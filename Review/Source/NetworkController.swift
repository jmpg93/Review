//
//  NetworkController.swift
//  Review
//
//  Created by Jose Maria Puerta on 6/2/17.
//  Copyright © 2017 Jose Maria Puerta. All rights reserved.
//

import Foundation
import ReactiveSwift

typealias JSON = [String : Any]

protocol NetworkController {
    func retrieveAllUsers() -> SignalProducer<[User], NetworkError>
    func retrieveUser(id: Int) -> SignalProducer<User, NetworkError>
    
    func addUser(_ user: AddingUser) -> SignalProducer<User, NetworkError>
    func updateUser(_ user: User) -> SignalProducer<User, NetworkError>
    
    func removeUser(id: Int) -> SignalProducer<Void, NetworkError>
}
