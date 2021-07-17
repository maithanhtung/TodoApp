//
//  Task.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import UIKit

enum TaskStatus: Int, Codable {
    case active = 0,
         done,
         overdue
    
    var statusString: String {
        switch self {
        case .active:
            return "Active"
        case .done:
            return "Done"
        case .overdue:
            return "Over due"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .active:
            return .systemYellow
        case .done:
            return .systemGreen
        case .overdue:
            return .systemRed
        }
    }
}

struct Task: Codable {
    var id: String? = .none
    var title: String
    var description: String
    var dueDate: Date
    var reminderText: String
    var taskStatus: TaskStatus = .active
    
    mutating func updateTaskStatus() {
        if dueDate <= Date() && taskStatus == .active {
            taskStatus = .overdue
        }
    }
}
