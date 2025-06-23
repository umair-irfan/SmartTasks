//
//  TaskViewController.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit
import Combine

class TaskViewController: UIViewController {
   
    private var taskView = TaskView()
    var viewModel: TaskViewModelType!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.input.loadData()
    }
    
    private func setupView() {
        view.backgroundColor = AppColor.background.color
        taskView.setup(in: view)
    }
    
    private func bindViewModel() {
        
        taskView.tableView.delegate = self
        
        //Bind Data Source
        viewModel.output.snapshotPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] snapshot in
                guard let self = self else { return }
                if snapshot.itemIdentifiers.isEmpty {
                    self.taskView.tableView.showEmptyListView(imageName: "empty-view-image", message: "No tasks for today!")
                    self.taskView.dataSource.apply(snapshot, animatingDifferences: true)
                    return
                }
                self.taskView.dataSource.apply(snapshot, animatingDifferences: true)
                self.taskView.tableView.restore()
            }
            .store(in: &cancellables)
    }
}

extension TaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = taskView.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        if let task = item.model as? DemoItem {
            viewModel.output.onTapTaskDetail?(task)
        }
        
    }
}



