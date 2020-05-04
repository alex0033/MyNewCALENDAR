//
//  ScheduleViewController.swift
//  newCALENDAR
//
//  Created by ユーザー名 on 2019/12/08.
//  Copyright © 2019年 ユーザー名. All rights reserved.
//

import UIKit
import CoreData

protocol tapAcionDelegate {
    var flag: Int { get }
    func tapAction()
}

class ScheduleViewController: UIViewController, tapAcionDelegate {
    var flag: Int = -1

    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var navigationBarItem: UINavigationItem!
    @IBOutlet var cv: customView!
    
    let weekdayString = ["日","月","火","水","木","金","土"]
    
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    var weekday: Int = 0
    
    var nowYear = 0
    var nowMonth = 0
    var nowDay = 0
    var nowWeekday = 0
    
    var lastDay = 0
    var lastWeekday = 0
    var firstWeekday = 0
    
    var eventViewArray = [eventView]()
    
    func loading() {
        self.lastDay = getLastDayOfMonth(month: month, year: year)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventViewArray.removeAll()
        var todayDataFlagArray = [Int]()
        // Do any additional setup after loading the view.
        self.loading()
        
        let width = UIScreen.main.bounds.width
        self.navigationBarItem.title = "\(year)年\(month)月\(day)日(\(weekdayString[weekday - 1]))"
        
        self.cv = customView()
        self.scrollView.addSubview(cv)
        self.cv.setRect(width: width)
        self.scrollView.contentSize = cv.frame.size
        self.cv.backgroundColor = UIColor.white
        print(dateDataController.myDate.count)
        //dateDataController.DataUpLoad()
        print(dateDataController.myDate.count)
        todayDataFlagArray = self.todayDataFlagSet()
        for item in 0..<todayDataFlagArray.count{
            //ここでeventViewを作成
            let eventV = cv.makeEventView(toDayDataArrayItem: dateDataController.myDate[todayDataFlagArray[item]],flag: todayDataFlagArray[item])
            self.cv.addSubview(eventV)
            eventV.delegate = self
            self.eventViewArray.append(eventV)
        }
        
    }
    
    func tapAction(){
        //どうやらここに問題がありそうな
        
        self.goEditSegue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func todayDataFlagSet() -> [Int] {
        var todayDataFlagArray = [Int]()
        for item in 0..<dateDataController.myDate.count {
            let calendar = Calendar.current
            
            guard let date = dateDataController.myDate[item].startDate else {
                //この日の予定に不備が有ります。
                //確認して下さい。
                //viewを付けておく
                return todayDataFlagArray
            }
            
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            if self.year == year && self.month == month && self.day == day{
                todayDataFlagArray.append(item)
            }
        }
        return todayDataFlagArray
    }
    
    @IBAction func goCalendar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getLastDayOfMonth(month: Int , year: Int) -> Int {
        if month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 {
            return 31
        }else if month == 4 || month == 6 || month == 9 || month == 11 {
            return 30
        }else if month == 2 && (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)){
            return 29
        }else{
            return 28
        }
    }
    
    func goNextDay(){
        if self.day < self.lastDay {
            self.day += 1
        }else{
            self.day = 1
            self.goNextMonth()
        }
        if self.weekday == 7 {
            self.weekday = 1
        }else{
            self.weekday += 1
        }
    }
    
    func goNextMonth() {
        if self.month == 12 {
            self.month = 1
            self.year += 1
        }else{
            self.month += 1
        }
    }
    
    func goPreviousDay() {
        if self.day == 1 {
            self.goPreviousMonth()
            self.day = getLastDayOfMonth(month: month, year: year)
        }else{
            self.day -= 1
        }
        if self.weekday == 1 {
            self.weekday = 7
        }else{
            self.weekday -= 1
        }
    }
    
    func goPreviousMonth() {
        if self.month == 1 {
            self.month = 12
            self.year -= 1
        }else{
            self.month -= 1
        }
    }
    
    @IBAction func goPreviousDayButton(_ sender: Any) {
        self.goPreviousDay()
        self.viewDidLoad()
    }
    
