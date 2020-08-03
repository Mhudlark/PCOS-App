//
//  IPConfig.swift
//  PCOS-App
//
//  Created by Hugh Henry on 22/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import Foundation

class IPConfig {
    
    private static let ipAddress = "192.168.1.56"
    private static let port = Int32(3456)
    
    public static func getIPAddress() -> String
    {
        return self.ipAddress
    }
    
    public static func getPort() -> Int32{
        return self.port
    }
}
