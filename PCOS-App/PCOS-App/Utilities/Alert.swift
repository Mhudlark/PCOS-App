//
//  Alert.swift
//  PCOS-App
//
//  Created by Hugh Henry on 29/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import UIKit

class Alert {    
    
    public static func BasicAlert(title: String, message: String, vc: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
        UIAlertAction in
            // Insert code to run on button click below
            self.dismissAlert(alertController: alertController)
        })
        
        vc.present(alertController, animated: true, completion: nil)
    }
    
    public static func dismissAlert(alertController: UIAlertController) {
        alertController.dismiss(animated: true, completion: nil)
    }
}
