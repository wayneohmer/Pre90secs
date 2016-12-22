//
//  P9SRoundButton.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/19/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class P9SRoundButton: UIButton {
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.borderColor = self.currentTitleColor.cgColor
        self.layer.borderWidth = 2

    }
}
