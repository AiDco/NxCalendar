//
//  NxCalendarConfiguration.swift
//  NxCalendar
//
//  Created by Maxim Soroka on 09.01.2022.
//

public struct NxCalendarConfiguration {
    public let calendarType: CalendarType
    public let showDatesOutMonth: Bool
    public let isMonthSwitchingEnabled: Bool
    public let didSelectDateCompletionHandler: (Date) -> Void

    public init(
        calendarType: CalendarType,
        showDatesOutMonth: Bool,
        isMonthSwitchingEnabled: Bool,
        didSelectDateCompletionHandler: @escaping (Date) -> (Void)
    ) {
        self.calendarType = calendarType
        self.showDatesOutMonth = showDatesOutMonth
        self.isMonthSwitchingEnabled = isMonthSwitchingEnabled
        self.didSelectDateCompletionHandler = didSelectDateCompletionHandler
    }
    
    public enum CalendarType {
        case session([SessionDestination], selectedDate: Date)
        case wellbeing([WellbeingDestinnation])
    }
    
    public enum SessionDestination {
        case busyDate(Date)
        case busyDates(from: Date, to: Date)
    }
    
    public enum WellbeingDestinnation {
        case selectedDate(date: Date, dayType: Day.DayType.Wellbeing)
        case selectedDates(from: Date, to: Date, daysType: Day.DayType.Wellbeing)
    }
}
