//
//  EditAlarmViewController.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/12/27.
//

import UIKit
import RxSwift
import RxCocoa

class EditAlarmViewController: UIViewController {

    @IBOutlet weak var editNameTextField: UITextField!
    @IBOutlet weak var editRingTimingDatePicker: UIDatePicker!
    @IBOutlet weak var editRepeatDatesButton: UIButton!
    @IBOutlet weak var displayRepeatDatesLabel: UILabel!
    @IBOutlet weak var editNoteTextView: UITextView!

    private var viewModel: EditAlarmViewModel
    private let disposeBag = DisposeBag()
    private var isRepeated = BehaviorRelay(value: false)
    
    init(viewModel: EditAlarmViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.editRingTimingDatePicker.calendar = GlobalConst.calendar
        bindToViewModel()
    }
    
    private func bindToViewModel() {
        rx.viewWillAppear
            .bind(to: viewModel.inputs.ready)
            .disposed(by: disposeBag)
        
        rx.viewWillDisappear
        //ViewModelで行うべき。こちらからは引数を送るのみにして、あちらでAlarmModelに組み立てるべき
            .map({ [weak self] in
                return Alarm(name: self?.editNameTextField.text ?? "", note: self?.editNoteTextView.text ?? "", ringTime: GlobalConst.calendar.dateComponents([.hour,.minute], from: self?.editRingTimingDatePicker.date ?? Date()), isRepeated: self!.isRepeated.value, isRingable: false)
            })
            .bind(to: viewModel.inputs.inputAlarm)
            .disposed(by: disposeBag)
        
        editRepeatDatesButton.rx.tap
            .map({ [weak self] in
                return !(self!.isRepeated.value)
            })
            .bind(to: isRepeated)
            .disposed(by: disposeBag)
        
        //viewmodelに処理を移行する
        isRepeated.subscribe(onNext: { [weak self] isRepeated in
            if isRepeated {
                self?.displayRepeatDatesLabel.text = "あり"
            } else {
                self?.displayRepeatDatesLabel.text = "なし"
            }
        }).disposed(by: disposeBag)
        
        viewModel.outputs.editingAlarm
            .drive(onNext: { [weak self] alarm in
                self?.editNameTextField.rx.text.onNext(alarm.name)
                self?.editRingTimingDatePicker.rx.date.onNext(GlobalConst.calendar.date(from: alarm.ringTiming) ?? Date())
                self?.displayRepeatDatesLabel.rx.text.onNext(alarm.note)
                self?.editNoteTextView.rx.text.onNext(alarm.note)
                self?.isRepeated.accept(alarm.isRepeated)
            })
            .disposed(by: disposeBag)
    }
        
    
}
