//
//  Date_Ext.swift
//  Domain
//
//  Created by thanos kottaridis on 5/2/23.
//

import Foundation

extension Date {
    /// Returns the amount of years from another date
    public func years(from date: Date, absValue: Bool = false) -> Int {
        if absValue {
            return abs(Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0)
        } else {
            return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
        }
    }
    /// Returns the amount of months from another date
    public func months(from date: Date, absValue: Bool = false) -> Int {
        if absValue {
            return abs(Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0)
        } else {
            return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
        }
    }
    /// Returns the amount of weeks from another date
    public func weeks(from date: Date, absValue: Bool = false) -> Int {
        if absValue {
            return abs(Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0)
        } else {
            return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
        }
    }
    /// Returns the amount of days from another date
    public func days(from date: Date, absValue: Bool = false) -> Int {
        if absValue {
            return abs(Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0)
        } else {
            return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
        }
    }
    /// Returns the amount of hours from another date
    public func hours(from date: Date, absValue: Bool = false) -> Int {
        if absValue {
            return abs(Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0)
        } else {
            return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
        }
    }
    /// Returns the amount of minutes from another date
    public func minutes(from date: Date, absValue: Bool = false) -> Int {
        if absValue {
            return abs(Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0)
        } else {
            return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
        }
    }
    /// Returns the amount of seconds from another date
    public func seconds(from date: Date, absValue: Bool = false) -> Int {
        if absValue {
            return abs(Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0)
        } else {
            return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
        }
    }
    
    /// Returns the a custom time interval description from another date
    public func geCountDownOffset(from date: Date, absValue: Bool = false) -> String {
        // Check if time needs over one day
        if years(from: date, absValue: absValue)   > 0 { return getDisplayableString(value: years(from: date), type: "years") }
        if months(from: date, absValue: absValue)  > 0 { return getDisplayableString(value: months(from: date), type: "months") }
        if days(from: date, absValue: absValue)    > 0 { return getDisplayableString(value: days(from: date), type: "days") }
        
        // else create countdown string if event is upcoming
        let hours = hours(from: date)
        if hours < 0 { return getDisplayableString(value: hours, type: "hours") }
        
        let minutes = minutes(from: date)
        if minutes < 0 { return getDisplayableString(value: minutes, type: "minutes") }
        
        let seconds = seconds(from: date)
        if  seconds < 0 { return getDisplayableString(value: seconds, type: "seconds") }
        
        return String(format: "%02d:%02d:%02d", hours, minutes % 60, seconds % 60) + " left"
    }
    
    private func getDisplayableString(value: Int, type: String) -> String {
        if value > 0 {
            return "\(abs(value)) \(type) left" 
        } else {
            return "\(abs(value)) \(type) before"
        }
    }
}
