//
//  File.swift
//  PCOS-App
//
//  Created by Hugh Henry on 21/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import UIKit

class Login {
    
    // Login Message - 2 stands for LOGIN
    // Eg: "2^"+ID+"%"+Password;
    
    // Encrypt password but not username
    
    public static func Login(messageElements: [String], vc: UIViewController) -> Bool {
        
        let message = messageElements.joined(separator: "%")
                
        let sendMessage = "2^" + message
                
        let response = ServerRequest.stream(sendMessage: sendMessage)
        
        if(response == "N/A" || response == "Unknown Error Type." || response == "Unsuccessful login. Account does not exist." || response == "Unsuccessful login. Password is incorrect.")
        {
            
            // Display modal saying reason for not being able to login
            var alertMessage = (response == "N/A" || response == "Unknown Error Type.")
                ? "Unknown Error." : response
            alertMessage += " Please try again."
            Alert.BasicAlert(title: "Login Failed", message: alertMessage, vc: vc)
            
            return false
        }
        return true
    }
}
