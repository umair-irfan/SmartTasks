//
//  TypeAlias.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit

typealias TasksSnapshot = NSDiffableDataSourceSnapshot<TaskView.Section, AnyCellConfigurable>
typealias DetailSnapshot = NSDiffableDataSourceSnapshot<DetailView.Section, AnyCellConfigurable>
typealias SimpleCallback = (() -> Void)
