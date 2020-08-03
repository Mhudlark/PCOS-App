//
//  SubmitData.swift
//  PCOS-App
//
//  Created by Hugh Henry on 28/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import UIKit

class SubmitData {
    
    // Submit Data Message - 3 stands for SEND_DATA
    // Eg: "3^"+ID+"%"+MESSAGE;
    
    // Encrypt password but not username
    
    public static func SubmitData(messageElements: [String], vc: UIViewController) -> Bool {
        
        let message = messageElements.joined(separator: "%")
                
        let sendMessage = "3^" + message
                
        let response = ServerRequest.stream(sendMessage: sendMessage)
        
        if(response == "Sent & Received")
        {
            return true
        }
        
        // Display modal saying reason for not being able to login
        var alertMessage = (response == "N/A" || response == "Unknown Error Type.")
            ? "Unknown Error." : response + " Please try again."
        Alert.BasicAlert(title: "Submit Failed", message: alertMessage, vc: vc)
        
        return false
    }
}
