//
//  AppDelegate.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/15/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let documentDirectory = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])"
        do {
            try FileManager.default.createDirectory(atPath: "\(documentDirectory)/inspirationalImages", withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("could not create inspirationalImages direcory \(error.description)")
        }
        do {
            try FileManager.default.createDirectory(atPath: "\(documentDirectory)/progressImages", withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("could not create progressImages direcory \(error.description)")
        }
        var imageData = UIImagePNGRepresentation(UIImage(named: "Josh1.png")!)
        do {
            try imageData!.write(to: URL(fileURLWithPath:"\(documentDirectory)/inspirationalImages/Josh1.png"), options: .atomic)
        } catch {
            print("Josh1 not saved")
        }
        imageData = UIImagePNGRepresentation(UIImage(named: "Josh2.png")!)
        do {
            try imageData!.write(to: URL(fileURLWithPath:"\(documentDirectory)/inspirationalImages/Josh2.png"), options: .atomic)
        } catch {
            print("Josh2 not saved")
        }
        imageData = UIImagePNGRepresentation(UIImage(named: "Josh3.png")!)
        do {
            try imageData!.write(to: URL(fileURLWithPath:"\(documentDirectory)/inspirationalImages/Josh3.png"), options: .atomic)
        } catch {
            print("Josh3 not saved")
        }
        P9SGlobals.readDefaults()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        P9SGlobals.writeDefaults()

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        P9SGlobals.writeDefaults()
    }


}

