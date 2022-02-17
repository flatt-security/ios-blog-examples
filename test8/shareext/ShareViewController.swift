//
//  ShareViewController.swift
//  shareext
//
//  Created by Ryota Shiga on 2022/02/15.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import Social

class ShareViewController: SLComposeServiceViewController {
    var savedItemProvider : NSItemProvider?;

    override func isContentValid() -> Bool {
        let extensionItem: NSExtensionItem = extensionContext?.inputItems.first as! NSExtensionItem;
        print(extensionItem.attachments!)
        let itemProvider = extensionItem.attachments?.first
        let fileUrlId = UTType.fileURL.identifier
        if itemProvider!.hasItemConformingToTypeIdentifier(fileUrlId){
            itemProvider!.loadItem(forTypeIdentifier: fileUrlId,
                                  options: nil,
                                  completionHandler: { (data, error) in
                let url = (data as? URL)!;
                print("Shared file is \(url.path)");
                print("Contents is \(NSData(contentsOf: url)!)");

            })
        }
        return true;
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
