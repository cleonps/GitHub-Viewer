//
//  AppDelegate.swift
//  GitHub Viewer
//
//  Created by Christian León Pérez Serapio on 18/01/20.
//  Copyright © 2020 christianleon. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let titleFont = UIFont(name: "Avenir-heavy", size: 18),
            let backFont = UIFont(name: "Avenir-heavy", size: 0),
            let barFont = UIFont(name: "Avenir-book", size: 14) {
            let backColor: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.clear]
            let backAppearance = UIBarButtonItem.appearance()
            
            backAppearance.setTitleTextAttributes(backColor, for: .normal)
            backAppearance.setTitleTextAttributes(backColor, for: .highlighted)
            backAppearance.setTitleTextAttributes(backColor, for: .selected)
            backAppearance.setTitleTextAttributes([.font: backFont], for: .normal)
            backAppearance.setTitleTextAttributes([.font: backFont], for: .highlighted)
            backAppearance.setTitleTextAttributes([.font: backFont], for: .selected)
            
            UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
            UITabBarItem.appearance().setTitleTextAttributes([.font: barFont], for: .normal)
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let items = components.queryItems else {
            return false
        }
        
        self.window?.rootViewController?.dismiss(animated: true)
        
        if let code = items.first, code.name == "code", let value = code.value {
            if !KeychainWrapper.standard.set(value, forKey: .code) {
                return false
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("CodeObtained"), object: nil)
            
            return true
        }
        
        return false
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}
