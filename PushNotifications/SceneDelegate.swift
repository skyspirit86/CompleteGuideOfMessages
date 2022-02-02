//
//  SceneDelegate.swift
//  PushNotifications
//
//  Created by Zolt Varga on 01/20/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // print("🔴 \(#function)")
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // print("🔴 \(#function)")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("🔴 \(#function)")
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("🔴 \(#function)")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("🔴 \(#function)")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("🔴 \(#function)")
    }


}

