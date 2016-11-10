//
//  AppDelegate.swift
//  
//  Sputnik_BuildD
//
//  Created by Mini Panton on 11/7/16.
//  Copyright © 2016 Some Feelers. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: Application State

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
    
    // MARK: Orientation

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if self.window?.rootViewController?.presentedViewController is SecondViewController {
            
            let secondController = self.window!.rootViewController!.presentedViewController as! SecondViewController
            
            if secondController.isPresented {
                return UIInterfaceOrientationMask.landscape;
            } else {
                return UIInterfaceOrientationMask.all;
            }
        } else {
            return UIInterfaceOrientationMask.all;
        }
        
    }
}

