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
    
    private var viewModel: MainViewModel
    private let disposeBag = DisposeBag()

    @IBOutlet weak var addNewAlarmButton: UIBarButtonItem!
    @IBOutlet weak var alarmTableView: UITableView!
    
    init(viewModel: MainViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            .bind(to: viewModel.inputs.tappedSwitchInAlarmTableViewCell)
            .disposed(by: disposeBag)
        
        viewModel.outputs.alarms
            .drive(alarmTableView.rx.items(cellIdentifier: Const.alarmTableViewCellReuseIdentifier, cellType: AlarmTableViewCell.self)) { (row, alarm, cell) in
                cell.setup(index: row, name: alarm.name, ringTiming: alarm.ringTiming, isRepeated: alarm.isRepeated, isRingable: alarm.isRingable)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
    }
}
