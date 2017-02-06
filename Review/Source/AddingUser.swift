//
//  AddingUser.swift
//  Review
//
//  Created by Jose Maria Puerta on 6/2/17.
//  Copyright © 2017 Jose Maria Puerta. All rights reserved.
//

import Foundation

struct AddingUser : Parametrizable {
    let name: String
    let birthdate: Date
    
    private var paramDate: String {
        return User.dateFormatter.string(from: birthdate)
    }
    
    var params: JSON {
        return [
            "name" : name,
            "birthdate" : paramDate
        ]
    }
}
