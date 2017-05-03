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
        self.tableView.allowsSelectionDuringEditing = true
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertView = UIAlertController(title: "Edit Exersise", message: "", preferredStyle: .alert)
        alertView.addTextField(configurationHandler: { (textfield) in
                textfield.text = P9SGlobals.exersises[indexPath.item]
            })
        alertView.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alertView] _ in
            if let exersiseText = alertView?.textFields?[0].text {
                if exersiseText != "" {
                    P9SGlobals.exersises[indexPath.item] = exersiseText
                    self.tableView.reloadData()
                }
            }
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        self.present(alertView, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            P9SGlobals.exersises.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 
}
