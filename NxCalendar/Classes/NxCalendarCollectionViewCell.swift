//
//  CalendarCollectionViewCell.swift
//  NxCalendar
//
//  Created by Maxim Soroka on 23.12.2021.
//

import UIKit

final class CalendarDateCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseIdentifier = String(describing: CalendarDateCollectionViewCell.self)
    
    
    // MARK: - UIBricks
    lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .boldDMSans(of: 14)
        label.textColor = AssetsProvider.textButtonColor
        return label
    }()
    
    lazy var leftLineView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AssetsProvider.allDoneColor
        return view
    }()
    
    lazy var rightLineView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AssetsProvider.allDoneColor
        return view
    }()
    
    var day: Day? {
        didSet {
            guard let day = day else { return }
            numberLabel.text = day.number
            
            switch day.type {
            case let .session(type):
                selectionBackgroundView.backgroundColor = UIColor(red: 0.73, green: 1.00, blue: 0.07, alpha: 1)
                
                if !day.isCurrentMonthDay {
                    numberLabel.textColor = AssetsProvider
                        .textButtonColor?
                        .withAlphaComponent(0.2)
                } else {
                    numberLabel.textColor = AssetsProvider
                        .textButtonColor?
                        .withAlphaComponent(type == .free ? 1 : 0.4)
                }
                
            case let .wellbeing(type):
                switch type {
                case .allDone:
                    selectionBackgroundView.backgroundColor = AssetsProvider.allDoneColor
                case .someDone:
                    selectionBackgroundView.backgroundColor = AssetsProvider.someDoneColor
                case .nothingDone:
                    selectionBackgroundView.backgroundColor = AssetsProvider.nothingDoneColor
                case .unknown:
                    selectionBackgroundView.backgroundColor = nil
                }
                
                numberLabel.textColor = AssetsProvider
                    .textButtonColor?
                    .withAlphaComponent(day.isCurrentMonthDay ? 1 : 0.3)
                
                [rightLineView, selectionBackgroundView, leftLineView]
                    .forEach {
                        $0
                        .backgroundColor?
                        .withAlphaComponent(day.isCurrentMonthDay ? 1 : 0.3)
                    }
            }
        }
    }
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(numberLabel)
        contentView.addSubview(leftLineView)
        contentView.addSubview(rightLineView)
        
        let size = min(frame.width - 6, 60)
        
        NSLayoutConstraint.activate([
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
    
            selectionBackgroundView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            selectionBackgroundView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalToConstant: size),
            selectionBackgroundView.heightAnchor.constraint(equalTo: selectionBackgroundView.widthAnchor),
            
            leftLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftLineView.trailingAnchor.constraint(equalTo: selectionBackgroundView.leadingAnchor),
            leftLineView.centerYAnchor.constraint(equalTo: selectionBackgroundView.centerYAnchor),
            leftLineView.heightAnchor.constraint(equalToConstant: 4),

            rightLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rightLineView.leadingAnchor.constraint(equalTo: selectionBackgroundView.trailingAnchor),
            rightLineView.centerYAnchor.constraint(equalTo: selectionBackgroundView.centerYAnchor),
            rightLineView.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        selectionBackgroundView.layer.cornerRadius = size / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
