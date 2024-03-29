//
//  TaskListRouter.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 13.7.2021.
//

import UIKit

// MARK: - TaskListRouterDelegate declaration
protocol TaskListRouterDelegate: AnyObject {
}

// MARK: - TaskListRouterProtocol declaration
protocol TaskListRouterProtocol {
    
    var delegate: TaskListRouterDelegate? { get set }
    
}

// MARK: - TaskListRouter implementation
class TaskListRouter: NSObject, TaskListRouterProtocol {
    weak var delegate: TaskListRouterDelegate?
    var presenter: TaskListPresenter?
    var navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController? = .none) {
        self.navigationController = navigationController
        super.init()
    }
    
    func load() {
        if let nav = navigationController {
            nav.pushViewController(createViewController(), animated: true)
        }
    }
    
    func createViewController() -> UIViewController {
        let interactor = TaskListInteractor()
        let presenter = TaskListPresenter(interactor: interactor, delegate: self)
        let controller = TaskListViewController(presenter: presenter)
        self.presenter = presenter
        return controller
    }
    
}

// MARK: - TaskListPresenter delegate
extension TaskListRouter: TaskListPresenterDelegate {
    func openTaskDetail(with task: Task) {
        if let nav = navigationController {
            let taskDetailsRouter: TaskDetailsRouter = TaskDetailsRouter(navigationController: nav)
            taskDetailsRouter.delegate = self
            taskDetailsRouter.load(with: task)
        }
    }
    
    func openAddTaskForm() {
        if let nav = navigationController {
            let taskFormRouter: TaskFormRouter = TaskFormRouter(navigationController: nav)
            taskFormRouter.delegate = self
            taskFormRouter.load()
        }
    }
}

// MARK: - TaskFormRouter delegate
extension TaskListRouter: TaskFormRouterDelegate {
    func taskFormRouterDidFinish() {
        presenter?.viewIsReady()
    }
}

// MARK: - TaskDetailsRouter delegate
extension TaskListRouter: TaskDetailsRouterDelegate {
    func taskDetailsRouterDidFinish() {
        presenter?.viewIsReady()
    }
    
}
