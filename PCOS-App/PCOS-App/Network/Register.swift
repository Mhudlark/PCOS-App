//
//  Register.swift
//  PCOS-App
//
//  Created by Hugh Henry on 28/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import UIKit

class Register {
    
    // Register Message - 1 stands for register
    // Eg: "1^\(ID)%\(Password)%\(YearBirth)%\(FirstVisit)%\(Date1)%\(Date2)%\(TextRadio)"
    
    // Encrypt password but not username
    
    public static func Register(messageElements: [String], vc: UIViewController) -> Bool {
        
        let message = messageElements.joined(separator: "%")
        
        let sendMessage = "1^" + message
        
        let response = ServerRequest.stream(sendMessage: sendMessage)
        
        if(response == "N/A" || response == "Unknown Error Type." || response == "Unsuccessful register. Account with this username already exists.")
        {
            // Display modal saying reason for not being able to register
            var alertMessage = (response == "N/A" || response == "Unknown Error Type.")
                ? "Unknown Error." : response
            alertMessage += " Please try again."
            Alert.BasicAlert(title: "Register Failed", message: alertMessage, vc: vc)
            
            return false
        }
        
        return true
    }
}
