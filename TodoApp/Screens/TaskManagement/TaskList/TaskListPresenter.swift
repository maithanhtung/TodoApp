//
//  TaskListPresenter.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 13.7.2021.
//

import Foundation

// MARK: - TaskListPresenterDelegate declaration
protocol TaskListPresenterDelegate: AnyObject {

}

// MARK: - TaskListPresenterProtocol declaration
protocol TaskListPresenterProtocol: NSObject {

    var viewController: TaskListViewControllerProtocol? { get set }

    init(interactor: TaskListInteractorProtocol, delegate: TaskListPresenterDelegate)

}

// MARK: - TaskListPresenter implementation
class TaskListPresenter: NSObject, TaskListPresenterProtocol {

    weak var viewController: TaskListViewControllerProtocol?

    private let interactor: TaskListInteractorProtocol
    private let delegate: TaskListPresenterDelegate

    var selectedSector: String?

    required init(interactor: TaskListInteractorProtocol, delegate: TaskListPresenterDelegate) {
        self.interactor = interactor
        self.delegate = delegate

        super.init()
        self.interactor.delegate = self
    }
    
}

// MARK: - TaskListInteractor delegate
extension TaskListPresenter: TaskListInteractorDelegate {
}

