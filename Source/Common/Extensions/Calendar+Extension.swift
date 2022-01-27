//
//  Calendar+Extension.swift
//  NxCalendar
//
//  Created by Maxim Soroka on 10.01.2022.
//

extension Calendar {
    func firstDayOfMonth(for date: Date) -> Date? {
        self.date(
            from: Calendar.current.dateComponents(
                [.year, .month],
                from: date
            )
        )
    }
}
