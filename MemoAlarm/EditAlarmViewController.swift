//
//  EditAlarmViewController.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/12/27.
//

import UIKit

class EditAlarmViewController: UIViewController {

    @IBOutlet weak var editNameTextField: UITextField! {
        didSet {
            editNameTextField.text = alarm.name
        }
    }
    @IBOutlet weak var editRingTimingDatePicker: UIDatePicker! {
        didSet {
            editRingTimingDatePicker.date = GlobalConst.calendar.date(from: alarm.ringTiming)!
            editRingTimingDatePicker.calendar = GlobalConst.calendar
        }
    }
    @IBOutlet weak var editRepeatDatesView: UIView!
    @IBOutlet weak var displayRepeatDatesLabel: UILabel! {
        didSet {
            displayRepeatDatesLabel.text = alarm.isRepeated ? "あり" : "なし"
        }
    }
    @IBOutlet weak var editNoteTextView: UITextView! {
        didSet {
            editNoteTextView.text = alarm.note
        }
    }

    private var alarm: Alarm
    
    init(nibName: String?, bundle: Bundle?, alarm: Alarm) {
        self.alarm = alarm
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        applyEditToAlarm()
        if let viewController = presentingViewController as? ViewController {
            viewController.alarmTableView.reloadData()
        }
    }

    @IBAction func tappedRepeatDatesView(_ sender: UIButton) {
        if alarm.isRepeated {
            displayRepeatDatesLabel.text = "なし"
            alarm.isRepeated = false
        } else {
            displayRepeatDatesLabel.text = "あり"
            alarm.isRepeated = true
        }
    }
    
    private func setup(alarm: Alarm) {
        self.alarm = alarm
        
    }

    func applyEditToAlarm() {
        alarm.name = editNameTextField.text ?? ""
        alarm.note = editNoteTextView.text
        alarm.ringTiming = GlobalConst.calendar.dateComponents([.hour,.minute], from: editRingTimingDatePicker.date)
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
