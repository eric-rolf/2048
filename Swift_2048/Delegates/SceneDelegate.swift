//
//  SceneDelegate.swift
//  Swift_2048
//
//  Created by Rolf, Eric on 7/23/19.
//  Copyright © 2019 Fifth Third Bank. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            //Subclassed HostingController to get keycommands for the scene.
            window.rootViewController = UIKeyCommandHostingController(rootView: GameView())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

