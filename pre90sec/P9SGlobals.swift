//
//  P9SGlobals.swift
//  pre90sec
//
//  Created by Wayne Ohmer on 12/19/16.
//  Copyright © 2016 Wayne Ohmer. All rights reserved.
//

import UIKit

class P9SGlobals: NSObject {
    
    static var maxtime = Int(90)
    static var spokenTimes:Set<Int> = []
    static var finishedWords = "done"
    static var log = [P9SlogEntry]()
    static var exersises = ["pushups","wall sit","squat thrusts","band circles","air squats","plank"]
    static var progressImageDates = [String:Date]()

    static func readDefaults() {
        let defaults = UserDefaults.standard
        if let spokenTimesArray = defaults.object(forKey:"spokenTimes") as? [Int]{
            P9SGlobals.spokenTimes = Set(spokenTimesArray)
        }
        if let exersises = defaults.object(forKey:"exersises") as? [String]{
            P9SGlobals.exersises = exersises
        }
        if let progressImageDates = defaults.object(forKey:"progressImageDates") as? [String:Date] {
            P9SGlobals.progressImageDates = progressImageDates
        }
        if defaults.integer(forKey: "maxtime") != 0 {
            P9SGlobals.maxtime = defaults.integer(forKey: "maxtime")
        }
        if let finishedWords = defaults.object(forKey:"finishedWords") as? String {
            P9SGlobals.finishedWords = finishedWords
        }
        if let logDates = defaults.object(forKey:"logDates") as? [Date] {
            if let logExercizes = defaults.object(forKey:"logExercizes") as? [String] {
                if let logNotes = defaults.object(forKey:"logNotes") as? [String] {
                    P9SGlobals.log.removeAll()
                    for (idx,logDate) in logDates.enumerated() {
                        P9SGlobals.log.append(P9SlogEntry(date: logDate, exersises: logExercizes[idx], note: logNotes[idx]))
                    }
                }
            }
        }
    }
    
    static func writeDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(Array(P9SGlobals.spokenTimes), forKey:"spokenTimes")
        defaults.set(P9SGlobals.maxtime, forKey:"maxtime")
        defaults.set(P9SGlobals.finishedWords, forKey:"finishedWords")
        var logDates = [Date]()
        var logExercizes = [String]()
        var logNotes = [String]()
        for logEntry in P9SGlobals.log {
            logDates.append(logEntry.date)
            logExercizes.append(logEntry.exersises)
            logNotes.append(logEntry.note)
        }
        defaults.set(logDates, forKey:"logDates")
        defaults.set(logExercizes, forKey:"logExercizes")
        defaults.set(logNotes, forKey:"logNotes")
        defaults.set(P9SGlobals.exersises, forKey:"exersises")
        defaults.set(P9SGlobals.progressImageDates, forKey:"progressImageDates")
    }
    
}

extension Date {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMM dd yyyy"
        return dateFormatter.string(from: self)
    }
    
    func shortFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: self)

    }
    
    func formattedTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func formatedDateTime() -> String {
        return "\(self.formattedDate()) \(self.formattedTime())"
    }

}
