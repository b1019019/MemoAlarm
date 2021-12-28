//
//  AlarmTableViewCell.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/11/25.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var alarmSetSwitch: UISwitch!
    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var repeatDateLabel: UILabel!
    
    private var alarm: Alarm!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func tapped(_ sender: UISwitch) {
        if sender.isOn {
            alarm.isRingable = true
            alarm.set()
        } else {
            alarm.isRingable = false
            alarm.release()
        }
    }
    
    func setup(alarm: Alarm) {
        guard let ringHour = alarm.ringTiming.hour else {
            return
        }
        guard let ringMinute = alarm.ringTiming.minute else {
            return
        }
        self.alarm = alarm
        alarmSetSwitch.isOn = alarm.isRingable
        alarmNameLabel.text = alarm.name
        alarmTimeLabel.text = "\(ringHour),\(ringMinute)"
        repeatDateLabel.text = [RepeatDate](alarm.repeatDates).map{ $0.rawValue }.joined(separator: ",")
    }
    
}
