//
//  DetailsCell.swift
//  Smart tasks
//
//  Created by Umair on 23/06/2025.
//

import UIKit

public struct DetailItem: Hashable, Sendable {
    let id: UUID = UUID()
    let title: String
    let dueDate: String
    let daysLeft: String
    let description: String
    let status: StatusType
}

@MainActor
extension DetailItem: @preconcurrency CellConfigurable {
    var reuseIdentifier: String { DetailsCell.identifier }
    func configure(cell: UITableViewCell) {
        guard let cell = cell as? DetailsCell else { return }
        cell.configure(with: self)
    }
}


class DetailsCell: UITableViewCell {

    @MainActor
    class var identifier: String { String(describing: self)}

    private let backgroundCardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "detail-background")
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        label.font = AppFont.bold.getFont(.h2)
        label.textColor = AppColor.primaryText.color
        return label
    }()

    private let daysLeftLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.bold.getFont(.h2)
        label.textColor = AppColor.primaryText.color
        label.textAlignment = .right
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = AppFont.regular.getFont(.t1)
        label.textColor = .darkGray
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.bold.getFont(.h2)
        label.textColor = UIColor.orange
        return label
    }()

    private let cardStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 48, left: 16, bottom: 16, right: 16)
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        addSubViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews(){
        contentView.addSubview(backgroundCardImageView)
       
        let topRow1 = UIStackView(arrangedSubviews: [dueDateTitleLabel, UIView(), daysLeftTitleLabel])
        topRow1.axis = .horizontal
        let topRow2 = UIStackView(arrangedSubviews: [dueDateLabel, UIView(), daysLeftLabel])
        topRow2.axis = .horizontal

        [taskTitleLabel,createSeparator(),topRow1, topRow2, createSeparator(),descriptionLabel,
         createSeparator(), statusLabel].forEach(cardStack.addArrangedSubview(_:))

        backgroundCardImageView.addSubview(cardStack)
    }
    
    // MARK: - Layout
    private func setupConstraints() {
        backgroundCardImageView.alignEdgesWithSuperview( [.top, .left, .right, .bottom],
                                                         constants: [12, 0, 0, -12])
        cardStack.alignEdges(
            [.top, .left, .right, .bottom],
            withView: backgroundCardImageView
        )
    }
    
    func configure(with item: DetailItem) {
        taskTitleLabel.text = item.title
        dueDateLabel.text = item.dueDate
        daysLeftLabel.text = item.daysLeft
        descriptionLabel.text = item.description
        statusLabel.text = item.status.value
        setupView(with: item.status)
    }
    
    func setupView(with status: StatusType) {
        switch status {
        case .unresolved:
            return
        case .resolved:
            taskTitleLabel.textColor = AppColor.sucess.color
            dueDateLabel.textColor = AppColor.sucess.color
            daysLeftLabel.textColor = AppColor.sucess.color
            statusLabel.textColor = AppColor.sucess.color
            statusLabel.text = "Resolved"
        case .cannotResolve:
            taskTitleLabel.textColor = AppColor.failure.color
            dueDateLabel.textColor = AppColor.failure.color
            daysLeftLabel.textColor = AppColor.failure.color
            statusLabel.textColor = AppColor.failure.color
        }
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = AppColor.seperator.color
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }
}

