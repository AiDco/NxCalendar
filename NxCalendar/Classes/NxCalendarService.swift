//
//  NxCalendarService.swift
//  NxCalendar
//
//  Created by Maxim Soroka on 23.12.2021.
//

import UIKit

final class NxCalendarService {
    // MARK: - Private Properties
    private var startDate: Date = Date()
    
    private var endDate: Date = Date()

    // MARK: - Properties
    let configuration: NxCalendarConfiguration
    
    var dates: [(Date, Day.DayType)] = []
    
    lazy var days: [Day] = generateDaysInMonth(for: currentDate)
    
    var currentDate: Date = Date() {
        didSet {
            didChangeCurrentDateCompletionHandler?(currentDate)
            days = generateDaysInMonth(for: currentDate)
        }
    }
    
    lazy var didChangeCurrentDateCompletionHandler: ((Date) -> Void)? = nil
    
    lazy var didSelectDateCompletionHandler: (IndexPath) -> (IndexPath?) = { [unowned self] indexPath in
        if !days[indexPath.row].isCurrentMonthDay
            && !configuration.showDatesOutMonth
            || days[indexPath.row].type == .session(.busy) { return nil }
        
        else if case .session(_, _) = configuration.calendarType {
            let beforeIndex = days.firstIndex { $0.isSelected == true }
            
            days = days.map {
                var day = $0
                day.isSelected = false
                return day
            }
            
            days[indexPath.row].isSelected = true
            
            if let index = beforeIndex {
                configuration.didSelectDateCompletionHandler()
                return IndexPath(item: index, section: 0)
            }
        } else if case .wellbeing(_) = configuration.calendarType {
            print(days[indexPath.row].date)
        }
        
        return nil
    }
    
    lazy var didPressLeftButtonArrowCompletionHandler: () -> Bool = { [unowned self] in
        let previousMonth = Calendar.current.date(
            byAdding: .month,
            value: -1,
            to: currentDate
        ) ?? currentDate
        
        let firstDayOfPreviousMonth = Calendar.current.firstDayOfMonth(for: previousMonth)
        
        let firstDayOfStartDateMonth = Calendar.current.firstDayOfMonth(for: startDate)
        
        if firstDayOfPreviousMonth == firstDayOfStartDateMonth &&
            !configuration.isMonthSwitchingEnabled {
            currentDate = previousMonth
            return false
        }
        
        currentDate = previousMonth
        return true
    }
    
    lazy var didPressRightButtonArrowCompletionHandler: () -> Bool = { [unowned self] in
        let nextMonth = Calendar.current.date(
            byAdding: .month,
            value: 1,
            to: currentDate
        ) ?? currentDate
        
        let firstDayOfNextMonth = Calendar.current.firstDayOfMonth(for: nextMonth)
        
        let firstDayOfEndDateMonth = Calendar.current.firstDayOfMonth(for: endDate)
        
        if firstDayOfNextMonth == firstDayOfEndDateMonth &&
            !configuration.isMonthSwitchingEnabled {
            currentDate = nextMonth
            return false
        }
        
        currentDate = nextMonth
        return true
    }
    
    lazy var dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    lazy var monthYearDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM y")
        return dateFormatter
    }()
    
    lazy var wellbeingDatesFromDestinationCompletionHandler: ([NxCalendarConfiguration.WellbeingDestinnation]) -> () = { [unowned self] destinations in
        dates += destinations
            .flatMap { destination -> [(Date, Day.DayType)] in
                switch destination {
                case let .selectedDate(date, dayType):
                    return [(date.erasedFormat ?? Date(), .wellbeing(dayType))]
                case let .selectedDates(startDate, endDate, daysType):
                    let dates: [Date]
                    
                    if startDate > endDate {
                        dates = Date.dates(from: endDate, to: startDate)
                    } else {
                        dates = Date.dates(from: startDate, to: endDate)
                    }
                    
                    return  dates.map { ($0, .wellbeing(daysType)) }
                }
            }
            .sorted { $0.0 < $1.0 }
        
        dates = dates.unique
    }
    
    lazy var sessionDatesFromDestinationCompletionHandler: ([NxCalendarConfiguration.SessionDestination], Date?) -> () = { [unowned self] destinations, selectedDate in
        dates += destinations
            .flatMap { destination -> [(Date, Day.DayType)] in
                switch destination {
                case let .busyDate(date):
                    return [(date.erasedFormat ?? Date(), .session(.busy))]
                case let .busyDates(startDate, endDate):
                    let dates: [Date]
                    
                    if startDate > endDate {
                        dates = Date.dates(from: endDate, to: startDate)
                    } else {
                        dates = Date.dates(from: startDate, to: endDate)
                    }
                    
                    if dates.contains(selectedDate?.erasedFormat ?? Date()) {
                        print("The selected date must be on a free day")
                    }
                    
                    return  dates.map { ($0, .session(.busy)) }
                }
            }
            .sorted { $0.0 < $1.0 }
        
        dates = dates.unique
    }
    
    // MARK: - Initialization
    init(with configuration: NxCalendarConfiguration) {
        self.configuration = configuration
        
        switch configuration.calendarType {
        case let .session(destinations, selectedDate):
            sessionDatesFromDestinationCompletionHandler(destinations, selectedDate)
        case let .wellbeing(destinations):
            wellbeingDatesFromDestinationCompletionHandler(destinations)
        }
        
        if let startDate = dates.first?.0,
           let endDate = dates.last?.0 {
           
            if case let .session(_, selectedDate) = configuration.calendarType {
                let date = selectedDate.erasedFormat ?? startDate
                self.startDate =  date < startDate ? date : startDate
            }
            
            self.currentDate = Calendar.current
                .firstDayOfMonth(for: self.startDate) ?? startDate
            self.endDate = endDate
        }
    }
    
    func generateDaysInMonth(for date: Date) -> [Day] {
        guard let metadata = monthMetadata(for: date) else {
            fatalError("An error occurred when generating the metadata for \(date)")
        }
        
        var days = (1..<(metadata.numberOfDays + metadata.firstWeekdayNumber))
            .map { day -> Day in
                let isCurrentMonthDay = day >= metadata.firstWeekdayNumber
                
                let dayOffset = isCurrentMonthDay
                ? day - metadata.firstWeekdayNumber
                : -(metadata.firstWeekdayNumber - day)
                
                return generateDay(
                    offsetBy: dayOffset,
                    for: metadata.firstDay,
                    isCurrentMonthDay: isCurrentMonthDay
                )
            }
        
        days += generateStartOfNextMonth(using: metadata.firstDay)
        
        days = days.map { day in
            var day = day
            
            if case let .session(_, selectedDate) = configuration.calendarType {
                day.isSelected = day.date == selectedDate.erasedFormat
            }
            
            if let date = dates.first(where: { day.date == $0.0}) {
                day.type = date.1
                return day
            }
            
            return day
        }
        
        return days
    }
}

