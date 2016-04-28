//
//  AppDelegate.swift
//  NorseCourse
//
//  Created by Grant Barnes on 4/12/16.
//  Copyright © 2016 Grant Barnes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(information.preferredCourses, forKey: "prefCourses")
        defaults.setObject(information.requiredCourses, forKey: "reqCourses")
        defaults.setObject(information.preferredSections, forKey: "prefSections")
        defaults.setObject(information.requiredSections, forKey: "reqSections")
        defaults.setObject(information.requiredGenEds, forKey: "reqGenEds")
        defaults.setObject(information.preferredGenEds, forKey: "prefGenEds")
        defaults.setObject(information.savedSchedules, forKey: "savedSchedules")
        defaults.synchronize()

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        let defaults = NSUserDefaults.standardUserDefaults()
        information.preferredSections = defaults.objectForKey("prefSections") as? [[String:AnyObject]] ?? []
        information.requiredSections = defaults.objectForKey("reqSections") as? [[String:AnyObject]] ?? []
        information.preferredCourses = defaults.objectForKey("prefCourses") as? [[String:AnyObject]] ?? []
        information.requiredCourses = defaults.objectForKey("reqCourses") as? [[String:AnyObject]] ?? []
        information.preferredGenEds = defaults.objectForKey("prefGenEds") as? [String] ?? []
        information.requiredGenEds = defaults.objectForKey("reqGenEds") as? [String] ?? []
        information.savedSchedules = defaults.objectForKey("savedSchedules") as? [[[String:String]]] ?? []
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

