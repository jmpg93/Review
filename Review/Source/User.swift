//
//  User.swift
//  Review
//
//  Created by Jose Maria Puerta on 6/2/17.
//  Copyright © 2017 Jose Maria Puerta. All rights reserved.
//

import Foundation

struct User : Parametrizable {
    static let dateFormatter = UserDateFormatter()
    
    let id: Int
    let name: String
    let birthdate: Date
    
    init(id: Int, name: String, birthdate: Date) {
        self.id = id
        self.name = name
        self.birthdate = birthdate
    }
    
    init(from json: JSON) {
        guard let name = json["name"] as? String,
            let id = json["id"] as? Int,
            let date = json["birthdate"] as? String else {
                fatalError()
        }
        
        self.birthdate = User.dateFormatter.date(from: date)!
        self.id = id
        self.name = name
    }
    
    private var paramDate: String {
        return User.dateFormatter.string(from: birthdate)
    }
    
    var params: JSON {
        return [
            "name" : name,
            "id": id,
            "birthdate" : paramDate
        ]
    }
}

