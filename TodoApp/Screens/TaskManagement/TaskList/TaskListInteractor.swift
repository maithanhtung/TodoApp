//
//  TaskListInteractor.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 13.7.2021.
//

import Foundation

// MARK: - TaskListInteractorDelegate declaration
protocol TaskListInteractorDelegate: AnyObject {
    
    func taskListFetchSucceeded(with list: TaskList)
    
    func taskListFetchFailed(with error: TDError)
}

// MARK: - TaskListInteractorProtocol declaration
protocol TaskListInteractorProtocol: NSObject {
    var delegate: TaskListInteractorDelegate? { get set }
    
    func fetchTaskList()
}

// MARK: - TaskListInteractor implementation
class TaskListInteractor: NSObject, TaskListInteractorProtocol {
    weak var delegate: TaskListInteractorDelegate?
    required override init() {
        super.init()
    }
    
    func fetchTaskList() {
        TaskManagementController().fetchTaskList(onSuccess: { [weak self] taskList in
            self?.delegate?.taskListFetchSucceeded(with: taskList)
        }, onFail: { error in
            self.delegate?.taskListFetchFailed(with: error)
        })
    }
}
