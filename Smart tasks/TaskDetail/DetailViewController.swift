//
//  DetailViewController.swift
//  Smart tasks
//
//  Created by Umair on 22/06/2025.
//

import UIKit

class DetailViewController: UIViewController {
   
    private var detailView = DetailView()
    var viewModel: DetailViewModelType!
    
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
        viewModel.output.onUpdate = { [weak self] in
            guard let self = self else { return }
            self.detailView.dataSource.apply(self.viewModel.output.defaultSnapshot(),
                                                    animatingDifferences: true)
        }
    }
}



