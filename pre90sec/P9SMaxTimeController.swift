//
//  P9SMaxTimeController.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/20/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class P9SMaxTimeController: UIViewController {

    @IBOutlet weak var maxTimeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.maxTimeField.text = "\(P9SGlobals.maxtime)"

    }
    
    @IBAction func saveToched(_ sender: UIBarButtonItem) {
        
        if let maxtime = Int(self.maxTimeField.text!) {
            P9SGlobals.maxtime = maxtime
            for time in P9SGlobals.spokenTimes {
                if time > maxtime {
                    P9SGlobals.spokenTimes.remove(time)
                }
            }
        }
        self.performSegue(withIdentifier: "unwindToTimer" , sender:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
