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
    var tappedSwitch: PublishRelay<(Bool,Int)> { get }
}

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var alarmSetSwitch: UISwitch!
    @IBOutlet weak var alarmNameLabel: UILabel!
    @IBOutlet weak var alarmTimeLabel: UILabel!
    @IBOutlet weak var repeatDateLabel: UILabel!
    var index: Int!
    var delegate: AlarmTableViewCellDelegate!
    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //ロジックを切り分ける、入力をテキストにする。
    func setup(index: Int, name: String, ringTiming: DateComponents, isRepeated: Bool, isRingable: Bool) {
        self.index = index
        alarmSetSwitch.setOn(isRingable, animated: false)
        alarmNameLabel.text = name
        alarmTimeLabel.text = DateComponentsFormatter().toStringHourAndMinute(dateComponents: ringTiming)
        repeatDateLabel.text = isRepeated ? "繰り返しあり" : "繰り返しなし"
        alarmSetSwitch.rx.value
            .map({ ($0,index) })
            .share()
            .skip(1)
            .bind(to: delegate.tappedSwitch)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
