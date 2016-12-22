//
//  P9SLogEntryController.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/20/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class P9SLogEntryController: UITableViewController {

    @IBOutlet var headerView: UIView!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var addExersizeButton: UIButton!
    @IBOutlet weak var dateTextView: P9SDateTextField!
    
    var selectedIndexes = Set<IndexPath>()
    var thisEntry = P9SlogEntry()
    var isManualEntry = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNoteButton.layer.borderColor = self.addNoteButton.currentTitleColor.cgColor
        self.addNoteButton.layer.borderWidth = 2
        self.addNoteButton.layer.cornerRadius = 10
        self.addExersizeButton.layer.borderColor = self.addExersizeButton.currentTitleColor.cgColor
        self.addExersizeButton.layer.borderWidth = self.addNoteButton.layer.borderWidth
        self.addExersizeButton.layer.cornerRadius = self.addNoteButton.layer.cornerRadius
        
        if isManualEntry {
            self.dateTextView.text = ""
            self.dateTextView.isUserInteractionEnabled = true
            self.dateTextView.becomeFirstResponder()            
        } else {
            if let logEnry = P9SGlobals.log.last {
                self.thisEntry = logEnry
            }
            self.dateTextView.text = "\(self.thisEntry.date.formattedDate()) \(self.thisEntry.date.formattedTime())"
        }
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = UIView()
        
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
        return P9SGlobals.exersizes.count
    }
    @IBAction func addNoteTouched(_ sender: Any) {
        
        let alertView = UIAlertController(title: "Note", message: "", preferredStyle: .alert)
        alertView.addTextField(configurationHandler: { textField in
            textField.keyboardAppearance = .dark
            textField.autocorrectionType = .yes
            textField.text = self.thisEntry.note
        })
        alertView.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alertView] _ in
            if let noteText = alertView?.textFields?[0].text {
                self.thisEntry.note = noteText
            }
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        self.present(alertView, animated: true, completion: nil)

    }

    @IBAction func newExersizetouched(_ sender: UIButton) {
        
        let alertView = UIAlertController(title: "New Exersize", message: "", preferredStyle: .alert)
        alertView.addTextField(configurationHandler: nil)
        alertView.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alertView] _ in
            if let exersizeText = alertView?.textFields?[0].text {
                if exersizeText != "" {
                    P9SGlobals.exersizes.append(exersizeText)
                    P9SGlobals.exersizes.sort()
                    if let newIndex = P9SGlobals.exersizes.index(of: exersizeText) {
                        let indexPath = IndexPath(item: newIndex, section: 0)
                        self.selectedIndexes.update(with: indexPath)
                    }
                    self.tableView.reloadData()
                }
            }
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

        self.present(alertView, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = UITableViewCell()
        
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = P9SGlobals.exersizes[indexPath.item]
        if selectedIndexes.contains(indexPath) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if self.selectedIndexes.contains(indexPath) {
            self.selectedIndexes.remove(indexPath)
            cell?.accessoryType = .none
        } else {
            self.selectedIndexes.update(with: indexPath)
            cell?.accessoryType = .checkmark
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func saveTuched(_ sender: UIBarButtonItem) {
        
        var exersises = ""
        for indexPath in self.selectedIndexes {
            exersises += "\(P9SGlobals.exersizes[indexPath.item]), "
        }
        if exersises != "" {
            self.thisEntry.exersize = exersises.substring(to: exersises.index(exersises.endIndex, offsetBy: -2))
        }
        if self.isManualEntry {
            self.thisEntry.date = self.dateTextView.datePicker.date
            P9SGlobals.log.append(self.thisEntry)
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            P9SGlobals.log[P9SGlobals.log.count-1] = self.thisEntry
            self.performSegue(withIdentifier: "DetailEntryExit", sender: nil)
        }
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
            // Delete the row from the data source
            P9SGlobals.exersizes.remove(at: indexPath.row)
            self.selectedIndexes.remove(indexPath)
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
