//
//  ViewController.swift
//  test6
//
//  Created by Ryota Shiga on 2022/02/14.
//

import UIKit

class ViewController: UIViewController {
    var controller: UIDocumentInteractionController?
    //var controller: UIActivityViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        //create NSTemporaryDirectory()+"XXX.txt"
        //and write "AAAA" to it. (saved in application container)
        //NSTemporaryDirectory() == NSHomeDirectory()+"/tmp/"
        let filePath = NSTemporaryDirectory().appending("XXX.txt");
        let url = URL(
            fileURLWithPath: filePath
        );
        FileManager.default.createFile(
            atPath: url.path,
            contents: "AAAA".data(using: .utf8)
        );
        /*
        FileManager.default.createFile(
            atPath: NSTemporaryDirectory().appending("XXX2.txt"),
            contents: "BBBB".data(using: .utf8)
        );
        */
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            FileHandle(forWritingAtPath: url.path)!.write("BBBB".data(using: .utf8)!);
        }
        print("Sharing file is \(filePath)");
        controller = UIDocumentInteractionController.init(url: url);
        //controller = UIDocumentInteractionController.init(url: URL(fileURLWithPath: "/usr/libexec/transitd"));
        controller?.presentOpenInMenu(
            from: view.frame,
            in: view, animated: true
        );//ここでtest7等を選択する
        
        /*
        controller = UIActivityViewController.init(activityItems: ["AAAA"], applicationActivities: nil)
        self.present(controller!, animated: true, completion: nil)
         */
    }
}

