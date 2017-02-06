//
//  UserPresenter.swift
//  Review
//
//  Created by Jose Maria Puerta on 6/2/17.
//  Copyright © 2017 Jose Maria Puerta. All rights reserved.
//

import Foundation

protocol UsersPresenter {
    var usersCount: Int { get }
    
    func user(at indexPath: IndexPath) -> User
    func filterUsers(by string: String)
    
    func reloadUsers()
    func addUser(_ user: AddingUser)
    func updateUser(_ user: User, at indexPath: IndexPath)
    func removeUser(at indexPath: IndexPath)
    
}
