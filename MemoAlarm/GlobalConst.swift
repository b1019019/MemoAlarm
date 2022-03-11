//
//  Const.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/12/27.
//

import Foundation

struct GlobalConst {
    static let calendar = Calendar(identifier: .gregorian)
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "HH時mm分"
        return formatter
    }()
    static let alarmsUserDefaultKey = "alarms"
    static let mainStorybordName = "Main"
}
