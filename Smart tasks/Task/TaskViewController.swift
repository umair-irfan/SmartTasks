//
//  TaskViewController.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit

class TaskViewController: UIViewController {
   
    private var taskView = TaskView()
    var viewModel: TaskViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = AppColor.background.color
        self.taskView.setup(in: self.view)
        self.bindViewModel()
        self.viewModel.input.loadData()
    }
    
    private func bindViewModel() {
        
        //taskView.tableView.delegate = self
        
        //Bind Data Source
        viewModel.output.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.taskView.dataSource.apply(self.viewModel.output.defaultSnapshot(),
                                                    animatingDifferences: true)
        }
    }
}



