//
//  EditRepeatDatesModalViewController.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/12/28.
//

import UIKit

class EditRepeatDatesModalViewController: UIViewController {

    @IBOutlet weak var selectRepeatDatesTableView: UITableView! {
        didSet {
            selectRepeatDatesTableView.delegate = self
            selectRepeatDatesTableView.dataSource = self
            selectRepeatDatesTableView.allowsMultipleSelection = true
        }
    }

    private let allRepeatDates: [RepeatDate] = [.everyMonday, .everyTuesday, .everyWednesday, .everyThursday, .everyFriday, .everySaturday, .everySunday]
    private var alarm: Alarm
    private lazy var afterRepeatDates = alarm.repeatDates

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

    @IBAction func tappedEnterButton(_ sender: UIButton) {
        alarm.repeatDates = afterRepeatDates
        if let viewController = presentingViewController as? EditAlarmViewController {
            viewController.displayRepeatDatesLabel.text = [RepeatDate](alarm.repeatDates).map{ $0.rawValue }.joined(separator: ",")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension EditRepeatDatesModalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .checkmark
        afterRepeatDates.insert(allRepeatDates[indexPath.row])
    }

    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
        afterRepeatDates.remove(allRepeatDates[indexPath.row])
    }

    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return allRepeatDates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(allRepeatDates[indexPath.row])"
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if alarm.repeatDates.contains(allRepeatDates[indexPath.row]) {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    
    
}
