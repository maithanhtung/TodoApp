//
//  TaskDetailsInteractor.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 16.7.2021.
//

import Foundation

// MARK: - TaskDetailsInteractorDelegate declaration
protocol TaskDetailsInteractorDelegate: AnyObject {
    func deleteTaskSucceeded()
    
    func deleteTaskFailed(with error: TDError)
}

// MARK: - TaskDetailsInteractorProtocol declaration
protocol TaskDetailsInteractorProtocol: NSObject {
    var delegate: TaskDetailsInteractorDelegate? { get set }
    
    func delete(task: Task)
}

// MARK: - TaskDetailsInteractor implementation
class TaskDetailsInteractor: NSObject, TaskDetailsInteractorProtocol {
    weak var delegate: TaskDetailsInteractorDelegate?
    required override init() {
        super.init()
    }
    
    func delete(task: Task) {
        guard let id = task.id else {
            delegate?.deleteTaskFailed(with: TDError(errorString: "Task id should not be nil"))
            return
        }
        TaskManagementController().deleteTask(with: id, onSuccess: { [weak self] in
            self?.delegate?.deleteTaskSucceeded()
        }, onFail: { [weak self] error in
            self?.delegate?.deleteTaskFailed(with: error)
        })
    }
}
