//
//  Date.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/9.
//

import Foundation

extension Formatter {

    /* Used for swift >= 4.0
     For swift <= 3.0.2
     static let iso8601: DateFormatter = {
     let formatter = DateFormatter()
     formatter.calendar = Calendar(identifier: .iso8601)
     formatter.locale = Locale(identifier: "en_US_POSIX")
     formatter.timeZone = TimeZone(secondsFromGMT: 0)
     formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
     return formatter
     }()
     */
    public static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    public static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = CONSTANT.enUSLocale
        dateFormatter.calendar = CONSTANT.gregorianCalendar
        return dateFormatter
    }()
}

extension Date {

    // 2020-08-31T15:36:20.022Z
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {

    // 2020-08-31T15:36:20.022Z
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}

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
    
    public var beginningOfDay: Date {
        return CONSTANT.gregorianCalendar.startOfDay(for: self)
    }
    
    public var endOfDay: Date {
        let calendar = CONSTANT.gregorianCalendar
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .timeZone], from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components)!
    }

    public var beginningOfMonth: Date {
        let calendar = CONSTANT.gregorianCalendar
        var dateComponent = calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self))
        dateComponent.hour = 12
        dateComponent.minute = 0
        dateComponent.second = 0
        return calendar.date(from: dateComponent)!
    }

    public var endOfMonth: Date {
        return CONSTANT.gregorianCalendar.date(byAdding: DateComponents(month: 1, day: -1), to: beginningOfMonth)!
    }

    // 08/26/2020
    public var stringWithMMddyyyy: String {
        return stringWithFormat("MM/dd/yyyy")
    }

    // 2020-08-26
    public var stringWithyyyyMMdd: String {
        return stringWithFormat("yyyy-MM-dd")
    }

    // Aug 26, 22:52 PM
    public var stringWithMMMdHmma: String {
        return stringWithFormat("MMM d, H:mm a")
    }

    // August 2020
    public var stringWithMMMMyyyy: String {
        return stringWithFormat("MMMM yyyy")
    }

    // Aug 26, 2020
    public var stringWithMMMdyyyy: String {
        return stringWithFormat("MMM d, yyyy")
    }

    // 2020-08-26T22:52:30.7+0800
    public var stringWithyyyyMMddTHHmmssSZ: String {
        return stringWithFormat("yyyy-MM-dd'T'HH:mm:ss.SZ")
    }

    // Wednesday, Aug 26, 2020
    public var stringWithEEEEMMMdyyyy: String {
        return stringWithFormat("EEEE, MMM d, yyyy")
    }

    public func stringWithFormat(_ format: String) -> String {
        let formatter = Formatter.dateFormatter
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    // 8/26/20, 10:52 PM
    // Date: 8/26/20
    // Time: 10:52 PM
    public var stringWithShortStyle: String {
        return stringWithDateStyle(.short, .short)
    }

    // Aug 26, 2020 at 10:52:30 PM
    // Date: Aug 26, 2020
    // Time: 10:52:30 PM
    public var stringWithMediumStyle: String {
        return stringWithDateStyle(.medium, .medium)
    }

    // August 26, 2020 at 10:52:30 PM GMT+8
    // Date: August 26, 2020
    // Time: 10:52:30 PM GMT+8
    public var stringWithLongStyle: String {
        return stringWithDateStyle(.long, .long)
    }

    // Wednesday, August 26, 2020 at 10:52:30 PM China Standard Time
    // Date: Wednesday, August 26, 2020
    // Time: 10:52:30 PM China Standard Time
    public var stringWithFullStyle: String {
        return stringWithDateStyle(.full, .full)
    }

    public func stringWithDateStyle(_ dateStyle: DateFormatter.Style = .none, _ timeStyle: DateFormatter.Style = .none) -> String {
        let formatter = Formatter.dateFormatter
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
}

extension String {

    public func dateWithFormat(_ format: String) -> Date? {
        let formatter = Formatter.dateFormatter
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
