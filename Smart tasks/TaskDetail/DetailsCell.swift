//
//  DetailsCell.swift
//  Smart tasks
//
//  Created by Umair on 23/06/2025.
//

import UIKit

public struct DetailItem: Hashable, @preconcurrency CellConfigurable {
    
    let id: UUID = UUID()
    
    @MainActor
    var reuseIdentifier: String { DetailsCell.identifier }
    
    @MainActor
    func configure(cell: UITableViewCell) {
        guard let cell = cell as? DetailsCell else { return }
        cell.configure(with: self)
    }
    
    let title: String
    let dueDate: String
    let daysLeft: String
    let description: String
}


class DetailsCell: UITableViewCell {

    @MainActor
    class var identifier: String { String(describing: self)}

    private let backgroundCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail-background")
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()

    private let taskTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.bold.getFont(.h2)
        label.textColor = AppColor.primaryText.color
        return label
    }()

    private let dueDateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Due date"
        label.font = AppFont.regular.getFont(.b2)
        label.textColor = .gray
        return label
    }()

    private let daysLeftTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Days left"
        label.font = AppFont.regular.getFont(.b2)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()

    private let dueDateLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.regular.getFont(.b2)
        label.textColor = AppColor.primaryText.color
        return label
    }()

    private let daysLeftLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.regular.getFont(.b2)
        label.textColor = AppColor.primaryText.color
        label.textAlignment = .right
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = AppFont.regular.getFont(.b2)
        label.textColor = .darkGray
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Unresolved"
        label.font = AppFont.regular.getFont(.b2)
        label.textColor = UIColor.orange
        return label
    }()

    private let cardStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(backgroundCardImageView)
        backgroundCardImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundCardImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            backgroundCardImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundCardImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backgroundCardImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        cardStack.axis = .vertical
        cardStack.spacing = 10
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        cardStack.isLayoutMarginsRelativeArrangement = true
        cardStack.layoutMargins = UIEdgeInsets(top: 48, left: 16, bottom: 16, right: 16)

        let topRow1 = UIStackView(arrangedSubviews: [dueDateTitleLabel, UIView(), daysLeftTitleLabel])
        topRow1.axis = .horizontal

        let topRow2 = UIStackView(arrangedSubviews: [dueDateLabel, UIView(), daysLeftLabel])
        topRow2.axis = .horizontal

        cardStack.addArrangedSubview(taskTitleLabel)
        cardStack.addArrangedSubview(topRow1)
        cardStack.addArrangedSubview(topRow2)
        cardStack.addArrangedSubview(descriptionLabel)
        cardStack.addArrangedSubview(statusLabel)

        backgroundCardImageView.addSubview(cardStack)
        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: backgroundCardImageView.topAnchor),
            cardStack.leadingAnchor.constraint(equalTo: backgroundCardImageView.leadingAnchor),
            cardStack.trailingAnchor.constraint(equalTo: backgroundCardImageView.trailingAnchor),
            cardStack.bottomAnchor.constraint(equalTo: backgroundCardImageView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configure(with item: DetailItem) {
        taskTitleLabel.text = item.title
        dueDateLabel.text = item.dueDate
        daysLeftLabel.text = item.daysLeft
        descriptionLabel.text = item.description
    }
}

