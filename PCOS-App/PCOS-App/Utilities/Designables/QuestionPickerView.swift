//
//  questionPickerView.swift
//  PCOS-App
//
//  Created by Hugh Henry on 29/7/20.
//  Copyright © 2020 Hugh Henry. All rights reserved.
//

import UIKit

class QuestionPickerView: NSObject, UIPickerViewDelegate, UIPickerViewDataSource, Question{
    
    public var dataSourceArray = [String]()
    
    var currentValue : String = ""
    var currentValueIndex : Int = 0
    
    public func MakeDelegateAndDataSource(_ pickerView: UIPickerView) {
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    public func setData(_ data: [String]) { dataSourceArray = data }
    
    func getAnswer() -> String {
        return self.currentValue
    }
    
    func getAnswerIndex() -> Int {
        return self.currentValueIndex
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentValueIndex = row
        currentValue = dataSourceArray[row] as String
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSourceArray.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSourceArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

}
