//
//  RegisterTableViewController.swift
//  PCOS-App
//
//  Created by Hugh Henry on 23/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import UIKit

class RegisterTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    
    @IBOutlet weak var registerBarButton: UIBarButtonItem!
    
    @IBOutlet weak var pcosDiagnosisSwitch: UISwitch!
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dobDatePicker.preferredDatePickerStyle = UIDatePickerStyle.compact
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        // Making register button invalid because text fields are empty
        updateRegisterButtonState()
    }
    
    //MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerBarButtonClicked(_ sender: UIBarButtonItem) {
        registerUser()
    }
    
    @IBAction func pcosDiagnosisSwitchChanged(_ sender: UISwitch) {
//        self.pcosDiagnosis = sender.isOn
        updateRegisterButtonState()
    }
    
    //MARK: - UITextFieldDelegate
    
    //MARK: + Properties
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    //MARK: + Actions
    
    @IBAction func usernameTextFieldChanged(_ sender: UITextField) {
        updateRegisterButtonState()
    }
    
    
    @IBAction func passwordTextFieldChanged(_ sender: UITextField) {
        updateRegisterButtonState()
    }
    
    @IBAction func passwordTextFieldEdited(_ sender: UITextField) {
        updateRegisterButtonState()
    }
    
    @IBAction func confirmPasswordTextFieldEdited(_ sender: UITextField) {
        updateRegisterButtonState()
    }
    
    @IBAction func confirmPasswordTextFieldChanged(_ sender: UITextField) {
        updateRegisterButtonState()
    }
    
    //MARK: - UIDatePickerDelegate
    
    //MARK: + Properties
    
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    
    @IBOutlet weak var firstStudyVisitDatePicker: UIDatePicker!
    
    @IBOutlet weak var secondStudyVisitDatePicker: UIDatePicker!
    
    @IBOutlet weak var thirdStudyVisitDatePicker: UIDatePicker!
    
    //MARK: + Actions
    
    @IBAction func dobPickerChanged(_ sender: UIDatePicker) {
        updateRegisterButtonState()
    }
    
    @IBAction func firstStudyVisitDatePickerChanged(_ sender: UIDatePicker) {
        updateRegisterButtonState()
    }
    
    @IBAction func secondStudyVisitDatePickerChanged(_ sender: UIDatePicker) {
        updateRegisterButtonState()
    }
    
    @IBAction func thirdStudyVisitDatePickerChanged(_ sender: UIDatePicker) {
        updateRegisterButtonState()
    }
    
    //MARK: - Private Methods
    
    private func registerUser() {
        
        if !updateRegisterButtonState() { return }
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yyyy"
        
        let messageElements: [String] = [
            String(usernameTextField.text ?? ""),
            String(passwordTextField.text ?? ""),
            yearFormatter.string(from: dobDatePicker.date),
            dateFormatter.string(from: firstStudyVisitDatePicker.date),
            dateFormatter.string(from: secondStudyVisitDatePicker.date),
            dateFormatter.string(from: thirdStudyVisitDatePicker.date),
            pcosDiagnosisSwitch.isOn == true ? "Confirmed" : "Not Confirmed"
        ]
        
        // Register Account
        if(!(Register.Register(messageElements: messageElements, vc: self))) {
            print("Could not move to login page")
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "login") as UIViewController
        
        self.navigationController?.show(viewController, sender: self)
    }

    private func updateRegisterButtonState() -> Bool {
        
        // Making sure there username is filled
        let username = String(usernameTextField.text ?? "")
        if(username.isEmpty){
            disableRegisterButton()
            return false
        }
        
        // Making sure there password is filled
        let password = String(passwordTextField.text ?? "")
        if(password.isEmpty){
            disableRegisterButton()
            return false
        }
        
        // Making sure there confirm password is filled
        let confirmPassword = String(confirmPasswordTextField.text ?? "")
        if(confirmPassword.isEmpty){
            disableRegisterButton()
            return false
        }
        
        // Making sure passwords match
        guard confirmPassword == password else {
            // Maybe create modal saying passwords don't match
            Alert.BasicAlert(title: "Error", message: "The passwords do not match", vc: self)
            
            disableRegisterButton()
            return false
        }
        
        // Making sure DOB has been entered (not today)
        if(Int(dobDatePicker.date.distance(to: Date())) < 86000){
            disableRegisterButton()
            return false
        }
        
        // Enabling buttons - if all requirements met
        enableRegisterButton()
        return true
    }
    
    private func enableRegisterButton() {
        registerBarButton.isEnabled = true
    }

    private func disableRegisterButton() {
        registerBarButton.isEnabled = false
    }

}



