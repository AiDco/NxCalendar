//
//  Array+Extension.swift
//  NxCalendar
//
//  Created by Maxim Soroka on 28.01.2022.
//

extension Array where Element == (Date, Day.DayType) {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(where: { $0 == item }) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}
