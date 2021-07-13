//
//  TaskListInteractor.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 13.7.2021.
//

import Foundation

// MARK: - TaskListInteractorDelegate declaration
protocol TaskListInteractorDelegate: AnyObject {
}

// MARK: - TaskListInteractorProtocol declaration
protocol TaskListInteractorProtocol: NSObject {
    var delegate: TaskListInteractorDelegate? { get set }
}

// MARK: - TaskListInteractor implementation
class TaskListInteractor: NSObject, TaskListInteractorProtocol {
    weak var delegate: TaskListInteractorDelegate?
    required override init() {
        super.init()
    }
}
