//
//  DateComponents+Extension.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/03/10.
//

import Foundation

extension DateComponentsFormatter {
    func toStringHourAndMinute(dateComponents :DateComponents) -> String? {
        unitsStyle = .positional
        allowedUnits = [.hour, .minute]
        return string(from: dateComponents)
    }
}
