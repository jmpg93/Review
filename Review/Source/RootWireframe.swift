//
//  RootWireframe.swift
//  Review
//
//  Created by Jose Maria Puerta on 6/2/17.
//  Copyright © 2017 Jose Maria Puerta. All rights reserved.
//

import Foundation
import UIKit

protocol RootWireframe {
    func presentMainView()
}

class RootWireframeiOS : RootWireframe {
    let dependencies: DependenciesiOS
    let window: UIWindow
    var navigationController: UINavigationController!
    
    init(window: UIWindow, dependencies: DependenciesiOS) {
        self.window = window
        self.dependencies = dependencies
        self.navigationController = UINavigationController()
        
        navigationController.isNavigationBarHidden = true
    }
    
    func presentMainView() {
        let vc = dependencies.usersViewController()
        navigationController.viewControllers = [vc]
        window.rootViewController = navigationController
    }
}
