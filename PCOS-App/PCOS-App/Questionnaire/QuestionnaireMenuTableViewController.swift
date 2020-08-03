//
//  QuestionnaireMenuTableViewController.swift
//  PCOS-App
//
//  Created by Hugh Henry on 28/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import UIKit

class QuestionnaireMenuTableViewController: UITableViewController {
    
    //MARK: - Properties
    
    var questionnairesQuestionsAndAnswers = [[String]]()
    let questionnaires = 3
    var questionnairsCompleted = [false, false, false]
    
    @IBOutlet weak var submitBarButton: UIBarButtonItem!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var q1Completed: UIImageView!
    
    @IBOutlet weak var q2Completed: UIImageView!
    
    @IBOutlet weak var q3Completed: UIImageView!
    
    //MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        updateSubmitButton()
    }
    
    //MARK: - Actions
    
    @IBAction func logoutBarButtonClicked(_ sender: UIBarButtonItem) {
        
        // Logout of Account
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "welcome") as UIViewController
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func submitBarButtonClicked(_ sender: UIBarButtonItem) {
        submitData()
    }
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        submitData()
    }
    
    @IBAction func unwindToQuestionnaire(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? QuestionnaireTableViewController {
            
            questionnairsCompleted[sourceViewController.questionnaire - 1] = true
            updateSubmitButton()
            
            updateQuestionnaireAnswers(questionnaire: sourceViewController.questionnaire, answers: sourceViewController.questionsandAnswers)
        }
    }
    
    //MARK: - Private Methods
    private func submitData() {
        
        var stringData = ""
        
        for q in 0..<questionnairesQuestionsAndAnswers.count {
            
            let questionnaire = questionnairesQuestionsAndAnswers[q]
            
            for question in 0..<questionnaire.count {
                stringData += "q\(q + 1)_\(question)_"
                stringData += questionnaire[question]
                stringData += "$"
            }
        }
        
        let storedUsername = LocalStorage.LoadUsername()
        if(storedUsername == "") {
            print("There is no username stored - You are not logged in.")
            return
        }
        
        stringData = stringData == "" ? "N/A$" : stringData
        
        stringData = "\(storedUsername)%" + stringData
        
        let finalStringData = stringData.prefix(stringData.count - 1)
        
        if(SubmitData.SubmitData(messageElements: [String(finalStringData)], vc: self)) {
            Alert.BasicAlert(title: "Data Submitted", message: "(You will able be able submit data again in 24 hrs)", vc: self)
        }
    }
    
    public func updateQuestionnaireAnswers(questionnaire: Int, answers: [String]){
        if(questionnairesQuestionsAndAnswers.count < self.questionnaires){
            for _ in 0..<self.questionnaires {
                questionnairesQuestionsAndAnswers.append([String]())
            }
        }
        questionnairesQuestionsAndAnswers[questionnaire - 1] = answers
    }
    
    private func updateSubmitButton() {
        // Checking all questionnaires have been completed
        var check = true
        for i in 0..<questionnairsCompleted.count {
            let boolean = questionnairsCompleted[i]
            check = boolean
            updateCompletedCheckboxes(qCompleted: i + 1, completed: boolean)
        }
        
        // All questionnaires have been completed, allow user to submit answers
        if check { enableSubmit() }
        // Not all questionnaires have been completed, prevent user from submitting answers
        else { disableSubmit() }
    }
    
    private func updateCompletedCheckboxes(qCompleted: Int, completed: Bool) {
        switch qCompleted {
            case 1:
                SetImageVisibility(image: q1Completed, completed)
            case 2:
                SetImageVisibility(image: q2Completed, completed)
            case 3:
                SetImageVisibility(image: q3Completed, completed)
            default:
                break
        }
    }
    
    private func SetImageVisibility(image: UIImageView, _ visible: Bool) {
        image.isHidden = !visible
    }
    
    private func disableSubmit() {
        submitButton.isEnabled = false;
//        submitButton.SetEnabled(enabled: false)
        submitBarButton.isEnabled = false
    }
    
    private func enableSubmit() {
        submitButton.isEnabled = true
//        submitButton.SetEnabled(enabled: true)
        submitBarButton.isEnabled = true
    }
    
}
