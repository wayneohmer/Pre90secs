//
//  P9SSettingsController.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/24/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class P9SSettingsController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProgressImages" || segue.identifier == "InspirationalImages" {
            let vc = segue.destination as! P9SImageController
            vc.isProgressImages = segue.identifier == "ProgressImages"
        }
    }
    
}
