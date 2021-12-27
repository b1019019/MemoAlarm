//
//  EditAlarmViewController.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/12/27.
//

import UIKit

class EditAlarmViewController: UIViewController {

    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editRingTimingDatePicker: UIDatePicker!
    @IBOutlet weak var editRepeatDatesView: UIView!
    @IBOutlet weak var editNoteTextView: UITextView!

    var alarm: Alarm!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func setup(alarm: Alarm) {
        
        self.alarm = alarm
        editNameTextField.text = alarm.name
        editRingTimingDatePicker.date = alarm.ringTiming.date ?? Date()
        editNoteTextView.text = alarm.note
    }

    func applyEditToAlarm() {
        alarm.name = editNameTextField.text ?? ""
        alarm.note = editNoteTextView.text
        alarm.ringTiming = Const.calendar.dateComponents(in: Const.calendar.timeZone, from: editRingTimingDatePicker.date)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
