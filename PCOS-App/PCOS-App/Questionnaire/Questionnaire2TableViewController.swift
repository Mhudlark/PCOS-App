//
//  QuestionnaireTableViewController.swift
//  PCOS-App
//
//  Created by Hugh Henry on 31/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import UIKit

class Questionnaire2TableViewController: QuestionnaireTableViewController {
    
    @IBOutlet weak var goodDayRating: UISlider!
    
    @IBOutlet weak var goodDayDescriptionTextView: DesignableTextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionnaire = 2
    }
    
    //MARK: - Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        returnToQuestionnaireMenu()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else { return }
        
        // Get question answers and values
        questionsandAnswers.append("\(goodDayDescriptionTextView.text ?? "")")        
        questionsandAnswers.append("\(Int(roundf(goodDayRating.value)))")
    }
    
    //MARK: - Private Methods
    
    private func returnToQuestionnaireMenu() {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInShowMode = presentingViewController is UINavigationController
        
        // Only works when presenting a modal (Modal) view on top of navigation controller
        if(isPresentingInShowMode){
            dismiss(animated: true, completion: nil)
        }
        // only works when showing (Show) a new view (on top of navigation stack)
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("Current controller is not inside a navigation controller.")
        }
    }
    
    private func selectAllRows() {
        for section in 0...self.tableView.numberOfSections {
            for row in 0...self.tableView.numberOfRows(inSection: section) {
//                let cell = selectCell(section, row)
            }
        }
    }
    
    private func selectCell(_ section: Int, _ row: Int) -> UITableViewCell? {
        return self.tableView.cellForRow(at: IndexPath(row: row, section: section))
    }
}
