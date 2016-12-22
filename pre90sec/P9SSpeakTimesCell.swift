//
//  P9SSpeakTimesCell.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/19/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class P9SSpeakTimesCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!

    override func awakeFromNib() {
        self.numberLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.numberLabel.layer.borderWidth = 1
    }
}
