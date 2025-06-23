//
//  TaskCell.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit

public struct DemoItem: Hashable, Sendable {
    let id: UUID = UUID()
    let taskId: String
    let title: String
    let dueDate: String
    let daysLeft: String
}

@MainActor
extension DemoItem: @preconcurrency CellConfigurable {
    var reuseIdentifier: String { TaskCell.identifier }
    func configure(cell: UITableViewCell) {
        guard let cell = cell as? TaskCell else { return }
        cell.configure(with: self)
    }
}

final class TaskCell: UITableViewCell {
    
    // MARK: - Card Container
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.primaryText.color
        label.font = AppFont.bold.getFont(.h2)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dueDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Due date"
        label.font = AppFont.regular.getFont(.b2)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dueDateValue: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.primaryText.color
        label.font = AppFont.bold.getFont(.h2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let daysLeftLabel: UILabel = {
        let label = UILabel()
        label.text = "Days left"
        label.font = AppFont.regular.getFont(.b2)
        label.textColor = .gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let daysLeftValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = AppColor.primaryText.color
        label.font = AppFont.bold.getFont(.h2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    private lazy var seperator: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.seperator.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let leftStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let rightStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    @MainActor
    class var identifier: String { String(describing: self)}
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(red: 1.0, green: 0.88, blue: 0.4, alpha: 1.0) // #FFE066
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with item: DemoItem) {
        title.text = item.title
        dueDateValue.text = item.dueDate
        daysLeftValueLabel.text = item.daysLeft
    }
    
    // MARK: - Layout
    private func setupLayout() {
            contentView.addSubview(cardView)
            cardView.addSubview(title)
            cardView.addSubview(seperator)
            cardView.addSubview(horizontalStack)

            leftStack.addArrangedSubview(dueDateLabel)
            leftStack.addArrangedSubview(dueDateValue)

            rightStack.addArrangedSubview(daysLeftLabel)
            rightStack.addArrangedSubview(daysLeftValueLabel)

            horizontalStack.addArrangedSubview(leftStack)
            horizontalStack.addArrangedSubview(rightStack)

            NSLayoutConstraint.activate([
                cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

                title.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
                title.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
                title.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),

                seperator.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 7),
                seperator.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
                seperator.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
                seperator.heightAnchor.constraint(equalToConstant: 1),

                horizontalStack.topAnchor.constraint(equalTo: seperator.bottomAnchor, constant: 7),
                horizontalStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
                horizontalStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
                horizontalStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10)
            ])
        }
}
