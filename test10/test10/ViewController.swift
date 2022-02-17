//
//  ViewController.swift
//  test10
//
//  Created by Ryota Shiga on 2022/02/16.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ViewController: UIViewController {
    var pickerController : UIDocumentPickerViewController?;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        self.pickerController = UIDocumentPickerViewController(documentTypes: [UTType.image.identifier, UTType.plainText.identifier], in: .open)
        self.pickerController!.delegate = self
        self.present(self.pickerController!, animated: true)
    }

}

extension ViewController: UIDocumentPickerDelegate {
        public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let documentURL = urls[0];
            //↓ can also be used for startAccessingSecurityScopedResource (注釈内容の検証)
            //let documentURL = URL(fileURLWithPath: "/private/var/mobile/Containers/Shared/AppGroup/657DAE6E-CDE0-4317-9FD2-9E2E4CAD1873/File Provider Storage/id2/BBB.txt");
            print("documentURL is \(documentURL)");
            dump(NSData(contentsOf: documentURL));
            
            let shouldStopAccessing = documentURL.startAccessingSecurityScopedResource()
            dump(NSData(contentsOf: documentURL));
            //Check that NSFileProviderItemCapabilities.allowsReading is not for security.
            FileHandle(forWritingAtPath: documentURL.path)?.write("XXXX".data(using: .utf8)!);
            dump(NSData(contentsOf: documentURL));
            
            defer {
                if shouldStopAccessing {
                    documentURL.stopAccessingSecurityScopedResource()
                    dump(NSData(contentsOf: documentURL));
                }
            }
        }
}

