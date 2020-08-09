//
//  Date.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/9.
//

import Foundation

extension Date {
    
    public func dateByAddingDays(days: Int) -> Date {
        if days == 0 { return self }
        
        var components = DateComponents()
        components.day = days
        return CONSTANT.gregorianCalendar.date(byAdding: components, to: self)!
    }
    
    public func matchesDateComponents(date: Date, components: Set<Calendar.Component> = [.day, .month, .year]) -> Bool {
        if date == self { return true }
        
        let dateComponents = CONSTANT.gregorianCalendar.dateComponents(components, from: self)
        let anotherDateComponents = CONSTANT.gregorianCalendar.dateComponents(components, from: date)
        return dateComponents == anotherDateComponents
    }
    
    public var beginning: Date {
        var components = CONSTANT.gregorianCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return CONSTANT.gregorianCalendar.date(from: components)!
    }
    
    public var end: Date {
        var components = CONSTANT.gregorianCalendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return CONSTANT.gregorianCalendar.date(from: components)!
    }

    public var stringWithMMddYYYY: String {
        return stringWithFormat("MM/dd/YYYY")
    }

    public var stringWithyyyyMMdd: String {
        return stringWithFormat("yyyy-MM-dd")
    }

    public var stringWithyyyyMMddTHHmmssSZ: String {
        return stringWithFormat("yyyy-MM-dd'T'HH:mm:ss.SZ")
    }

    public func stringWithFormat(_ format: String) -> String {
        let formatter = CONSTANT.dateFormatter
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
