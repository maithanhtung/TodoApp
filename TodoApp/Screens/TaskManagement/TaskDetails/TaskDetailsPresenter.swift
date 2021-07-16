//
//  TaskDetailsPresenter.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 16.7.2021.
//

import Foundation

// MARK: - TaskDetailsPresenterDelegate declaration
protocol TaskDetailsPresenterDelegate: AnyObject {
}

// MARK: - TaskDetailsPresenterProtocol declaration
protocol TaskDetailsPresenterProtocol: NSObject {

    var viewController: TaskDetailsViewControllerProtocol? { get set }

    init(interactor: TaskDetailsInteractorProtocol, delegate: TaskDetailsPresenterDelegate)
}

// MARK: - TaskDetailsPresenter implementation
class TaskDetailsPresenter: NSObject, TaskDetailsPresenterProtocol {

    weak var viewController: TaskDetailsViewControllerProtocol?

    private let interactor: TaskDetailsInteractorProtocol
    private let delegate: TaskDetailsPresenterDelegate
    
    required init(interactor: TaskDetailsInteractorProtocol, delegate: TaskDetailsPresenterDelegate) {
        self.interactor = interactor
        self.delegate = delegate

        super.init()
        self.interactor.delegate = self
    }
}

// MARK: - TaskDetailsInteractor delegate
extension TaskDetailsPresenter: TaskDetailsInteractorDelegate {
}
