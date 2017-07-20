//
//  P9SLogController.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/20/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class P9SLogController: UITableViewController {

    var tableData = [[P9SlogEntry]]()
    var flatIndexs = [IndexPath]()
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 30
        self.tableView.sectionHeaderHeight = 40
        self.tableView.tableFooterView = UIView()
        self.navigationItem.rightBarButtonItems = [self.addButton,self.editButtonItem]

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.makeTableData()
     }
    
    func makeTableData() {
        
       
        let calendar = Calendar.current
        var dayArray = [P9SlogEntry]()
        var previousEntry = P9SlogEntry()
        self.tableData.removeAll()
        for logEntry in P9SGlobals.log {
            if dayArray.count != 0 {
                let previousDay = calendar.component(.day, from: previousEntry.date)
                let thisDay = calendar.component(.day, from: logEntry.date)
                if previousDay != thisDay {
                    let previousMidnight = calendar.startOfDay(for: previousEntry.date)
                    let logEntryMidnight = calendar.startOfDay(for: logEntry.date)
                    let difference = calendar.dateComponents([.day], from: logEntryMidnight, to: previousMidnight)
                    if let days = difference.day {
                        if days > 1 {
                            dayArray.append(P9SlogEntry(date: logEntry.date, exersises: "\(days - 1) Day Gap", note: "", isGap: true))
                        }
                    }
                    self.tableData.append(dayArray)
                    dayArray.removeAll()
                }
            }
            dayArray.append(logEntry)
            previousEntry = logEntry
        }
        self.tableData.append(dayArray)
        self.flatIndexs.removeAll()
        for (section, _) in self.tableData.enumerated()  {
            for (row, _) in self.tableData[section].enumerated() {
                self.flatIndexs.append(IndexPath(row: row, section: section))
            }
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData[section].count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.textColor = UIColor.white
            headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            headerView.contentView.backgroundColor = UIColor.darkGray
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableData[section].count > 0 {
            return "\(self.tableData[section][0].date.formattedDate())"
        } else {
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let logEntry = self.tableData[indexPath.section][indexPath.row]
        
        if logEntry.isGap {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogGap", for: indexPath) as! P9SLogGapCell
            cell.titleLabel.text = logEntry.exersises
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogEntry", for: indexPath) as! P9SLogCell
            
            cell.exercizesLabel?.text = "\(logEntry.exersises) "
            cell.timeLabel?.text = "\(logEntry.date.formattedTime()) "
            cell.accessoryType = logEntry.note != "" ? .detailButton : .none
       
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let alertView = UIAlertController(title: "Note", message: self.tableData[indexPath.section][indexPath.row].note, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !self.tableData[indexPath.section][indexPath.row].isGap
    }
       // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            P9SGlobals.log.remove(at: self.flatIndexs.index(of: indexPath)!)
            self.makeTableData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ManualAdd" {
            if let vc = segue.destination as? P9SLogEntryController {
                vc.isManualEntry = true
            }
        } else if segue.identifier == "Edit" {
            if let vc = segue.destination as? P9SLogEntryController {
                vc.isEdit = true
                if let sourceCell = sender as? P9SLogCell {
                    if let indexPath = self.tableView.indexPath(for: sourceCell) {
                        vc.editIndex = self.flatIndexs.index(of: indexPath )!
                    }
                }
            }
        }
    }
    

}
