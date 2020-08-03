//
//  LoginViewController.swift
//  PCOS-App
//
//  Created by Hugh Henry on 20/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var loginBarButton: UIBarButtonItem!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.delegate = self
        passwordTextField.delegate = self

        // Making login button invalid because text fields are empty
        updateLoginButtonState()
    }
    
    
    //MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func LoginBarButton(_ sender: UIBarButtonItem) {
        loginUser()
    }
    
    @IBAction func LoginButton(_ sender: UIButton) {
        loginUser()
    }
    
    //MARK: UITextFieldDelegate
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Login button while editing.
        disableLogin()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // Check to see whether any text was entered - to validate login button
        updateLoginButtonState()
    }
    
    //MARK: Private Methods
    
    private func loginUser() {
        
        let messageElements: [String] = [
            usernameTextField.text ?? "",
            passwordTextField.text ?? ""
        ]
        
        // Login to Account
        if(!(Login.Login(messageElements: messageElements, vc: self))) { return }
        
        LocalStorage.StoreUsername(usernameTextField.text ?? "")
        
        let storyboard = UIStoryboard(name: "Questionnaire", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "menu") as UIViewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
        
    }

    private func updateLoginButtonState() {
        // Disable the Login button if the text field is empty.
        
        if (usernameTextField.text ?? "").isEmpty {
            disableLogin()
            return
        }

        if (passwordTextField.text ?? "").isEmpty {
            disableLogin()
            return
        }

        enableLogin()
    }
    
    private func enableLogin() {
        loginBarButton.isEnabled = true
        loginButton.SetEnabled(enabled: true)
    }

    private func disableLogin(){
        loginBarButton.isEnabled = false
        loginButton.SetEnabled(enabled: false)
    }
}
