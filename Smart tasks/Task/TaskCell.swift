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
        view.layer.cornerRadius = 5
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
        addSubViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with item: DemoItem) {
        title.text = item.title
        dueDateValue.text = item.dueDate
        daysLeftValueLabel.text = item.daysLeft
    }
    
    private func addSubViews() {
        contentView.addSubview(cardView)
        [title,seperator,horizontalStack].forEach(cardView.addSubview(_:))
        [dueDateLabel,dueDateValue].forEach(leftStack.addArrangedSubview(_:))
        [daysLeftLabel,daysLeftValueLabel].forEach(rightStack.addArrangedSubview(_:))
        [leftStack,rightStack].forEach(horizontalStack.addArrangedSubview(_:))
    }
    
    // MARK: - Layout
    private func setupConstraints() {
        cardView
            .alignEdge(.top, withView: contentView, constant: 5)
            .alignEdge(.left, withView: contentView, constant: 10)
            .alignEdge(.right, withView: contentView, constant: 10)
            .alignEdge(.bottom, withView: contentView, constant: 5)
        
        title
            .alignEdge(.top, withView: cardView, constant: 10)
            .alignEdge(.left, withView: cardView, constant: 10)
            .alignEdge(.right, withView: cardView, constant: 10)
        
        seperator
            .pinEdge(.top, toEdge: .bottom, ofView: title, constant: 7)
            .alignEdge(.left, withView: cardView, constant: 10)
            .alignEdge(.right, withView: cardView, constant: 10)
            .height(constant: 1)
        
        horizontalStack
            .pinEdge(.top, toEdge: .bottom, ofView: seperator, constant: 7)
            .alignEdge(.left, withView: cardView, constant: 10)
            .alignEdge(.right, withView: cardView, constant: 10)
            .alignEdge(.bottom, withView: cardView, constant: 10)
    }
}
