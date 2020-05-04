//
//  File.swift
//  newCALENDAR
//
//  Created by ユーザー名 on 2019/12/06.
//  Copyright © 2019年 ユーザー名. All rights reserved.
//

import UIKit
import CoreData


class DataManagement {
    
    var myDate = [DateData]()
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        self.DataUpLoad()
    }

    func DataUpLoad(){
        let conditions = NSFetchRequest<NSFetchRequestResult>(entityName: "DateData")
        do {
            self.myDate = try managedObjectContext.fetch(conditions) as! [DateData]
        }catch {
            print("fetch error")
        }
    }
    
    
    func setNumberOfDate() -> Int {
        var setYear: Int!
        var setMonth: Int!
        var setDay: Int!
        var count = 0
        
        for i in 0..<self.myDate.count {
            guard let date = self.myDate[i].startDate else {
                //ここでアラート
                return -1
            }
            
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            if i == 0 {
                setYear = year
                setMonth = month
                setDay = day
                count += 1
                continue
            }
            
            if year == setYear && month == setMonth && day == setDay {
                continue
            }else{
                setYear = year
                setMonth = month
                setDay = day
                count += 1
                continue
            }
        }
        return count
    }

    func dataSave(){
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    func setObject() -> DateData {
        let object = DateData(context: self.managedObjectContext)
        return object
    }


    func normalDoubleBookingCheck(newItem: DateData, oldItem: DateData) -> Bool {
        //問題無ければtrueを返す
        //newItemが追加や変更したいデータ
        //oldItemが元データ
        if newItem.startDate! >= oldItem.endDate! || newItem.endDate! <= oldItem.startDate! {
            return true
        }
        return false
    }
    
    func returnFlagArrayForAdd(newItem: DateData) -> [Int] {
        var flagArray = [Int]()
        for i in 0..<self.myDate.count {
            if normalDoubleBookingCheck(newItem: newItem, oldItem: self.myDate[i]){
                continue
            }
            flagArray.append(i)
        }
        return flagArray
    }
    
    func returnDoubleBookingArrayForEdit(newItem: DateData, flag: Int) -> [Int] {
        var flagArray = [Int]()
        for i in 0..<self.myDate.count {
            if i == flag || normalDoubleBookingCheck(newItem: newItem, oldItem: self.myDate[i]) {
                continue
            }
            flagArray.append(i)
        }
        return flagArray
    }
    
    //被った予定を配列で返す
    //これを表で使う
    func addData(addItem: DateData) -> Bool {
        let doubleBookingFlagArray = self.returnFlagArrayForAdd(newItem: addItem)
        if doubleBookingFlagArray.count == 0 {
            let index = self.setInsertIndex(newItem: addItem)
            if index == -1 {
                print("error")
            }
            self.myDate.insert(addItem, at: index)
        } else {
            //上書き
            return false
        }
        return true
    }

    
    func overwriteData(flagArray: [Int]) {
        var i = flagArray.count
        while i >= 0 {
            i -= 1
            self.myDate.remove(at: flagArray[i])
        }
    }
    
    func removeData(flag: Int){
        let object = self.myDate[flag]
        self.managedObjectContext.delete(object)
        self.myDate.remove(at: flag)
    }
    
    func setInsertIndex(newItem: DateData) -> Int {
        guard let newDate = newItem.startDate else {
            //予期せぬエラー
            return -1
        }
        
        let lastPoint = myDate.count - 1
        
        if lastPoint == -1 {
            return 0
        }
        
        guard var firstDate = myDate[0].startDate else {
            //予期せぬエラー
            return -1
        }
        
        if newDate <= firstDate {
            return 0
        } else if lastPoint == 0 {
            return 1
        }else {
            //do nothing
        }
        
        guard var secondDate = myDate[1].startDate else {
            //予期せぬエラー
            return -1
        }
        
        for i in 1...lastPoint {
            if firstDate <= newDate && newDate <= secondDate {
                return i
            }
            firstDate = secondDate
            if i + 1 <= lastPoint{
                guard let date = myDate[i+1].startDate else {
                    break
                }
                secondDate = date
            }
        }
        return lastPoint + 1
    }
}

struct dateStruct {
    
}
