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
    var exersize = ""
    var note = ""

    init() {
    }
    
    init(date:Date, exersize:String, note:String) {
        self.date = date
        self.note = note
        self.exersize = exersize
    }
    
}


