//
//  TypeAlias.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit

typealias DataSnapshot = NSDiffableDataSourceSnapshot<TaskView.Section, AnyCellConfigurable>
typealias LoadingCallback = ((Bool) -> Void)
typealias SimpleCallback = (() -> Void)
typealias CoordinatorCompletion = (Result<Void, CoordinatorError>) -> Void
