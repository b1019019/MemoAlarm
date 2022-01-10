//
//  AlarmTableViewCell.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/11/25.
//

import UIKit

protocol AlarmTableViewCellDelegate {
    func tappedSwitchInCell(isOn: Bool, index: Int)
}

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var alarmSetSwitch: UISwitch!
    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var repeatDateLabel: UILabel!
    var index: Int!
    var delegate: AlarmTableViewCellDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(indexPath: IndexPath, name: String, ringTiming: DateComponents, isRepeated: Bool, isRingable: Bool) {
        index = indexPath.row
        alarmSetSwitch.setOn(isRingable, animated: false)
        alarmNameLabel.text = name
        alarmTimeLabel.text = "\(ringTiming.hour!):\(ringTiming.minute!)"
        repeatDateLabel.text = isRepeated ? "繰り返しあり" : "繰り返しなし"
    }
    
    @IBAction func tapped(_ sender: UISwitch) {
        delegate.tappedSwitchInCell(isOn: sender.isOn, index: index)
    }
}
