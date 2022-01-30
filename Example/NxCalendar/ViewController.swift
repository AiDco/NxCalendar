//
//  ViewController.swift
//  NxCalendar
//
//  Created by AiDco on 01/27/2022.
//  Copyright (c) 2022 AiDco. All rights reserved.
//

import UIKit
import NxCalendar

class ViewController: UIViewController, NxCalendarViewDelegate {
    func wellbeingDates(for newMonthNumber: Int) -> [NxCalendarConfiguration.WellbeingDestinnation] {

        print(newMonthNumber)
        return []
    }

    func sessionDates(for newMonthNumber: Int) -> [NxCalendarConfiguration.SessionDestination] {

        print(newMonthNumber)
        return []
    }

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = ""
        for _ in 0..<3 {
            label.text! += "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        }
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var collectionViewHeightAnchor: NSLayoutConstraint!

    lazy var calendarView: NxCalendarView =  {
        let startDate = getDateFor(year: 2022, month: 1, day: 5)!
        let endDate = getDateFor(year: 2022, month: 1, day: 10)!

        let beetweenDate = getDateFor(year: 2022, month: 1, day: 31)!
        let testDate = getDateFor(year: 2022, month: 2, day: 1)!
        let testDate2 = getDateFor(year: 2022, month: 2, day: 2)!
        let testDate3 = getDateFor(year: 2022, month: 2, day: 3)!
        let testDate4 = getDateFor(year: 2022, month: 2, day: 4)!
        let testDate5 = getDateFor(year: 2021, month: 12, day: 22)!

        let startDate2 = getDateFor(year: 2022, month: 2, day: 1)!
        let endDate2 = getDateFor(year: 2022, month: 4, day: 15)!

        let configuration = NxCalendarConfiguration(

            calendarType:
                    .wellbeing([
                .selectedDate(date: testDate2, dayType: .nothingDone),
                .selectedDate(date: testDate3, dayType: .allDone),
                .selectedDate(date: testDate4, dayType: .allDone),
                .selectedDate(date: beetweenDate, dayType: .someDone),
                .selectedDate(date: testDate, dayType: .allDone),

                    .selectedDates(from: endDate, to: startDate, daysType: .allDone),
                .selectedDates(from: startDate2, to: endDate2, daysType: .allDone),
                .selectedDate(date: beetweenDate, dayType: .someDone),
            ]),
//            .session(
//                    [
//                        .busyDates(from: Date(), to: testDate3)
//                    ],
//                    selectedDate: testDate5
//            ),
            showDatesOutMonth: false,
            isMonthSwitchingEnabled: true,
            didSelectDateCompletionHandler: { date in
                print(" \(date) tapped")
            }
        )
        return NxCalendarView(configuration: configuration)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(calendarView)
        contentView.addSubview(textLabel)

        calendarView.translatesAutoresizingMaskIntoConstraints = false

        calendarView.monthDelegate = self
        calendarView.delegate = self


        let contentHeightAnchor = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentHeightAnchor.priority = .defaultLow
        collectionViewHeightAnchor = calendarView.heightAnchor.constraint(equalToConstant: 400)
        collectionViewHeightAnchor.priority = .defaultHigh

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentHeightAnchor,

            calendarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            calendarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            calendarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionViewHeightAnchor,

            textLabel.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

//        collectionViewHeightAnchor.constant = calendarView.collectionView.contentSize.height
//        view.layoutIfNeeded()
    }

    private func getDateFor(year: Int, month: Int, day: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return Calendar.current.date(from: dateComponents)
    }
}

extension ViewController: MonthDidChangeDelegate {
    func monthDidChange(firstMothDay: Date) {
        print(firstMothDay.dateWithTimeZone)
    }
}

extension Date {
    var dateWithTimeZone: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}

