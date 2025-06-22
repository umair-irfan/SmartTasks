//
//  DateFormatter+Extension.swift
//  Smart tasks
//
//  Created by Umair on 22/06/2025.
//
import UIKit

extension DateFormatter {
    static let taskDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
