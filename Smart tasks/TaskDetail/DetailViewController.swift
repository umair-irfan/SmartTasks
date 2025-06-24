//
//  DetailViewController.swift
//  Smart tasks
//
//  Created by Umair on 22/06/2025.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
   
    private var detailView = DetailView()
    var viewModel: DetailViewModelType!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = AppColor.background.color
        self.detailView.setup(in: self.view)
        self.bindViewModel()
        self.viewModel.input.loadData()
    }
    
    private func bindViewModel() {
        //Bind Data Source
        viewModel.output.snapshotPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] snapshot in
                guard let self = self else { return }
                if snapshot.itemIdentifiers.isEmpty {
                    self.detailView.tableView.showEmptyListView(imageName: "empty-view-image", message: "No tasks for today!")
                    self.detailView.dataSource.apply(snapshot, animatingDifferences: true)
                    return
                }
                self.detailView.dataSource.apply(snapshot, animatingDifferences: true)
                self.detailView.tableView.restore()
            }
            .store(in: &cancellables)
    }
}



