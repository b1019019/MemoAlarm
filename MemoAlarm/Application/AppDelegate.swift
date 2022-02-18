//
//  AppDelegate.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/11/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){ (granted, _) in
            if granted {
                UNUserNotificationCenter.current().delegate = self
            }
        }
        
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        self.window = newWindow
        Router.showRoot(window: window)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("terminate!!")
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate{
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       completionHandler([.banner, .list, .sound])
       var viewController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController

       for e in viewController.viewControllers {
           if let v = e as? ViewController {
               v.alarmTableView.reloadData()
           } else {
               print(e)
           }
       }
       //vc.alarmTableView.reloadData()
       
   }
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
       completionHandler()
   }
}
