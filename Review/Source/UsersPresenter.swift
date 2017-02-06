//
//  UsersPresenter.swift
//  Review
//
//  Created by Jose Maria Puerta on 6/2/17.
//  Copyright © 2017 Jose Maria Puerta. All rights reserved.
//

import Foundation
import ReactiveSwift

class UsersPresenter {
    unowned let view: UserView
    let wireframe: RootWireframe
    
    private var users: [User]
    
    let networkController: NetworkController
    
    var usersCount: Int {
        return users.count
    }
    
    init(view: UserView, wireframe: RootWireframe, networkController: NetworkController) {
        self.view = view
        self.wireframe = wireframe
        self.users = []
        self.networkController = networkController
    }
    
    func user(at indexPath: IndexPath) -> User {
        return users[indexPath.row]
    }
    
    func addUser(_ user: AddingUser) {
        networkController
            .addUser(user)
            .observe(on: UIScheduler())
            .startWithResult { result in
                switch result {
                case let .success(user):
                    self.users += [user]
                    self.view.insertUser(at: IndexPath(row: self.users.endIndex - 1, section: 0))
                case let .failure(error):
                    print(error)
                }
        }
    
    }
    
    func updateUser(_ user: User, at indexPath: IndexPath) {
        networkController
            .updateUser(user)
            .observe(on: UIScheduler())
            .startWithCompleted {
                self.users[indexPath.row] = user
                self.view.reload()
        }
    }
    
    func removeUser(at indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        networkController
            .removeUser(id: user.id)
            .observe(on: UIScheduler())
            .startWithCompleted {
                self.users.remove(at: indexPath.row)
                self.view.deleteUser(at: indexPath)
            }
    }
    
    func updateUsers() {
        networkController
            .retrieveAllUsers()
            .observe(on: UIScheduler())
            .startWithResult { result in
                switch result {
                case let .success(users):
                    self.users = users
                    self.view.reload()
                case let .failure(error):
                    print(error)
                }
        }
    }
}
