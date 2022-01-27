//
//  NxCalendarHeaderView.swift
//  NxCalendar
//
//  Created by Maxim Soroka on 26.12.2021.
//

import UIKit

final class NxCalendarHeaderView: UIView {
    // MARK: - Private Properties
    private let calendarService: NxCalendarService
    
    
    // MARK: - UIBricks
    lazy var monthYearLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .boldDMSans(of: 18)
        label.textColor = AssetsProvider.textButtonColor
        label.text = calendarService
            .monthYearDateFormatter
            .string(from: calendarService.currentDate)
        return label
    }()
    
    lazy var leftArrowButton: UIButton = {
        let button = UIButton(type: .system)
        let image = AssetsProvider.arrowLeftImage
        button.setImage(
            AssetsProvider.arrowLeftImage,
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(didPressLeftButtonArrow),
            for: .touchUpInside
        )
        button.tintColor = AssetsProvider.textButtonColor
        button.isEnabled = calendarService.isLeftArrowButtonInitialEnabled
        return button
    }()
    
    lazy var rightArrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            AssetsProvider.arrowRightImage,
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(didPressRightButtonArrow),
            for: .touchUpInside
        )
        button.tintColor = AssetsProvider.textButtonColor
        button.isEnabled = calendarService.isRightArrowButtonInitialEnabled
        return button
    }()
    
    lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var topStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                leftArrowButton,
                monthYearLabel,
                rightArrowButton
            ]
        )
        stackView.distribution = .equalCentering
        stackView.axis = .horizontal
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16
        )
        return stackView
    }()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                topStackView,
                bottomStackView
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - View Lifecycle
    init(using service: NxCalendarService) {
        self.calendarService = service
        super.init(frame: .zero)
        backgroundColor = .clear
        calendarService.shortStandaloneWeekdaySymbols
            .forEach {
                let weekdayLabel = UILabel()
                weekdayLabel.font = .boldDMSans(of: 14)
                weekdayLabel.textAlignment = .center
                weekdayLabel.textColor = AssetsProvider.weekdayLabelColor
                weekdayLabel.text = $0.uppercased()
                bottomStackView.addArrangedSubview(weekdayLabel)
            }
        
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate(
            [
                mainStackView.topAnchor.constraint(equalTo: topAnchor),
                mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Actions
private extension NxCalendarHeaderView {
    @objc
    func didPressLeftButtonArrow() {
        leftArrowButton.isEnabled = calendarService.didPressLeftButtonArrowCompletionHandler()
        rightArrowButton.isEnabled = true
    }
    
    @objc
    func didPressRightButtonArrow() {
        rightArrowButton.isEnabled = calendarService.didPressRightButtonArrowCompletionHandler()
        leftArrowButton.isEnabled = true
    }
}
