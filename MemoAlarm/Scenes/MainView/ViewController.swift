//
//  ViewController.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/11/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController, AlarmTableViewCellDelegate {

    private struct Const {
        static let alarmTableViewCellNibName = "AlarmTableViewCell"
        static let alarmTableViewCellReuseIdentifier = "AlarmTableViewCell"
        static let numberOfRowsInSection = 20
    }
    
    var tappedSwitch = PublishRelay<(Bool, Int)>()
    
    private var viewModel: MainViewModel!
    private let disposeBag = DisposeBag()

    @IBOutlet weak var addNewAlarmButton: UIBarButtonItem!
    @IBOutlet weak var alarmTableView: UITableView!
    
    override func viewDidLoad() {
        let nib = UINib(nibName: Const.alarmTableViewCellNibName, bundle: nil)
        alarmTableView.register(nib, forCellReuseIdentifier: Const.alarmTableViewCellReuseIdentifier)
        bindToViewModel()
    }
    
    private func bindToViewModel() {
        rx.viewWillAppear
            .bind(to: viewModel.inputs.ready)
            .disposed(by: disposeBag)
        
        alarmTableView.rx.itemSelected
            .bind(to: viewModel.inputs.tappedAlarmTableViewCell)
            .disposed(by: disposeBag)
        
        addNewAlarmButton.rx.tap
            .bind(to: viewModel.inputs.tappedButtonMakeNewAlarm)
            .disposed(by: disposeBag)
        
        tappedSwitch
            .do(onNext: { v in///
                print("tappedSwitch",v)
            })
            .bind(to: viewModel.inputs.tappedSwitchInAlarmTableViewCell)
            .disposed(by: disposeBag)
        
        viewModel.outputs.alarms
            .drive(alarmTableView.rx.items(cellIdentifier: Const.alarmTableViewCellReuseIdentifier, cellType: AlarmTableViewCell.self)) { (row, alarm, cell) in
                //delegateの設定の複雑性をなくす
                cell.delegate = self
                cell.setup(index: row, name: alarm.name, ringTiming: alarm.ringTiming, isRepeated: alarm.isRepeated, isRingable: alarm.isRingable)
            }
            .disposed(by: disposeBag)
    }
    
    func addAlarm(alarm: Alarm) {
        viewModel.addedAlarm = alarm
    }
    
    func editAlarm(alarm: Alarm, index: Int) {
        viewModel.editedAlarmAndIndex = (alarm, index)
    }
    
    func setup(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
}
