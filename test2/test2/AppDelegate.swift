//
//  AppDelegate.swift
//  test2
//
//  Created by Ryota Shiga on 2022/02/09.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //let name = String(cString: getpwuid(getuid())!.pointee.pw_name!);
        let folder = NSHomeDirectory();
        //print("User is \(name)\nFolder is \(folder)");
        print("Folder is \(folder)");
        let result1 = opendir(folder);//self
        let uuidForTest1 = "CCB54883-932A-4E6A-87C5-FA0A048A0137";//should be modified after installing test1
        let basePath = URL(fileURLWithPath: folder).deletingLastPathComponent().path
        let result2 = opendir("\(basePath)/\(uuidForTest1)");
        print("opendir(\"\(folder)\") == \(result1)\nopendir(\"\(basePath)\(uuidForTest1)\") == \(result2)");
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


}

