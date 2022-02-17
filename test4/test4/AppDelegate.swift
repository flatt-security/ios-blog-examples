//
//  AppDelegate.swift
//  test4
//
//  Created by Ryota Shiga on 2022/02/10.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Folder is \(NSHomeDirectory())");
        
        let groupID = "group.com.garyo";
        
        //Data sharing using userDefaults
        let userDefaults = UserDefaults(suiteName: groupID);
        userDefaults?.set("TEST", forKey: "KEY");
        
        //File sharing
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID);
        print("Shared folder is \(url!.path)");
        let e = FileManager.default.enumerator(atPath: url!.path);
        while let file = e?.nextObject() as? String{
            print(file);
        }
        do {
            let fileData = try Data(contentsOf: URL(fileURLWithPath: url!.path.appending("/hoge.txt")))
            print(String(data: fileData, encoding: .utf8)!)
        } catch let e{
            print(e);
        }

        do {
            let fileData = try Data(contentsOf: URL(fileURLWithPath: url!.path.appending("/Library/Preferences/\(groupID).plist")))
            //dump(fileData);//contains "TEST" and "KEY"
        } catch let e{
            print(e);
        }
        return true;
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

