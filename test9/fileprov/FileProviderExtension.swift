//
//  FileProviderExtension.swift
//  fileprov
//
//  Created by Ryota Shiga on 2022/02/16.
//

import FileProvider
import MobileCoreServices
import UniformTypeIdentifiers


class FileProviderExtension: NSFileProviderExtension {
    
    var fileManager = FileManager()
    
    override init() {
        super.init()
        //check the shared file is in test9's app groups folder.
        //print(FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.garyo.test9"));
    }
    
    override func item(for identifier: NSFileProviderItemIdentifier) throws -> NSFileProviderItem {
        // resolve the given identifier to a record in the model
        var filename = "";
        
        // TODO: implement the actual lookup
        if identifier.rawValue.isEqual("id1") {
            filename = "AAA.jpg";
        }else if identifier.rawValue.isEqual("id2"){
            filename = "BBB.txt";
        }
        return FileProviderItem(itemIdentifier: identifier, parentIdentifier: .rootContainer, filename: filename, typeIdentifier: UTType.text.identifier)
    }
    
    override func urlForItem(withPersistentIdentifier identifier: NSFileProviderItemIdentifier) -> URL? {
        // resolve the given identifier to a file on disk
        guard let item = try? item(for: identifier) else {
            return nil
        }
        
        // in this implementation, all paths are structured as <base storage directory>/<item identifier>/<item file name>
        let manager = NSFileProviderManager.default
        let perItemDirectory = manager.documentStorageURL.appendingPathComponent(identifier.rawValue, isDirectory: true)
        
        return perItemDirectory.appendingPathComponent(item.filename, isDirectory:false)
    }
    
    override func persistentIdentifierForItem(at url: URL) -> NSFileProviderItemIdentifier? {
        // resolve the given URL to a persistent identifier using a database
        let pathComponents = url.pathComponents
        
        // exploit the fact that the path structure has been defined as
        // <base storage directory>/<item identifier>/<item file name> above
        assert(pathComponents.count > 2)
        
        return NSFileProviderItemIdentifier(pathComponents[pathComponents.count - 2])
        //return NSFileProviderItemIdentifier(pathComponents[pathComponents.count - 1])
    }
    
    override func providePlaceholder(at url: URL, completionHandler: @escaping (Error?) -> Void) {
        guard let identifier = persistentIdentifierForItem(at: url) else {
            completionHandler(NSFileProviderError(.noSuchItem))
            return
        }

        do {
            let fileProviderItem = try item(for: identifier)
            let placeholderURL = NSFileProviderManager.placeholderURL(for: url)
            try fileManager.createDirectory(atPath: placeholderURL.path, withIntermediateDirectories: true, attributes: nil)
            /*
            createDirectory(withName: identifier.rawValue,
                                      inParentItemIdentifier: NSFileProviderItemIdentifier.rootContainer,
                                      completionHandler:  {_,_ in
                do {
                    try NSFileProviderManager.writePlaceholder(at: placeholderURL,withMetadata: fileProviderItem);
                    completionHandler(nil);
                } catch let error {
                    dump(error);
                    completionHandler(error);
                }
            })
             */
            completionHandler(nil);
        } catch let error {
            dump(error);
            completionHandler(error);
        }
    }

    override func startProvidingItem(at url: URL, completionHandler: @escaping ((_ error: Error?) -> Void)) {
        // Should ensure that the actual file is in the position returned by URLForItemWithIdentifier:, then call the completion handler
        
        //Fake download files
        //same as downloading AAA.jpg/BBB.txt whose contents is CCCC
        FileManager.default.createFile(
            atPath: url.path,
            contents: "CCCC".data(using: .utf8)
        );
        completionHandler(NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo:[:]))
    }
    
    
    override func itemChanged(at url: URL) {
        // Called at some point after the file has changed; the provider may then trigger an upload
        
        /* TODO:
         - mark file at <url> as needing an update in the model
         - if there are existing NSURLSessionTasks uploading this file, cancel them
         - create a fresh background NSURLSessionTask and schedule it to upload the current modifications
         - register the NSURLSessionTask with NSFileProviderManager to provide progress updates
         */
    }
    
    override func stopProvidingItem(at url: URL) {
        // Called after the last claim to the file has been released. At this point, it is safe for the file provider to remove the content file.
        // Care should be taken that the corresponding placeholder file stays behind after the content file has been deleted.
        
        // Called after the last claim to the file has been released. At this point, it is safe for the file provider to remove the content file.
        
        // TODO: look up whether the file has local changes
        let fileHasLocalChanges = false
        
        if !fileHasLocalChanges {
            // remove the existing file to free up space
            do {
                _ = try FileManager.default.removeItem(at: url)
            } catch {
                // Handle error
            }
            
            // write out a placeholder to facilitate future property lookups
            self.providePlaceholder(at: url, completionHandler: { error in
                // TODO: handle any error, do any necessary cleanup
            })
        }
    }
    
    // MARK: - Actions
    
    /* TODO: implement the actions for items here
     each of the actions follows the same pattern:
     - make a note of the change in the local model
     - schedule a server request as a background task to inform the server of the change
     - call the completion block with the modified item in its post-modification state
     */
    
    // MARK: - Enumeration
    
    override func enumerator(for containerItemIdentifier: NSFileProviderItemIdentifier) throws -> NSFileProviderEnumerator {
        /*
         let maybeEnumerator: NSFileProviderEnumerator? = nil
        if (containerItemIdentifier == NSFileProviderItemIdentifier.rootContainer) {
            // TODO: instantiate an enumerator for the container root
        } else if (containerItemIdentifier == NSFileProviderItemIdentifier.workingSet) {
            // TODO: instantiate an enumerator for the working set
        } else {
            // TODO: determine if the item is a directory or a file
            // - for a directory, instantiate an enumerator of its subitems
            // - for a file, instantiate an enumerator that observes changes to the file
        }
        guard let enumerator = maybeEnumerator else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo:[:])
        }
        return enumerator
        */
        let maybeEnumerator: NSFileProviderEnumerator?
        if (containerItemIdentifier == NSFileProviderItemIdentifier.rootContainer) {
            maybeEnumerator = FileProviderEnumerator(enumeratedItemIdentifier: containerItemIdentifier)
        } else if (containerItemIdentifier == NSFileProviderItemIdentifier.workingSet) {
            maybeEnumerator = FileProviderEnumerator(enumeratedItemIdentifier: containerItemIdentifier)
            // TODO: instantiate an enumerator for the working set
        } else {
            // TODO: determine if the item is a directory or a file
            // - for a directory, instantiate an enumerator of its subitems
            // - for a file, instantiate an enumerator that observes changes to the file
            maybeEnumerator = FileProviderEnumerator(enumeratedItemIdentifier: containerItemIdentifier)
        }
        guard let enumerator = maybeEnumerator else {
            throw NSError(domain: NSCocoaErrorDomain, code: NSFeatureUnsupportedError, userInfo:[:])
        }
        return enumerator
    }
    
}
