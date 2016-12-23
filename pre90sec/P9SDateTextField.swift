//
//  P9SDateTextField.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/21/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class P9SDateTextField: UITextField {

    let datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initDatePicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initDatePicker()

    }
    
    func initDatePicker() {
        
        let toolBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        let navItem = UINavigationItem()
        toolBar.barStyle = .black
        toolBar.barTintColor = UIColor.darkGray
        toolBar.tintColor = UIColor.white
        toolBar.isTranslucent = true
        
        navItem.title = "Date"
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonTouched))
        navItem.leftBarButtonItem = doneButton
        toolBar.items = [navItem]
        self.inputAccessoryView = toolBar
        
        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.addTarget(self, action: #selector(self.dateUpdated), for: .valueChanged)
        self.datePicker.maximumDate = Date()
        self.inputView = self.datePicker
        self.text = Date().formatedDateTime()
        
    }
    
    func dateUpdated(datePicker:UIDatePicker) {
        self.text = datePicker.date.formatedDateTime()
    }
    
    func doneButtonTouched() {
        self.resignFirstResponder()
    }
    
}
