//
//  NxCalendarViewDelegate.swift
//  NxCalendar
//
//  Created by Maxim Soroka on 28.01.2022.
//

public protocol NxCalendarViewDelegate: AnyObject {
    func wellbeingDates(for newMonthNumber: Int) -> [NxCalendarConfiguration.WellbeingDestinnation]
    func sessionDates(for newMonthNumber: Int) -> [NxCalendarConfiguration.SessionDestination]
}

public extension NxCalendarViewDelegate {
    func wellbeingDates(for newMonthNumber: Int) -> [NxCalendarConfiguration.WellbeingDestinnation] { [] }
    func sessionDates(for newMonthNumber: Int) -> [NxCalendarConfiguration.SessionDestination] { [] }
}
