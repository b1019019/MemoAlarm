//
//  AlarmTableViewCell.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa

protocol AlarmTableViewCellDelegate {
    var tappedSwitch: PublishRelay<(Bool,IndexPath)> { get }
}

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var alarmSetSwitch: UISwitch!
    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var repeatDateLabel: UILabel!
    var indexPath: IndexPath!
    var delegate: AlarmTableViewCellDelegate!
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(indexPath: IndexPath, name: String, ringTiming: DateComponents, isRepeated: Bool, isRingable: Bool) {
        self.indexPath = indexPath
        alarmSetSwitch.setOn(isRingable, animated: false)
        alarmNameLabel.text = name
        alarmTimeLabel.text = "\(ringTiming.hour!)" + ":" + String(format: "%02d", ringTiming.minute!)
        repeatDateLabel.text = isRepeated ? "繰り返しあり" : "繰り返しなし"
        alarmSetSwitch.rx.isOn
            .map({ ($0,indexPath) })
            .bind(to: delegate.tappedSwitch)
            .disposed(by: disposeBag)
    }
}
