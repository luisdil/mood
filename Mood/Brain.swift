//
//  Brain.swift
//  Mood
//
//  Created by Luis Dille on 15.01.17.
//  Copyright © 2017 Luis Dille. All rights reserved.
//

import Foundation

func getCurrentTime() -> String {

    let date = NSDate()
    let calendar = NSCalendar.current
    var hour = String(calendar.component(.hour, from: date as Date))
    var minutes = String(calendar.component(.minute, from: date as Date))
    
    if hour.characters.count < 2 {
        hour.insert("0", at: hour.startIndex)
    }
    
    if minutes.characters.count < 2 {
        minutes.insert("0", at: minutes.startIndex)
    }
    
    let time = (hour + ":" + minutes)
    return time
}

func getCurrentDate() -> String {
    let date = Date()
    let formatter = DateFormatter()
    
    formatter.dateFormat = "dd.MM.yyyy"
    let result = formatter.string(from: date)

    return result
}
