//
//  SceneDelegate.swift
//  MyToDoApp
//
//  Created by 이준복 on 2023/02/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let vc = ToDoListViewController()
        let naviVC = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = naviVC
        window?.makeKeyAndVisible()
    }
}
