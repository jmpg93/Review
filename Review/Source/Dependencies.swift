//
//  Dependencies.swift
//  Review
//
//  Created by Jose Maria Puerta on 6/2/17.
//  Copyright © 2017 Jose Maria Puerta. All rights reserved.
//

import Foundation
import UIKit

class SharedDependencies {
    
    lazy var networkController: NetworkController = {
        DefaultNetworkController()
    }()
    
    func usersPresenter(view: UserView, wireframe: RootWireframe) -> UsersPresenter {
        return UsersPresenter(view: view, wireframe: wireframe, networkController: networkController)
    }
}

class DependenciesiOS : SharedDependencies {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    lazy var rootWireframe: RootWireframe = {
        RootWireframeiOS(window: self.window, dependencies: self)
    }()
    
    func usersViewController() -> UsersViewController {
        let view = UsersViewController.initFromStoryboard()
        view.userPresenter = super.usersPresenter(view: view, wireframe: rootWireframe)
        return view
    }
}
