//
//  Task.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import Foundation

struct Task: Codable {
    var id: String? = .none
    var title: String
    var description: String
    var dueDate: Date
    var reminderText: String
}
