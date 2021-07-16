//
//  TaskDetailsPresenter.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 16.7.2021.
//

import Foundation

// MARK: - TaskDetailsPresenterDelegate declaration
protocol TaskDetailsPresenterDelegate: AnyObject {
    func presenterDidFinish()
    
    func openEditTaskForm(with task: Task)
}

// MARK: - TaskDetailsPresenterProtocol declaration
protocol TaskDetailsPresenterProtocol: NSObject {

    var viewController: TaskDetailsViewControllerProtocol? { get set }
    
    var task: Task { get }
    
    init(interactor: TaskDetailsInteractorProtocol, delegate: TaskDetailsPresenterDelegate, task: Task)
    
    func editTask()
    
    func deleteTask()
}

// MARK: - TaskDetailsPresenter implementation
class TaskDetailsPresenter: NSObject, TaskDetailsPresenterProtocol {

    weak var viewController: TaskDetailsViewControllerProtocol?

    private let interactor: TaskDetailsInteractorProtocol
    private let delegate: TaskDetailsPresenterDelegate
    var task: Task
    
    required init(interactor: TaskDetailsInteractorProtocol, delegate: TaskDetailsPresenterDelegate, task: Task) {
        self.interactor = interactor
        self.delegate = delegate
        self.task = task

        super.init()
        self.interactor.delegate = self
    }
    
    func editTask() {
        delegate.openEditTaskForm(with: self.task)
    }
    
    func deleteTask() {
        viewController?.showLoadingView()
        interactor.delete(task: self.task)
    }
}

// MARK: - TaskDetailsInteractor delegate
extension TaskDetailsPresenter: TaskDetailsInteractorDelegate {
    func deleteTaskSucceeded() {
        viewController?.showSuccessBanner(with: "Successfully delete task")
        delegate.presenterDidFinish()
        viewController?.dissmissLoadingView()
    }
    
    func deleteTaskFailed(with error: TDError) {
        viewController?.showErrorBanner(with: error.errorString)
        viewController?.dissmissLoadingView()
    }
    
}
