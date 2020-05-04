//
//  ViewController.swift
//  newCALENDAR
//
//  Created by ユーザー名 on 2019/11/17.
//  Copyright © 2019年 ユーザー名. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var year: Int = 0
    var month: Int = 0
    var day: Int = 0
    var weekday: Int = 0
    
    var nowYear = 0
    var nowMonth = 0
    var nowDay = 0
    var nowWeekday = 0
    
    var nowControllDay = 0
    var nowControllWeekday = 0
    
    var lastDay = 0
    var lastWeekday = 0
    var firstWeekday = 0
    var startPoint = 0
    var lastPoint = 0
    
    let width: CGFloat = UIScreen.main.bounds.width
    var cellWidth: CGFloat!
    var firstLabel = [UILabel]()
    var secondLabel = [UILabel]()
    var thirdLabel = [UILabel]()
    var forthLabel = [UILabel]()
    
    @IBOutlet var firstView: UIView!
    @IBOutlet var secondView: UIView!
    @IBOutlet var thirdView: UIView!
    @IBOutlet var forthView: UIView!
    
    
    @IBOutlet var navigationBarItem: UINavigationItem!
    
    let weekdayString = ["日","月","火","水","木","金","土"]
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var artView: UIView!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var toolbar: UIToolbar!
    
    func setDate(year: inout Int, month: inout Int, day: inout Int, weekday: inout Int) {
        let date = Date()
        let calendar = Calendar.current
        year = calendar.component(Calendar.Component.year, from: date)
        month = calendar.component(Calendar.Component.month, from: date)
        day = calendar.component(Calendar.Component.day, from: date)
        weekday = calendar.component(Calendar.Component.weekday, from: date)
    }
    
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
    
    func getLastWeekday(lastDay: Int, day: Int, weekday: Int)  -> Int{
        let subPerDay = (lastDay - day) % 7
        let checkDay = weekday + subPerDay
        if checkDay > 7 {
            return checkDay - 7
        }
        return checkDay
    }
    
    func getFirstWeekday(day: Int, weekday: Int) -> Int {
        let percentDay = day % 7
        let checkDay = weekday - percentDay + 1
        if checkDay < 1 {
            return 7 + checkDay
        } else if checkDay > 7 {
            return checkDay - 7
        } else {
            return checkDay
        }
    }
    
    func getNowControllWeekday() -> Int {
        let percent = self.nowControllDay % 7
        let checkDay = self.firstWeekday + percent - 1
        if checkDay == 0 {
            return 7
        }else if checkDay > 7 {
            return checkDay - 7
        }else{
            return checkDay
        }
    }
    
    func setLabelArray(labelArray:inout [UILabel],settingView: UIView) -> [UILabel] {
        //ここ考える必要あり
        let labelWidth = 25
        let labelHeight = 30
        
        for i in 0...14 {
            let line:Int = i / 3
            let row:Int = i % 3
            let xPosition = CGFloat(labelWidth * row)
            let yPosition = CGFloat(labelWidth * line)
            let rect = CGRect(x: xPosition, y: yPosition, width: CGFloat(labelWidth), height: CGFloat(labelHeight))
            let label = UILabel()
            settingView.addSubview(label)
            label.frame = rect
            label.text = "aaa"
            label.adjustsFontSizeToFitWidth = true
            labelArray.append(label)
        }
        
        return labelArray
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(dateDataController.myDate[0])
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.nowLoading()
        self.view.backgroundColor = UIColor.gray
        self.collectionView.backgroundColor = UIColor.gray
        self.cellWidth = (self.width - 10) / 7
        
        self.firstLabel = setLabelArray(labelArray: &firstLabel, settingView: firstView)
        self.secondLabel = setLabelArray(labelArray: &secondLabel, settingView: secondView)
        self.thirdLabel = setLabelArray(labelArray: &thirdLabel, settingView: thirdView)
        self.forthLabel = setLabelArray(labelArray: &forthLabel, settingView: forthView)
        
        self.firstView.backgroundColor = UIColor.gray
        
        for item in dateDataController.myDate {
            print(item.startDate)
        }
    }
    
    func nowLoading(){
        self.setDate(year: &self.year, month: &self.month, day: &self.day, weekday: &self.weekday)
        self.loading()
        self.nowYear = self.year
        self.nowMonth = self.month
        self.nowDay = self.day
        self.nowWeekday = self.weekday
    }
    
    func loading() {
        self.lastDay = self.getLastDayOfMonth(month: self.month, year: self.year)
        self.lastWeekday = self.getLastWeekday(lastDay: self.lastDay, day: self.day, weekday: self.weekday)
        self.firstWeekday = self.getFirstWeekday(day: self.day, weekday: self.weekday)
        self.startPoint = self.getStartPoint(firstWeekday: self.firstWeekday)
        self.lastPoint = self.getLastPoint(startPoint: self.startPoint, lastDayOfMonth: self.lastDay)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let startPoint = self.getStartPoint(firstWeekday: self.firstWeekday)
        let lastPoint = self.getLastPoint(startPoint: startPoint, lastDayOfMonth: self.lastDay)
        var numberOfCell: Int!
        var height :CGFloat!
    
        if lastPoint > 41 {
            numberOfCell = 49
            height = 7 * self.cellWidth
        }else if lastPoint > 34 {
            numberOfCell = 42
            height = 6 * self.cellWidth
        }else{
            numberOfCell = 35
            height = 5 * self.cellWidth
        }
        
        let toolbarYPosition = self.toolbar.frame.origin.y
        let collectionViewYPosition = toolbarYPosition - height - 15
        let collectionViewSize = CGSize(width: self.width - 10, height: height)
        let collectionViewPoint = CGPoint(x: 5, y: collectionViewYPosition)
        collectionView.frame = CGRect(origin: collectionViewPoint, size: collectionViewSize)
        self.navigationBarItem.title = "\(self.year)年　\(self.month)月"
        
        self.setArtView(collectionViewYPosition)

        return numberOfCell

    }
    
    func setArtView(_ collectionViewYPosition: CGFloat) {
        let artViewHeight: CGFloat = 150
        let artViewWidth: CGFloat = 360
        let navigationBarBottomYPosition = self.navigationBar.frame.size.height + self.navigationBar.frame.origin.y
        let artViewYPosition: CGFloat =  (collectionViewYPosition - navigationBarBottomYPosition - artViewHeight) / 2 + navigationBarBottomYPosition
        let artViewXPosition: CGFloat = (self.width - artViewWidth) / 2
        self.artView.frame = CGRect(x: artViewXPosition, y: artViewYPosition, width: artViewWidth, height: artViewHeight)
        
        let firstNumber: Int = self.year / 1000
        var rest: Int = self.year % 1000
        let secondNumber: Int = rest / 100
        rest = rest % 100
        let thirdNumber: Int = rest / 10
        rest = rest % 10
        
        self.setArtPerView(labelArray: &self.firstLabel, number: firstNumber)
        self.setArtPerView(labelArray: &self.secondLabel, number: secondNumber)
        self.setArtPerView(labelArray: &self.thirdLabel, number: thirdNumber)
        self.setArtPerView(labelArray: &self.forthLabel, number: rest)
    }
    
    func setArtPerView(labelArray: inout [UILabel],number: Int){
        for i in 0...14 {
            if self.compareNumberWithI(number: number, i: i){
                labelArray[i].text = "\(self.month)月"
            }else{
                labelArray[i].text = ""
            }
        }
    }
    
    func compareNumberWithI(number: Int, i: Int) -> Bool {
        switch number {
        case 0:
            if i == 4 || i == 7 || i == 10{
                return false
            }else{
                return true
            }
            
        case 1:
            if i == 1 || i == 4 || i == 7 || i == 10 || i == 13{
                return true
            }else{
                return false
            }
            
        case 2:
            if i == 3 || i == 4 || i == 10 || i == 11{
                return false
            }else{
                return true
            }
            
        case 3:
            if i == 3 || i == 4 || i == 9 || i == 10{
                return false
            }else{
                return true
            }
            
        case 4:
            if i == 2 || i == 5 || i == 9 || i == 11 || i == 12 || i == 14{
                return false
            }else{
                return true
            }
            
        case 5:
            if i == 4 || i == 5 || i == 9 || i == 10{
                return false
            }else{
                return true
            }
            
        case 6:
            if i == 4 || i == 5 || i == 10{
                return false
            }else{
                return true
            }
            
        case 7:
            if i == 0 || i == 1 || i == 2 || i == 5 || i == 8 || i == 11 || i == 14{
                return true
            }else{
                return false
            }
            
        case 8:
            if i == 4 || i == 10{
                return false
            }else{
                return true
            }
            
        case 9:
            if i == 4 || i == 9 || i == 10{
                return false
            }else{
                return true
            }
            
        default:
            print("number error")
            return false
        }
    }
    
    func isShouldDay(_ indexPath: IndexPath, startPoint: Int, lastPoint: Int) -> Bool {
        if indexPath.row >= startPoint && indexPath.row <= lastPoint{
            return true
        }
        return false
    }
    
    func getStartPoint(firstWeekday: Int) -> Int {
        return firstWeekday + 6
    }
    
    func getLastPoint(startPoint: Int, lastDayOfMonth: Int) -> Int {
        return startPoint + lastDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellWidth, height: self.cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let label = cell.contentView.viewWithTag(1) as! UILabel
        label.textColor = UIColor.white
        if indexPath.row <= 6{
            cell.backgroundColor = UIColor.gray
            label.text = self.weekdayString[indexPath.row]
            cell.layer.borderWidth = 0
        }else{
            if isShouldDay(indexPath, startPoint: startPoint, lastPoint: lastPoint) {
                let nowControllDay = indexPath.row - startPoint + 1
                label.text = String(nowControllDay)
                
            }else{
                label.text = nil
            }
            
            if indexPath.row % 7 == 0   /*ここに休日情報取得時の背景色についての記述を追加*/  {
                cell.backgroundColor = UIColor.red
            }else if indexPath.row % 7 == 6{
                cell.backgroundColor = UIColor.blue
            }else{
                cell.backgroundColor = UIColor.black
            }
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 0.7
        }
        
        
        if indexPath.row - startPoint + 1 == nowDay && month == nowMonth && nowYear == year{
            cell.backgroundColor = UIColor.orange
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.nowControllDay = indexPath.row - self.startPoint + 1
        self.nowControllWeekday = self.getNowControllWeekday()
        self.performSegue(withIdentifier: "goWithTouchCellDate", sender: nil)
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
            self.day = self.getLastDayOfMonth(month: month, year: year)
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
    
    @IBAction func goPreviousMonth(_ sender: Any) {
        self.weekday = firstWeekday
        self.day = 1
        self.goPreviousDay()
        self.loading()
        self.collectionView.reloadData()
    }
    
    @IBAction func goNextMonth(_ sender: Any) {
        self.weekday = self.lastWeekday
        //print("chek:\(weekday)")
        self.day = self.lastDay
        self.goNextDay()
        self.loading()
        //print("weekday:\(weekday) month:\(month) day:\(day) startPoint:\(startPoint)")
        self.collectionView.reloadData()
    }
    
    @IBAction func tapCalendarButton(_ sender: Any) {
        self.nowLoading()

        self.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "goWithNowDate" {
                let goVC = segue.destination as! ScheduleViewController
                var year: Int = 0
                var month: Int = 0
                var day: Int = 0
                var weekday: Int = 0
                self.setDate(year: &year, month: &month, day: &day, weekday: &weekday)
                goVC.year = year
                goVC.month = month
                goVC.day = day
                goVC.weekday = weekday
                
            }else if identifier == "goWithTouchCellDate" {
                let goVC = segue.destination as! ScheduleViewController
                goVC.year = self.year
                goVC.month = self.month
                goVC.day = self.nowControllDay
                goVC.weekday = self.nowControllWeekday
                
            }else if identifier == "goAddEventVCfromVC" {
                let goVC = segue.destination as! AddEventViewController
                var year: Int = 0
                var month: Int = 0
                var day: Int = 0
                var weekday: Int = 0
                self.setDate(year: &year, month: &month, day: &day, weekday: &weekday)
                goVC.setYear = year
                goVC.setMonth = month
                goVC.setDay = day
                goVC.saveButtonBool = true
                goVC.changeButtonBool = false
                goVC.removeButtonBool = false
                
            }else{
                print("error identifier")                
            }
        }else{
            print("error segue")
            return
        }
    }
    
}


