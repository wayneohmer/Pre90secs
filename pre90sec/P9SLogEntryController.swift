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
    @IBOutlet weak var addexersiseButton: UIButton!
    @IBOutlet weak var dateTextView: P9SDateTextField!
    
    var selectedExersises = Set<String>()
    var thisEntry = P9SlogEntry()
    var isManualEntry = false
    var isEdit = false
    var editIndex = Int(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNoteButton.layer.borderColor = self.addNoteButton.currentTitleColor.cgColor
        self.addNoteButton.layer.borderWidth = 2
        self.addNoteButton.layer.cornerRadius = 10
        self.addexersiseButton.layer.borderColor = self.addexersiseButton.currentTitleColor.cgColor
        self.addexersiseButton.layer.borderWidth = self.addNoteButton.layer.borderWidth
        self.addexersiseButton.layer.cornerRadius = self.addNoteButton.layer.cornerRadius
        
        if isManualEntry {
            self.dateTextView.isUserInteractionEnabled = true
            self.dateTextView.becomeFirstResponder()
        } else if isEdit {
            self.thisEntry = P9SGlobals.log[self.editIndex]
            self.dateTextView.isUserInteractionEnabled = true
            let exersises = self.thisEntry.exersises.components(separatedBy: ", ")
            for exersise in exersises {
                if exersise != "" {
                    self.selectedExersises.update(with: exersise)
                }
            }
            self.dateTextView.datePicker.date = self.thisEntry.date
            self.dateTextView.text = self.thisEntry.date.formatedDateTime()
            self.fixNoteButtonTitle()
        } else {
            if let logEnry = P9SGlobals.log.last {
                self.thisEntry = logEnry
            }
            self.dateTextView.text = "\(self.thisEntry.date.formattedDate()) \(self.thisEntry.date.formattedTime())"
        }
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = UIView()
        
    }
    
    func fixNoteButtonTitle() {
        if thisEntry.note != "" {
            self.addNoteButton.setTitle("   Edit Note   ", for: .normal)
        } else {
            self.addNoteButton.setTitle("   Add Note   ", for: .normal)
        }
    }
    
    @IBAction func addNoteTouched(_ sender: Any) {
        
        self.dateTextView.resignFirstResponder()
        let alertView = UIAlertController(title: "Note", message: "", preferredStyle: .alert)
        alertView.addTextField(configurationHandler: { textField in
            textField.keyboardAppearance = .dark
            textField.autocorrectionType = .yes
            textField.text = self.thisEntry.note
        })
        alertView.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alertView] _ in
            if let noteText = alertView?.textFields?[0].text {
                self.thisEntry.note = noteText
                self.fixNoteButtonTitle()
            }
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    @IBAction func newexersisetouched(_ sender: UIButton) {
        
        self.dateTextView.resignFirstResponder()
        
        let alertView = UIAlertController(title: "New exersise", message: "", preferredStyle: .alert)
        alertView.addTextField(configurationHandler: nil)
        alertView.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alertView] _ in
            if let exersiseText = alertView?.textFields?[0].text {
                if exersiseText != "" {
                    P9SGlobals.exersises.append(exersiseText)
                    P9SGlobals.exersises.sort()
                    self.selectedExersises.update(with: exersiseText)
                    self.tableView.reloadData()
                }
            }
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        
        self.present(alertView, animated: true, completion: nil)
        
    }
    
    @IBAction func saveTuched(_ sender: UIBarButtonItem) {
        
        var exersises = ""
        for exersise in self.selectedExersises {
            exersises += "\(exersise), "
        }
        if exersises != "" {
            self.thisEntry.exersises = exersises.substring(to: exersises.index(exersises.endIndex, offsetBy: -2))
        }
        if self.isManualEntry {
            self.thisEntry.date = self.dateTextView.datePicker.date
            P9SGlobals.log.append(self.thisEntry)
            _ = self.navigationController?.popViewController(animated: true)
        } else if self.isEdit {
            self.thisEntry.date = self.dateTextView.datePicker.date
            P9SGlobals.log[self.editIndex] = self.thisEntry
            _ = self.navigationController?.popViewController(animated: true)

        } else {
            P9SGlobals.log[P9SGlobals.log.count-1] = self.thisEntry
            self.performSegue(withIdentifier: "DetailEntryExit", sender: nil)
        }
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
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let cell = UITableViewCell()
        
        cell.backgroundColor = UIColor.black
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = P9SGlobals.exersises[indexPath.item]
        if selectedExersises.contains(P9SGlobals.exersises[indexPath.item]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dateTextView.resignFirstResponder()
        let cell = tableView.cellForRow(at: indexPath)
        if self.selectedExersises.contains(P9SGlobals.exersises[indexPath.item]) {
            self.selectedExersises.remove(P9SGlobals.exersises[indexPath.item])
            cell?.accessoryType = .none
        } else {
            self.selectedExersises.update(with: P9SGlobals.exersises[indexPath.item])
            cell?.accessoryType = .checkmark
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.selectedExersises.remove(P9SGlobals.exersises[indexPath.row])
            P9SGlobals.exersises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }   
    }

}
