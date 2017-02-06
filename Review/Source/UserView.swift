//
//  UserView.swift
//  Review
//
//  Created by Jose Maria Puerta on 6/2/17.
//  Copyright © 2017 Jose Maria Puerta. All rights reserved.
//

import Foundation

protocol UserView : class {
    func reload()
    func deleteUser(at: IndexPath)
    func insertUser(at: IndexPath)
    
    func displayAlert(title: String)
}
