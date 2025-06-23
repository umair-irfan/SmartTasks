//
//  CellConfigurable.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit

protocol CellConfigurable: Hashable, Sendable {
    var id: UUID { get }
    var reuseIdentifier: String { get }
    func configure(cell: UITableViewCell)
}

struct AnyCellConfigurable: Hashable, @unchecked Sendable {
    let id: UUID
    let identifier: String
    let model: Any
    let configure: (UITableViewCell) -> Void

    init<T: CellConfigurable>(_ base: T) {
        self.id = base.id
        self.identifier = base.reuseIdentifier
        self.model = base
        self.configure = base.configure
    }

    func configure(cell: UITableViewCell) {
        configure(cell)
    }

    static func == (lhs: AnyCellConfigurable, rhs: AnyCellConfigurable) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class GenericTableViewDataSource<Section: Hashable & Sendable>: UITableViewDiffableDataSource<Section, AnyCellConfigurable> {
    
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
            item.configure(cell: cell)
            return cell
        }
    }
}
