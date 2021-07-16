//
//  TaskDetailsInteractor.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 16.7.2021.
//

import Foundation

// MARK: - TaskDetailsInteractorDelegate declaration
protocol TaskDetailsInteractorDelegate: AnyObject {
}

// MARK: - TaskDetailsInteractorProtocol declaration
protocol TaskDetailsInteractorProtocol: NSObject {
    var delegate: TaskDetailsInteractorDelegate? { get set }
}

// MARK: - TaskDetailsInteractor implementation
class TaskDetailsInteractor: NSObject, TaskDetailsInteractorProtocol {
    weak var delegate: TaskDetailsInteractorDelegate?
    required override init() {
        super.init()
    }
}
