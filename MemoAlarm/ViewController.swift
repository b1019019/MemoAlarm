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
    
    private var alarms = [Alarm(name: "アラームの名前", note: "メモ", ringTime: DateComponents(calendar: GlobalConst.calendar, hour: 7, minute: 23), repeatDates: Set<RepeatDate>([.everyFriday,.everyMonday]), isRingable: false)]

    @IBOutlet weak var alarmTableView: UITableView! {
        didSet {
            alarmTableView.delegate = self
            alarmTableView.dataSource = self
            let nib = UINib(nibName: Const.alarmTableViewCellNibName, bundle: nil)
            alarmTableView.register(nib, forCellReuseIdentifier: Const.alarmTableViewCellReuseIdentifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.alarmTableViewCellNibName, for: indexPath) as! AlarmTableViewCell
        cell.setup(alarm: alarms[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editAlarmViewController = EditAlarmViewController(nibName: "EditAlarmViewController", bundle: nil, alarm: alarms[indexPath.row])
        self.present(editAlarmViewController, animated: true)
    }
}
