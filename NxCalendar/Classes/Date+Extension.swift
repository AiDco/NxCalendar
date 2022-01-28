//
//  Date+Extension.swift
//  NxCalendar
//
//  Created by Maxim Soroka on 28.12.2021.
//

extension Date {
    var erasedFormat: Date? {
        Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.day, .month, .year],
                from: self
            )
        )
    }
    
    static func erasedFormat(of date: Date) -> Date? {
        Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.day, .month, .year],
                from: date
            )
        )
    }
    
    static func dates(from startDate: Date, to endDate: Date) -> [Date] {
        var date = startDate
        var dates: [Date] = [date.erasedFormat ?? date]
        
        while date < endDate {
            guard let x = Calendar.current.date(byAdding: .day, value: 1, to: date),
                  let newDate = Calendar.current.date(
                    from: Calendar.current.dateComponents(
                        [.month, .year, .day],
                        from: x
                    )
                  ) else { break }
            date = newDate
            dates.append(date)
        }
        
        return dates
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
