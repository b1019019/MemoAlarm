//
//  AlarmModel.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/01/08.
//

import Foundation
import UIKit
class Alarm: NSObject, NSCoding {
    static var supportsSecureCoding = false
    var name: String
    var note: String
    var ringTiming: DateComponents
    var isRepeated: Bool
    var isRingable: Bool
    var id = NSUUID().uuidString
    
    private struct Const {
        static let nameKey = "name"
        static let noteKey = "note"
        static let ringTimingKey = "ringTiming"
        static let isRepeatedKey = "isRepeated"
        static let isRingableKey = "isRingable"
        static let idKey = "id"
    }
    
    init(name: String, note: String, ringTime: DateComponents, isRepeated: Bool, isRingable: Bool) {
        self.name = name
        self.note = note
        self.ringTiming = ringTime
        self.isRepeated = isRepeated
        self.isRingable = isRingable
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: Const.nameKey) as! String
        note = coder.decodeObject(forKey: Const.noteKey) as! String
        ringTiming = coder.decodeObject(forKey: Const.ringTimingKey) as! DateComponents
        isRepeated = coder.decodeBool(forKey: Const.isRepeatedKey)
        isRingable = coder.decodeBool(forKey: Const.isRingableKey)
        id = coder.decodeObject(forKey: Const.idKey) as! String
    }
    
    static func empty() -> Alarm {
        return Alarm(name: Const.newAlarmName, note: "", ringTime: DateComponents(), isRepeated: false, isRingable: false)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: Const.nameKey)
        coder.encode(self.note, forKey: Const.noteKey)
        coder.encode(self.ringTiming, forKey: Const.ringTimingKey)
        coder.encode(self.isRepeated, forKey: Const.isRepeatedKey)
        coder.encode(self.isRingable, forKey: Const.isRingableKey)
        coder.encode(self.id, forKey: Const.idKey)
    }
}