    @IBAction func goNextDayButton(_ sender: Any) {
        self.goNextDay()
        self.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifire = segue.identifier else {
            return
        }
        let goVC = segue.destination as! AddEventViewController
        if identifire == "goWithThisDate" {
            goVC.setYear = self.year
            goVC.setMonth = self.month
            goVC.setDay = self.day
            goVC.saveButtonBool = true
            goVC.changeButtonBool = false
            goVC.removeButtonBool = false
            
        }else if identifire == "editSegue" {
            goVC.setFlag = flag
            //ここでFlagの受け渡しが必要
            goVC.saveButtonBool = false
            goVC.changeButtonBool = true
            goVC.removeButtonBool = true
            
        }else{
            print("segue error")
        }
    }
    
    func goEditSegue(){
        self.performSegue(withIdentifier: "editSegue", sender: nil)
    }
    
    @IBAction func scheduleReload(_ sender: Any) {
        self.viewDidLoad()
    }
    
    
}

class customView: UIView {
    
    let topMargine: CGFloat = 30
    let bottomMargine: CGFloat = 30
    let interbalMargine: CGFloat = 48
    let leftMargine :CGFloat = 70
    var endPoint:CGFloat = 0
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    func setRect(width: CGFloat) {
        let height = 24 * self.interbalMargine + self.topMargine + self.bottomMargine
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.endPoint = width - 30
    }
    
    //    func getSize(width: CGFloat) -> CGSize {
    //        let size: CGSize = CGSize(width: width, height: 24 * interbalMargine + topMargine + bottomMargine)
    //        endPoint = width - 30
    //        return size
    //    }
    //後で修正
    
    
    func makeEventView(toDayDataArrayItem: DateData, flag: Int) -> eventView {
        let oneMinuteLength = self.interbalMargine / 60
        let eventV = eventView()
        
        let calendar = Calendar.current
        let startHour = calendar.component(.hour, from: toDayDataArrayItem.startDate!)
        let startMinute = calendar.component(.minute, from: toDayDataArrayItem.startDate!)
        let endHour = calendar.component(.hour, from: toDayDataArrayItem.endDate!)
        let endMinute = calendar.component(.minute, from: toDayDataArrayItem.endDate!)
        
        let sumOfStartMinute:CGFloat = CGFloat(startHour * 60 + startMinute)
        let sumOfEndMinute: CGFloat = CGFloat(endHour * 60 + endMinute)
        
        let x = self.leftMargine + 10
        let y = self.topMargine + sumOfStartMinute * oneMinuteLength
        let width = self.endPoint - x - 10
        let height = (sumOfEndMinute - sumOfStartMinute) * oneMinuteLength
        
        
        eventV.frame = CGRect(x: x, y: y, width: width, height: height)
        eventV.setEventLabel(eventItem: toDayDataArrayItem, width: width, height: height)
        eventV.backgroundColor = UIColor.init(red: 0, green: 30, blue: 60, alpha: 0.5)
        eventV.layer.borderColor = UIColor.black.cgColor
        eventV.layer.borderWidth = 1.0
        eventV.flag = flag
        return eventV
    }
    
    override func draw(_ rect: CGRect) {
        
        for i in 0...24 {
            let line = UIBezierPath()
            let yPosition = CGFloat(i) * self.interbalMargine + self.topMargine
            let textYPosition = yPosition - 7
            let timeLabel = UILabel(frame: CGRect(x: 15, y: textYPosition, width: 50, height: 14))
            timeLabel.text = "\(i):00"
            self.addSubview(timeLabel)
            line.move(to: CGPoint(x: self.leftMargine, y: yPosition))
            line.addLine(to: CGPoint(x: self.endPoint, y: yPosition))
            line.close()
            line.stroke()
        }
        
    }
    
}


class eventView: UIView {
    
    var flag: Int!
    var delegate :ScheduleViewController?
    
    func setEventLabel(eventItem: DateData, width: CGFloat, height: CGFloat) {
        let eventLabel = UILabel()
        self.addSubview(eventLabel)
        eventLabel.frame.origin = CGPoint(x: 0, y: 0)
        eventLabel.frame.size = CGSize(width: width, height: height)
        eventLabel.text = eventItem.eventTitle
        eventLabel.textAlignment = .center
        eventLabel.textColor = UIColor.black
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.flag = flag
        delegate?.tapAction()
        
    }
    
}

