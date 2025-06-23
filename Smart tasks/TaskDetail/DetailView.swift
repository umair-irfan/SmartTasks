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
    }
    
    @MainActor
    lazy var dataSource = GenericTableViewDataSource<Section>(tableView: tableView)
    
    @MainActor
    public lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DetailsCell.self, forCellReuseIdentifier: DetailsCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppColor.background.color
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
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
