//
//  LocalStorage.swift
//  PCOS-App
//
//  Created by Hugh Henry on 29/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import UIKit

class LocalStorage {
    
    //MARK: Archiving Paths
     
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("appData")
    
    struct Keys {
        static let user = "user"
    }
    
    public static func StoreString(_ key: String, _ value: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }

    public static func LoadString(_ key: String) -> String {
        let defaults = UserDefaults.standard
        if let value = defaults.string(forKey: key) {
            return value
        }
        return ""
    }
    
    public static func StoreUsername(_ username: String) {
        StoreString(Keys.user, username)
    }
    
    public static func LoadUsername() -> String {
        return LoadString(Keys.user)
    }
}
