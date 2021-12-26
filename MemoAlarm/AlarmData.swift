//
//  AlarmData.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/12/26.
//

import Foundation

enum RepeatDate {
    case everyMonday
    case everyTuesday
    case everyWednesday
    case everyThursday
    case everyFriday
    case everySaturday
    case everySunday
}

class AlarmData {
    var name: String
    var note: String
    var ringTime: Date
    var repeatDates: Set<RepeatDate>
    var isRingable: Bool
    
    init(name: String, note: String, ringTime: Date, repeatDates: Set<RepeatDate>, isRingable: Bool) {
        self.name = name
        self.note = note
        self.ringTime = ringTime
        self.repeatDates = repeatDates
        self.isRingable = isRingable
    }
    
}
