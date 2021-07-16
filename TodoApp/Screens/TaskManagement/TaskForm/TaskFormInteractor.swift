//
//  TaskFormInteractor.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import Foundation

// MARK: - TaskFormInteractorDelegate declaration
protocol TaskFormInteractorDelegate: AnyObject {
    
    func taskAddSucceeded()
    
    func taskAddFailed(with error: TDError)
}

// MARK: - TaskFormInteractorProtocol declaration
protocol TaskFormInteractorProtocol: NSObject {
    var delegate: TaskFormInteractorDelegate? { get set }
    
    func addTask(with task: Task)
}

// MARK: - TaskFormInteractor implementation
class TaskFormInteractor: NSObject, TaskFormInteractorProtocol {
    weak var delegate: TaskFormInteractorDelegate?
    required override init() {
        super.init()
    }
    
    func addTask(with task: Task) {
        TaskManagementController().addTask(with: task, onSuccess: { [weak self] in
            self?.delegate?.taskAddSucceeded()
        }, onFail: { [weak self] error in
            self?.delegate?.taskAddFailed(with: error)
        })
    }
}
