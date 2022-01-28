//
//  NxCalendarView.swift
//  NxCalendar
//
//  Created by Maxim Soroka on 23.12.2021.
//

import UIKit

public final class NxCalendarView: UIView {
    // MARK: - Private Properties
    private let calendarService: NxCalendarService
    
    
    // MARK: - Properties
    public weak var delegate: NxCalendarViewDelegate?
    
    public var didSelectDateCompletionHandler: (() -> Void)?
    
    // MARK: - UIBricks
    private lazy var headerView = NxCalendarHeaderView(using: calendarService)
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                headerView,
                collectionView
            ]
        )
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var mainStackViewHeight: NSLayoutConstraint!
    
    // MARK: - View Lifecycle
    public init(
        frame: CGRect = .zero,
        configuration: NxCalendarConfiguration
    ) {
        calendarService = NxCalendarService(
            with: configuration
        )
        super.init(frame: frame)
        addSubview(mainStackView)
        
        didSelectDateCompletionHandler = calendarService.configuration.didSelectDateCompletionHandler
        
        NSLayoutConstraint.activate(
            [
                mainStackView.topAnchor.constraint(equalTo: topAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
        
        collectionView.register(
            CalendarDateCollectionViewCell.self,
            forCellWithReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier
        )
        
        calendarService.didChangeCurrentDateCompletionHandler = { [unowned self] date in
            headerView.monthYearLabel.text = calendarService
                .monthYearDateFormatter
                .string(from: date)
            
            if let newDestinations = delegate?.wellbeingDates(for: date.get(.month)),
               case .wellbeing(_) = calendarService.configuration.calendarType {
                calendarService.wellbeingDatesFromDestinationCompletionHandler(newDestinations)
            }
            
            if let newDestinations = delegate?.sessionDates(for: date.get(.month)),
               case .session(_, _) = calendarService.configuration.calendarType {
                calendarService.sessionDatesFromDestinationCompletionHandler(newDestinations, nil)
            }
            
            calendarService.dates = calendarService.dates.unique
            collectionView.reloadData()
        }
    }
    
    public func updateWellbeingDates(dates: [(Date, Day.DayType.Wellbeing)]) {
        calendarService.dates.removeAll { date in
            if dates.contains(where: { $0.0 == date.0 }) {
                return true
            }
            return false
        }
        calendarService.dates += dates.map {
            ($0.0.erasedFormat ?? Date(), .wellbeing($0.1))
        }
        collectionView.reloadData()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionViewDataSource
extension NxCalendarView: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int { calendarService.days.count }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarDateCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! CalendarDateCollectionViewCell
        
        if case .wellbeing(_) = calendarService.configuration.calendarType {
            let previousDay = indexPath.item - 1 <= calendarService.days.count && indexPath.item != 0
            ? calendarService.days[indexPath.item - 1]
            : nil
            
            let day = calendarService.days[indexPath.item]
            
            let nextDay = indexPath.item + 1 < calendarService.days.count
            ? calendarService.days[indexPath.item + 1]
            : nil
            
            let nonCurrentMonthDayCondition = !calendarService.configuration.showDatesOutMonth && !day.isCurrentMonthDay
            
            let leftLineViewSelectedCondition  = previousDay?.type != .wellbeing(.allDone)
            let rightLineViewSelectedCondition = nextDay?.type != .wellbeing(.allDone)
            
            let leftLineViewNonSelectedCondition  = indexPath.item % 7 == 0  || day.type != .wellbeing(.allDone)
            let rightLineViewNonSelectedCondition = (indexPath.item + 1) % 7 == 0 || day.type != .wellbeing(.allDone)
            
            let leftLineViewNearDateOutMonthCondition  = !(previousDay?.isCurrentMonthDay ?? true) &&
            !calendarService.configuration.showDatesOutMonth
            let rightLineViewNearDateOutMonthCondition = !(nextDay?.isCurrentMonthDay ?? true)     &&
            !calendarService.configuration.showDatesOutMonth
            
            cell.day = day
            
            cell.leftLineView.isHidden =
            leftLineViewNearDateOutMonthCondition ||
            leftLineViewSelectedCondition         ||
            leftLineViewNonSelectedCondition      ||
            nonCurrentMonthDayCondition
            
            cell.rightLineView.isHidden =
            rightLineViewNearDateOutMonthCondition ||
            rightLineViewSelectedCondition         ||
            rightLineViewNonSelectedCondition      ||
            nonCurrentMonthDayCondition
            
            cell.selectionBackgroundView.isHidden = nonCurrentMonthDayCondition
            cell.numberLabel.isHidden = nonCurrentMonthDayCondition
            
        } else if case .session(_, _) = calendarService.configuration.calendarType {
            let day = calendarService.days[indexPath.item]
            let nonCurrentMonthDayCondition = !calendarService.configuration.showDatesOutMonth && !day.isCurrentMonthDay
            
            cell.day = day
            cell.numberLabel.isHidden = nonCurrentMonthDayCondition
            cell.selectionBackgroundView.isHidden = !day.isSelected || nonCurrentMonthDayCondition
            cell.rightLineView.isHidden = true
            cell.leftLineView.isHidden = true
        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let beforeIndexPath = calendarService.didSelectDateCompletionHandler(indexPath) {
            collectionView.reloadItems(
                at: [
                    indexPath, beforeIndexPath
                ]
            )
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension NxCalendarView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = Int(collectionView.frame.width)
        let columns = 7
        let side = width / columns
        let rem = width % columns
        let addOne = indexPath.row % columns < rem
        let ceilWidth = addOne ? side + 1 : side
        return CGSize(width: ceilWidth, height: side)
    }
}

public func getDateFor(year: Int, month: Int, day: Int) -> Date? {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    return Calendar.current.date(from: dateComponents)
}