// MARK: - Helpers
extension NxCalendarService {
    var numberOfWeeksInCurrentDate: Int {
        Calendar.current.range(of: .weekOfMonth, in: .month, for: currentDate)?.count ?? 0
    }
    
    var shortStandaloneWeekdaySymbols: [String] {
        var symbols = Calendar(identifier: .iso8601)
            .shortStandaloneWeekdaySymbols
        if Calendar.current.firstWeekday == 2 {
            symbols.append(symbols.removeFirst())
            return symbols
        }
        return symbols
    }
    
    var isLeftArrowButtonInitialEnabled: Bool {
        configuration.isMonthSwitchingEnabled
    }
    
    var isRightArrowButtonInitialEnabled: Bool {
        let firstDayOfStartDateMonth = Calendar.current.firstDayOfMonth(for: startDate)
        let firstDayOfEndDateMonth = Calendar.current.firstDayOfMonth(for: endDate)
        return !(firstDayOfStartDateMonth == firstDayOfEndDateMonth)
    }
}


// MARK: - Days Generator Logic Helpers
private extension NxCalendarService {
    func monthMetadata(for date: Date) -> MonthMetadata? {
        guard let numberOfDaysInMonth = Calendar.current.range(
            of: .day,
            in: .month,
            for: date
        )?.count,
              let firstDayOfMonth = Calendar.current.firstDayOfMonth(for: date)
        else { return nil }
        
        let firstWeekdayNumberOfMonth = weekdayNumber(from: firstDayOfMonth)
        
        return MonthMetadata(
            numberOfDays: numberOfDaysInMonth,
            firstDay: firstDayOfMonth,
            firstWeekdayNumber: firstWeekdayNumberOfMonth
        )
    }
    
    func generateStartOfNextMonth(
        using firstDayOfCurrentMonth: Date
    ) -> [Day] {
        guard let lastDayInMonth = Calendar.current.date(
            byAdding: DateComponents(month: 1, day: -1),
            to: firstDayOfCurrentMonth
        ) else { return [] }
        
        let additionalDays = 7 - weekdayNumber(from: lastDayInMonth)
        guard additionalDays > 0 else { return [] }
        
        let days: [Day] = (1...additionalDays).map {
            generateDay(
                offsetBy: $0,
                for: lastDayInMonth,
                isCurrentMonthDay: false
            )
        }
        
        return days
    }
    
    func generateDay(
        offsetBy dayOffset: Int,
        for date: Date,
        isCurrentMonthDay: Bool
    ) -> Day {
        let date = Calendar.current.date(
            byAdding: .day,
            value: dayOffset,
            to: date
        ) ?? currentDate
        
        let dayType: Day.DayType
        
        switch configuration.calendarType {
        case .wellbeing(_):
            dayType = .wellbeing(.unknown)
        case .session(_, _):
            dayType = .session(.free)
        }
        
        
        return Day(
            type: dayType,
            number: dayDateFormatter.string(from: date),
            date: date,
            isCurrentMonthDay: isCurrentMonthDay
        )
    }
    
    func weekdayNumber(from date: Date) -> Int {
        var weekday = Calendar.current.component(.weekday, from: date)
        if Calendar.current.firstWeekday == 2 {
            weekday = (weekday == 1) ? 7 : (weekday - 1)
        }
        return weekday
    }
}

