//
//  P9SFinishedWordsController.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/19/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit
import AVFoundation

class P9SFinishedWordsController: UIViewController {

    @IBOutlet weak var wordsLabel: UITextField!
    let speechSynthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var testButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wordsLabel.text = P9SGlobals.finishedWords

    }

    @IBAction func doneTouched(_ sender: UIBarButtonItem) {
        P9SGlobals.finishedWords = self.wordsLabel.text!
        self.performSegue(withIdentifier: "unwindToTimer", sender: nil )
    }
    
    @IBAction func testTouched(_ sender: UIButton) {
        speechSynthesizer.speak(AVSpeechUtterance(string:self.wordsLabel.text!))

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
