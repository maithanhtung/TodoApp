//
//  TaskDetailsRouter.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 16.7.2021.
//

import UIKit

// MARK: - TaskDetailsRouterDelegate declaration
protocol TaskDetailsRouterDelegate: AnyObject {
    func taskDetailsRouterDidFinish()
}

// MARK: - TaskDetailsRouterProtocol declaration
protocol TaskDetailsRouterProtocol {
    
    var delegate: TaskDetailsRouterDelegate? { get set }
    
}

// MARK: - TaskDetailsRouter implementation
class TaskDetailsRouter: NSObject, TaskDetailsRouterProtocol {
    weak var delegate: TaskDetailsRouterDelegate?
    var presenter: TaskDetailsPresenter?
    var navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController? = .none) {
        self.navigationController = navigationController
        super.init()
    }
    
    func load(with task: Task) {
        if let nav = navigationController {
            nav.pushViewController(createViewController(with: task), animated: true)
        }
    }
    
    func createViewController(with task: Task) -> UIViewController {
        let interactor = TaskDetailsInteractor()
        let presenter = TaskDetailsPresenter(interactor: interactor, delegate: self, task: task)
        let controller = TaskDetailsViewController(presenter: presenter)
        self.presenter = presenter
        return controller
    }
    
}

// MARK: - TaskDetailsPresenter delegate
extension TaskDetailsRouter: TaskDetailsPresenterDelegate {
    func openEditTaskForm(with task: Task) {
        // TODO: Will be implement
    }
    
    func presenterDidFinish() {
        if let nav = navigationController {
            delegate?.taskDetailsRouterDidFinish()
            nav.popViewController(animated: true)
        }
    }
}


