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
    static var exersizes = ["Pushups","Wall Sit","Squat Thrusts","Band circles","Air Squats"]

    static func readDefaults() {
        let defaults = UserDefaults.standard
        if let spokenTimesArray = defaults.object(forKey:"spokenTimes") as? [Int]{
            P9SGlobals.spokenTimes = Set(spokenTimesArray)
        }
        if let exersizes = defaults.object(forKey:"exersizes") as? [String]{
            P9SGlobals.exersizes = exersizes
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
                        P9SGlobals.log.append(P9SlogEntry(date: logDate, exersize: logExercizes[idx], note: logNotes[idx]))
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
            logExercizes.append(logEntry.exersize)
            logNotes.append(logEntry.note)
        }
        defaults.set(logDates, forKey:"logDates")
        defaults.set(logExercizes, forKey:"logExercizes")
        defaults.set(logNotes, forKey:"logNotes")
        defaults.set(P9SGlobals.exersizes, forKey:"exersizes")
    }
    
}

extension Date {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy"
        return dateFormatter.string(from: self)
    }
    
    func formattedTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }

}
