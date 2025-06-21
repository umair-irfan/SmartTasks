//
//  TaskView.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//
import UIKit

final class TaskView {
    
    public enum Section {
        case Main
    }
    
    @MainActor
    lazy var dataSource = GenericTableViewDataSource<Section>(tableView: tableView)
    
    @MainActor
    public lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    @MainActor
    func setup(in view: UIView) {
        view.addSubview(tableView)
        setupConstraints()
    }
    
    @MainActor
    func setupConstraints() {
        tableView
            .alignEdgeWithSuperviewSafeArea(.top)
            .alignEdgesWithSuperview([.left, .right], constant: 20)
            .alignEdgeWithSuperviewSafeArea(.bottom)
    }
}
