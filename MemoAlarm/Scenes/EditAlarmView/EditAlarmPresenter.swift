//
//  EditAlarmPresenter.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/01/09.
//

import Foundation

protocol EditAlarmPresenterInput {
    func applyEditToAlarm(name: String, note: String, pickerDate: Date)
    func tappedButtonChangeIsRepeated()
    func viewWillDisappear(name: String, note: String, pickerDate: Date)
}

protocol EditAlarmPresenterOutput {
    func setup(alarm: Alarm)
    func changeTextButtonChangeIsRepeated(text: String)
    func reloadAlarmTableView()
}

class EditAlarmPresenter: EditAlarmPresenterInput {
    let editAlarmPresenterOutput: EditAlarmPresenterOutput
    let alarm: Alarm
    
    init(editAlarmPresenterOutput: EditAlarmPresenterOutput, alarm: Alarm) {
        self.editAlarmPresenterOutput = editAlarmPresenterOutput
        self.alarm = alarm
    }
    
    func tappedButtonChangeIsRepeated() {
        if alarm.isRepeated {
            editAlarmPresenterOutput.changeTextButtonChangeIsRepeated(text: "なし")
            alarm.isRepeated = false
        } else {
            editAlarmPresenterOutput.changeTextButtonChangeIsRepeated(text: "あり")
            alarm.isRepeated = true
        }
    }
    
    func applyEditToAlarm(name: String, note: String, pickerDate: Date) {
        alarm.name = name
        alarm.note = note
        alarm.ringTiming = GlobalConst.calendar.dateComponents([.hour,.minute], from: pickerDate)
    }
    
    func viewWillDisappear(name: String, note: String, pickerDate: Date) {
        applyEditToAlarm(name: name, note: note, pickerDate: pickerDate)
        editAlarmPresenterOutput.reloadAlarmTableView()
    }
}
