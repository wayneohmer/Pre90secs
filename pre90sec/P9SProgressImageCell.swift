//
//  P9SProgressImageCell.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/24/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class P9SProgressImageCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateField: P9SDateTextField!
    var fileName = ""

    override func awakeFromNib() {
        self.dateField.isShort = true
        self.dateField.layer.borderColor = self.dateField.textColor?.cgColor
        self.dateField.layer.borderWidth = 1
        self.dateField.layer.cornerRadius = 10
        self.dateField.delegate = self
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        P9SGlobals.progressImageDates[self.fileName] = self.dateField.datePicker.date
    }
}
