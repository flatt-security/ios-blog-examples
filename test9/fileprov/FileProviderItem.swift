//
//  FileProviderItem.swift
//  fileprov
//
//  Created by Ryota Shiga on 2022/02/16.
//

import FileProvider
import UniformTypeIdentifiers

class FileProviderItem: NSObject, NSFileProviderItem {

    
    let identifier: NSFileProviderItemIdentifier
    let parent: NSFileProviderItemIdentifier
    let name: String
    let type: String
    
    init(itemIdentifier: NSFileProviderItemIdentifier, parentIdentifier: NSFileProviderItemIdentifier, filename: String, typeIdentifier: String) {
        identifier = itemIdentifier
        parent = parentIdentifier
        name = filename
        type = typeIdentifier
        super.init()
    }
    
    var itemIdentifier: NSFileProviderItemIdentifier {
        return identifier
    }
    
    var documentSize: NSNumber? {
        return NSNumber(value: 100)
    }
    
    var parentItemIdentifier: NSFileProviderItemIdentifier {
        return parent
    }
    
    var capabilities: NSFileProviderItemCapabilities {
        return [.allowsReading, .allowsRenaming]
    }
    
    var filename: String {
        return name
    }
    
    var typeIdentifier: String {
        return type
    }
    
    var contentType: UTType {
        return itemIdentifier == NSFileProviderItemIdentifier.rootContainer ? .folder : .plainText
    }
    
}
