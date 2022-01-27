//
//  Day.swift
//  NxCalendar
//
//  Created by Maxim Soroka on 23.12.2021.
//

import UIKit

public struct Day {
    var type: DayType
    let number: String
    let date: Date
    let isCurrentMonthDay: Bool
    var isSelected: Bool = false
    
    public enum DayType: Equatable {
        case session(Session)
        case wellbeing(Wellbeing)
        
        public enum Session {
            case busy
            case free
        }
        
        public enum Wellbeing {
            case allDone
            case someDone
            case nothingDone
            case unknown
        }
    }
}

//public struct SessionDay: Day {
//    var type: `Type`
//    let number: String
//    let date: Date
//    let isCurrentMonthDay: Bool
//    var isSelected: Bool = false
//    
//    public enum `Type` {
//        case allDone
//        case someDone
//        case nothingDone
//        case unknown
//    }
//}
//
//public struct WellbeingDay: Day {
//    var type: `Type`
//    let number: String
//    let date: Date
//    let isCurrentMonthDay: Bool
//    var isSelected: Bool = false
//    
//    public enum `Type` {
//        case allDone
//        case someDone
//        case nothingDone
//        case unknown
//    }
//}
//
//protocol Day {
//    var number: String { get }
//    var date: Date { get }
//    var isCurrentMonthDay: Bool { get }
//    var isSelected: Bool { get set }
//}

