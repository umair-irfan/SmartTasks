//
//  DetailView.swift
//  Smart tasks
//
//  Created by Umair on 22/06/2025.
//
import UIKit

final class DetailView {
    
    public enum Section {
        case Main
        case Status
    }
    
    @MainActor
    lazy var dataSource = GenericTableViewDataSource<Section>(tableView: tableView)
    
    @MainActor
    public lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 150
        tableView.backgroundColor = AppColor.background.color
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DetailsCell.self, forCellReuseIdentifier: DetailsCell.identifier)
        tableView.register(StatusCell.self, forCellReuseIdentifier: StatusCell.identifier)
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
            .alignEdgeWithSuperviewSafeArea(.top, constant: 15)
            .alignEdgesWithSuperview([.left, .right], constant: 15)
            .alignEdgeWithSuperviewSafeArea(.bottom)
    }
}
