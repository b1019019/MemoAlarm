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
    @IBOutlet weak var displayRepeatDatesLabel: UILabel!
    @IBOutlet weak var editNoteTextView: UITextView!
    var editAlarmPresenterInput: EditAlarmPresenterInput!
    var alarm: Alarm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editNameTextField.text = alarm.name
        editRingTimingDatePicker.date = GlobalConst.calendar.date(from: alarm.ringTiming)!
        editRingTimingDatePicker.calendar = GlobalConst.calendar
        displayRepeatDatesLabel.text = alarm.isRepeated ? "あり" : "なし"
        editNoteTextView.text = alarm.note
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        editAlarmPresenterInput.viewWillDisappear(name: editNameTextField.text ?? "", note: editNoteTextView.text, pickerDate: editRingTimingDatePicker.date)
    }

    @IBAction func tappedRepeatDatesView(_ sender: UIButton) {
        editAlarmPresenterInput.tappedButtonChangeIsRepeated()
    }
    
    func inject(presenter: EditAlarmPresenterInput) {
        self.editAlarmPresenterInput = presenter
    }
    
}

extension EditAlarmViewController: EditAlarmPresenterOutput {
    func reloadAlarmTableView() {
        if let viewController = navigationController?.viewControllers[0] as? ViewController {
            viewController.alarmTableView.reloadData()
        }
    }
    
    func setup(alarm: Alarm) {
        self.alarm = alarm

    }
    
    func transitionMainView() {
        if let viewController = navigationController?.viewControllers[0] as? ViewController {
            viewController.alarmTableView.reloadData()
        }
        
    }
    
    func changeTextButtonChangeIsRepeated(text: String) {
        displayRepeatDatesLabel.text = text
    }
    
}
