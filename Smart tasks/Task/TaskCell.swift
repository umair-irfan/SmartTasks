//
//  TaskCell.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit

public struct DemoItem: Hashable, @preconcurrency CellConfigurable {
    
    let id: UUID = UUID()
    
    @MainActor
    var reuseIdentifier: String { TaskCell.identifier }
    
    @MainActor
    func configure(cell: UITableViewCell) {
        guard let cell = cell as? TaskCell else { return }
        cell.configure(with: self)
    }
    
    let name: String
}

final class TaskCell: UITableViewCell {
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @MainActor
    class var identifier: String { String(describing: self)}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(title)
        let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        title.alignAllEdgesWithSuperview(.equalTo, edgeInsets: insets)
    }
    
    func configure(with item: DemoItem) {
        title.text = item.name
    }
}

