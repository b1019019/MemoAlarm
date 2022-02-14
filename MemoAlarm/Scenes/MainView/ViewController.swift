//
//  ViewController.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/11/25.
//

import UIKit

class ViewController: UIViewController {
    
    private struct Const {
        static let alarmTableViewCellNibName = "AlarmTableViewCell"
        static let alarmTableViewCellReuseIdentifier = "AlarmTableViewCell"
        static let numberOfRowsInSection = 20
    }
    
    private var presenter: PresenterInput!

    @IBOutlet weak var alarmTableView: UITableView! {
        didSet {
            alarmTableView.delegate = self
            alarmTableView.dataSource = self
            let nib = UINib(nibName: Const.alarmTableViewCellNibName, bundle: nil)
            alarmTableView.register(nib, forCellReuseIdentifier: Const.alarmTableViewCellReuseIdentifier)
        }
    }
    
    override func viewDidLoad() {
        
    }

    @IBAction func tappedAddCellButton(_ sender: UIBarButtonItem) {
        presenter.tappedButtonMakeNewAlarm()
    }
    
    func inject(presenter: PresenterInput) {
        self.presenter = presenter
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfAlarms
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.alarmTableViewCellForRowAt(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectAlarmTableViewCell(indexPath: indexPath)
    }
}

extension ViewController: AlarmTableViewCellDelegate {
    func tappedSwitchInCell(isOn: Bool, index: Int) {
        presenter.tappedSwitchInAlarmTableViewCell(isOn: isOn, index: index)
    }
}

extension ViewController: PresenterOutput {
    func createAlarmTableViewCell(indexPath: IndexPath, name: String, ringTiming: DateComponents, isRepeated: Bool, isRingable: Bool) -> AlarmTableViewCell {
        let cell = alarmTableView.dequeueReusableCell(withIdentifier: Const.alarmTableViewCellNibName, for: indexPath) as! AlarmTableViewCell
        cell.setup(indexPath: indexPath, name: name, ringTiming: ringTiming, isRepeated: isRepeated, isRingable: isRingable)
        cell.delegate = self
        return cell
    }
    
    func transitionEditAlarmView(name: String, note: String, ringTiming: DateComponents, isRepeated: Bool) {
        let editAlarmViewController = EditAlarmViewController(nibName: "EditAlarmViewController", bundle: nil)
        //editAlarmViewController.setup(name: name, note: note, ringTiming: ringTiming, isRepeated: isRepeated)
        self.navigationController?.pushViewController(editAlarmViewController, animated: true)
    }
    
    func transitionNewEditAlarmView() {
        let editAlarmViewController = EditAlarmViewController(nibName: "EditAlarmViewController", bundle: nil)
        self.navigationController?.pushViewController(editAlarmViewController, animated: true)
    }
}
