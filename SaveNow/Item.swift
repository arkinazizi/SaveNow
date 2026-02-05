//
//  Item.swift
//  SaveNow
//
//  Created by Arkin Azizi on 25.12.2025.
//

import Foundation
import SwiftData

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
@Model final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
    
    convenience init() {
        self.init(timestamp: Date())
    }
}
