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
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        P9SGlobals.writeDefaults()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        P9SGlobals.writeDefaults()
    }

}

