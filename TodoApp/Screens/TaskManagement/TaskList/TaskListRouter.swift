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

        return controller
    }
    
}

// MARK: - TaskListPresenter delegate
extension TaskListRouter: TaskListPresenterDelegate {
    func openTaskDetail(with taskId: String) {
        // To be implement
    }
    
    func logout() {
        // To be implement
    }
    
    func openAddTaskForm() {
        // To be implement
    }
}
