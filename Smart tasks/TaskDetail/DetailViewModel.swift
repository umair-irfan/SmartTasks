//
//  DetailViewModel.swift
//  Smart tasks
//
//  Created by Umair on 22/06/2025.
//

protocol DetailViewModelInput {
    func loadData()
}

protocol DetailViewModelOutput {
    
    
}

protocol DetailViewModelType {
    var input: DetailViewModelInput { get }
    var output: DetailViewModelOutput { get set }
}

class DetailViewModel: DetailViewModelInput, DetailViewModelOutput, DetailViewModelType {
    
    
    var input: DetailViewModelInput { self }
    var output:  DetailViewModelOutput {
        get { self }
        set { }
    }
    
    init() {
        
    }
    
    func loadData() {
        
    }
    
}
