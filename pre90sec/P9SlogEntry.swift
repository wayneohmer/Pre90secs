//
//  P9SlogEntry.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/20/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

struct P9SlogEntry  {
    
    var date = Date()
    var exersises = ""
    var note = ""

    init() {
    }
    
    init(date:Date, exersises:String, note:String) {
        self.date = date
        self.note = note
        self.exersises = exersises
    }
    
}


