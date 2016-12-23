//
//  P9SEditExersisesController.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/22/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class P9SEditExersisesController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var headerView: UIView!
    @IBOutlet var exersiseField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = UIView()
        self.tableView.isEditing = true
        self.addButton.layer.borderColor = self.addButton.currentTitleColor.cgColor
        self.addButton.layer.cornerRadius = 10
        self.addButton.layer.borderWidth = 2
    }

    @IBAction func addButtonTouched(_ sender: UIButton) {
        if exersiseField.text != "" {
            if !P9SGlobals.exersises.contains(exersiseField.text!) {
                P9SGlobals.exersises.append(exersiseField.text!)
                P9SGlobals.exersises.sort()
                self.tableView.reloadData()
            }
            exersiseField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.addButtonTouched(self.addButton)
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return P9SGlobals.exersises.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Exersise", for: indexPath)

        cell.textLabel?.text = P9SGlobals.exersises[indexPath.item]
        cell.textLabel?.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            P9SGlobals.exersises.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
