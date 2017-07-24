//
//  AgeRangeCalculator.swift
//  newretour
//  Helps calculate stuff like the age range integer from the incoming NSDate
//
//  Created by Paul Lancashire on 03/06/2016.
//  Copyright © 2016 Paul Lancashire. All rights reserved.
//

import Foundation

class AgeRangeCalculator: NSObject {
    
    var parseDateFormat = DateFormatter()
    
    var birthdayTimeInt = TimeInterval()
    
    var sixteenYears = TimeInterval()
    var thirtyYears = TimeInterval()
    var thirtyOneYears = TimeInterval()
    var fortyFiveYears = TimeInterval()
    var sixtyYears = TimeInterval()
    
    override init() {
        
        parseDateFormat.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        sixteenYears = 504576000
        thirtyYears =  946080000
        thirtyOneYears = 977616000
        fortyFiveYears = 1419120000
        sixtyYears = 1892160000
    }
    
    func returnAgeRangeInt(userBirthdayParseString: String) -> Int {
        
        // NSDateFormatter to NSDate
        let incomingUserBirthday = parseDateFormat.date(from: userBirthdayParseString)
        print("incoming birthday after conversion = \(incomingUserBirthday)")
        // NSDate to NSTimeInterval
        birthdayTimeInt = NSDate().timeIntervalSince(incomingUserBirthday!)
        print("time interval since birth is \(birthdayTimeInt)")
        
        var returnRangeInt: Int?
        
        if birthdayTimeInt > sixteenYears && birthdayTimeInt < thirtyYears {
        print("incoming birthday is between 16 and 30")
            returnRangeInt = 1
        }
        
        if birthdayTimeInt > thirtyOneYears && birthdayTimeInt < fortyFiveYears {
            print("incoming birthday is between 31 and 45")
            returnRangeInt = 2
        }
        
        if birthdayTimeInt > fortyFiveYears && birthdayTimeInt < sixtyYears {
            print("incoming birthday is between 45 and 60")
            returnRangeInt = 3
        }
        
        if birthdayTimeInt > sixtyYears {
            print("incoming birthday is over 60")
            returnRangeInt = 4
        }
        
        return returnRangeInt!
    }
    
    // functions to return NSDate values for comparison
    
    func returnLowerInterval(int: Int) -> NSDate {
        var dateReturn: NSDate?
        
        // if age range between 16 and 30
        if int == 1 {
        
            let date = NSDate(timeIntervalSinceNow: -sixteenYears)
            dateReturn = date
        }
        
        // if age range between 31 and 45
        if int == 2 {
        
            let date = NSDate(timeIntervalSinceNow: -thirtyOneYears)
            dateReturn = date
        }
        
        // if age range between 45 and 60
        if int == 3 {
    
            let date = NSDate(timeIntervalSinceNow: -fortyFiveYears)
            dateReturn = date
        }
        
        
        // if age range is over 60
        if int == 4 {
        
            let date = NSDate(timeIntervalSinceNow: -sixtyYears)
            dateReturn = date
        }
        
        
        return dateReturn!
    }
    
    func returnUpperInterval(int: Int) -> NSDate {
        var dateReturn: NSDate?
        
        // if age range between 16 and 30
        if int == 1 {
            let date = NSDate(timeIntervalSinceNow: -thirtyYears)
            dateReturn = date
        }
        
        // if age range between 31 and 45
        if int == 2 {
            let date = NSDate(timeIntervalSinceNow: -fortyFiveYears)
            dateReturn = date
        }
        
        // if age range between 45 and 60
        if int == 3 {
            let date = NSDate(timeIntervalSinceNow: -sixtyYears)
            dateReturn = date
        }
        
        // if age range is over 60
        if int == 4 {
            dateReturn = NSDate(timeIntervalSinceNow: -1000000000000000000)
        }
        
        return dateReturn!
    }
    
}
