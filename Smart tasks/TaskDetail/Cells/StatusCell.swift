//
//  StatusCell.swift
//  Smart tasks
//
//  Created by Umair on 23/06/2025.
//

import UIKit

enum StatusType: Codable, CaseIterable {
    
    case unresolved
    case resolved
    case cannotResolve
    
    var value: String {
        switch self {
        case .unresolved:
            "Unresolved"
        case .resolved:
            "Resolve"
        case .cannotResolve:
            "Cann't Resolve"
        }
    }
}

public struct StatusItem: Hashable, Sendable {
    let id: UUID = UUID()
    var status: StatusType
}

@MainActor
extension StatusItem: @preconcurrency CellConfigurable {
    var reuseIdentifier: String { StatusCell.identifier }
    func configure(cell: UITableViewCell) {
        guard let cell = cell as? StatusCell else { return }
        cell.configure(with: self)
    }
}


class StatusCell: UITableViewCell {
    
    @MainActor
    class var identifier: String { String(describing: self) }
    
    private var currentItem: StatusItem?
    
    private var buttons: [UIButton] = []
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let statusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    private func addSubViews() {
        contentView.addSubview(statusImage)
        contentView.addSubview(buttonStackView)
        
        StatusType.allCases.forEach { status in
            switch status {
            case .unresolved:
                return
            case .resolved:
                let button = UIButton()
                button.setTitle(status.value, for: .normal)
                button.titleLabel?.font = AppFont.bold.getFont(.h2)
                button.layer.cornerRadius = 5
                button.tag = 0
                button.backgroundColor = AppColor.sucess.color
                buttons.append(button)
                buttonStackView.addArrangedSubview(button)
                button.addTarget(self, action: #selector(didTapResolved(_:)), for: .touchUpInside)
            case .cannotResolve:
                let button = UIButton()
                button.setTitle(status.value, for: .normal)
                button.titleLabel?.font = AppFont.bold.getFont(.h2)
                button.layer.cornerRadius = 5
                button.tag = 1
                button.backgroundColor = AppColor.failure.color
                buttons.append(button)
                buttonStackView.addArrangedSubview(button)
                button.addTarget(self, action: #selector(didTapCannotResolve(_:)), for: .touchUpInside)
            }
        }
    }
    
    // MARK: - Layout
    private func setupConstraints() {
        buttonStackView
            .alignEdge(.top, withView: contentView, constant: 35)
            .alignEdge(.left, withView: contentView)
            .alignEdge(.right, withView: contentView)
            .alignEdge(.bottom, withView: contentView)
            .height(constant: 45)
        
        statusImage
            .horizontallyCenterWith(contentView)
            .alignEdge(.top, withView: contentView, constant: 35)
            .width(constant: 100)
            .height(constant: 100)
    }
    
    func configure(with item: StatusItem) {
        currentItem = item
        switch item.status {
        case .unresolved:
            return
        case .resolved:
            buttonStackView.isHidden = true
            statusImage.image = UIImage(named: "tick-icon")
        case .cannotResolve:
            buttonStackView.isHidden = true
            statusImage.image = UIImage(named: "cross-icon")
        }
        statusImage.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
            self.statusImage.alpha = 1
            self.statusImage.transform = .identity
        })
    }
    
    @objc
    private func didTapResolved(_ sender: UIButton) {
        GlobalEvent.Application.TaskStatusUpdate.post(with: StatusType.resolved)
    }
    
    @objc
    private func didTapCannotResolve(_ sender: UIButton) {
        GlobalEvent.Application.TaskStatusUpdate.post(with: StatusType.cannotResolve)
    }
}
