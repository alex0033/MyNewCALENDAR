//
//  AddEventViewController.swift
//  newCALENDAR
//
//  Created by ユーザー名 on 2019/12/06.
//  Copyright © 2019年 ユーザー名. All rights reserved.
//

import UIKit
import CoreData

class AddEventViewController: UIViewController {
    
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var changeButton: UIBarButtonItem!
    @IBOutlet var removeButton: UIBarButtonItem!
    
    @IBOutlet var titleTextfield: UITextField!
    @IBOutlet var placeTextField: UITextField!
    
    @IBOutlet var startYearTextField: UITextField!
    @IBOutlet var startMonthTextField: UITextField!
    @IBOutlet var startDayTextField: UITextField!
    @IBOutlet var startHourTextField: UITextField!
    @IBOutlet var startMinuteTextField: UITextField!
    
    @IBOutlet var endHourTextField: UITextField!
    @IBOutlet var endMinuteTextField: UITextField!
    
    var saveButtonBool: Bool = true
    var changeButtonBool: Bool = false
    var removeButtonBool: Bool = false
    
    var setYear = 0
    var setMonth = 0
    var setDay = 0
    var setFlag = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.setYear == 0 {
            //do nothing
        }else if self.setMonth == 0 || self.setDay == 0 {
            self.alertPresent(messageItem: "予期せぬエラー")
        }else{
            self.startYearTextField.text = "\(self.setYear)"
            self.startMonthTextField.text = "\(self.setMonth)"
            self.startDayTextField.text = "\(self.setDay)"
        }
//        print(dateDataController.myDate.count)
//        dateDataController.DataUpLoad()
//        print(dateDataController.myDate.count)
        self.recieveButtonBool()
    }
    
    func alertPresent(messageItem: String?){
        let alertController = UIAlertController(title: "エラー", message: "「\(messageItem!)」に不備があります", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
    
    @IBAction func saveData(_ sender: Any) {
        //仕上げのとき整理する
        guard var title = self.titleTextfield.text else {
            alertPresent(messageItem: "タイトル")
            return
        }
        title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.titleTextfield.text = title
        if title.isEmpty {
            self.alertPresent(messageItem: "タイトル")
            return
        }
        
        guard var place = self.placeTextField.text else {
            self.alertPresent(messageItem: "場所")
            return
        }
        
        place = place.trimmingCharacters(in: .whitespacesAndNewlines)
        self.placeTextField.text = place
        
        guard var startYearString = self.startYearTextField.text else {
            self.alertPresent(messageItem: "開始時刻")
            return
        }
        startYearString = startYearString.trimmingCharacters(in: .whitespacesAndNewlines)
        self.startYearTextField.text = startYearString
        
        guard var startMonthString = self.startMonthTextField.text else {
            self.alertPresent(messageItem: "開始時刻")
            return
        }
        startMonthString = startMonthString.trimmingCharacters(in: .whitespacesAndNewlines)
        self.startMonthTextField.text = startMonthString
        
        guard var startDayString = self.startDayTextField.text else {
            self.alertPresent(messageItem: "開始時刻")
            return
        }
        startDayString = startDayString.trimmingCharacters(in: .whitespacesAndNewlines)
        self.startDayTextField.text = startDayString
        
        guard var startHourString = self.startHourTextField.text else {
            self.alertPresent(messageItem: "開始時刻")
            return
        }
        startHourString = startHourString.trimmingCharacters(in: .whitespacesAndNewlines)
        self.startHourTextField.text = startHourString
        
        guard var startMinuteString = self.startMinuteTextField.text else {
            self.alertPresent(messageItem: "開始時刻")
            return
        }
        startMinuteString = startMinuteString.trimmingCharacters(in: .whitespacesAndNewlines)
        self.startMinuteTextField.text = startMinuteString
        
        guard var endHourString = self.endHourTextField.text else {
            self.alertPresent(messageItem: "終了時刻")
            return
        }
        endHourString = endHourString.trimmingCharacters(in: .whitespacesAndNewlines)
        self.endHourTextField.text = endHourString
        
        guard var endMinuteString = self.endMinuteTextField.text else {
            self.alertPresent(messageItem: "終了時刻")
            return
        }
        endMinuteString = endMinuteString.trimmingCharacters(in: .whitespacesAndNewlines)
        self.endMinuteTextField.text = endMinuteString
        
        guard let startYear = Int(startYearString) else {
            self.alertPresent(messageItem: "開始時刻")
            return
        }
        guard let startMonth = Int(startMonthString) else {
            self.alertPresent(messageItem: "開始時刻")
            return
        }
        guard let startDay = Int(startDayString) else {
            self.alertPresent(messageItem: "開始時刻")
            return
        }
        guard let startHour = Int(startHourString) else {
            self.alertPresent(messageItem: "開始時刻")
            return
        }
        guard let startMinute = Int(startMinuteString) else {
            self.alertPresent(messageItem: "開始時刻")
            return
        }
        guard let endHour = Int(endHourString) else {
            self.alertPresent(messageItem: "終了時刻")
            return
        }
        guard let endMinute = Int(endMinuteString) else {
            self.alertPresent(messageItem: "終了時刻")
            return
        }
        
        if self.saveDateEvent(title: title, place: place, startYear: startYear, startMonth: startMonth, startDay: startDay, startHour: startHour, startMinute: startMinute, endHour: endHour, endMinute: endMinute) {
            //変えよう！！
            self.dismiss(animated: true, completion: nil)
        } else {
            
        }
        
        //最後
        
    }
    
    func saveDateEvent(title: String, place: String, startYear: Int, startMonth: Int, startDay: Int, startHour: Int, startMinute: Int, endHour: Int, endMinute: Int) -> Bool {
        
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = "yyyy/MM/dd HH:mm"
        
        guard let startDate = dateFormater.date(from: "\(startYear)/\(startMonth)/\(startDay) \(startHour):\(startMinute)") else {
            self.alertPresent(messageItem: "開始時刻")
            return false
        }
        
        guard let endDate = dateFormater.date(from: "\(startYear)/\(startMonth)/\(startDay) \(endHour):\(endMinute)") else {
            self.alertPresent(messageItem: "終了時刻")
            return false
        }
        
        if endDate < startDate {
            let alert = UIAlertController(title: "エラー", message: "開始時刻と終了時刻が反対ではないでしょうか？", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
            return false
        }
        
        
        let dateObject = dateDataController.setObject()
        dateObject.eventTitle = title
        dateObject.eventPlace = place
        dateObject.startDate = startDate
        dateObject.endDate = endDate
        //ここでブッキングしているフラグの回収が必要
        if dateDataController.addData(addItem: dateObject) {
            dateDataController.dataSave()
        } else {
            return false
        }
        
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let goVC = segue.destination as! ScheduleViewController
        let identifier = segue.identifier
        if identifier == "goWithThisDate" {
            print("yahoo")
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func change(_ sender: Any) {
        
    }
    
    @IBAction func remove(_ sender: Any) {
        dateDataController.removeData(flag: self.setFlag)
        dateDataController.dataSave()
        //(UIApplication.shared.delegate as! AppDelegate).saveContext()
        self.dismiss(animated: true, completion: nil)
    }
    
    func recieveButtonBool(){
        self.saveButton.isEnabled = self.saveButtonBool
        self.changeButton.isEnabled = self.changeButtonBool
        self.removeButton.isEnabled = self.removeButtonBool
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
