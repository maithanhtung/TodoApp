//
//  TaskFormRouter.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import UIKit

// MARK: - TaskFormRouterDelegate declaration
protocol TaskFormRouterDelegate: AnyObject {
    func taskFormRouterDidFinish()
}

// MARK: - TaskFormRouterProtocol declaration
protocol TaskFormRouterProtocol {
    
    var delegate: TaskFormRouterDelegate? { get set }
    
}

// MARK: - TaskFormRouter implementation
class TaskFormRouter: NSObject, TaskFormRouterProtocol {
    weak var delegate: TaskFormRouterDelegate?
    
    var navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        super.init()
    }
    
    func load(with editingTask: Task? = .none) {
        if let nav = navigationController {
            nav.pushViewController(createViewController(with: editingTask), animated: true)
        }
    }
    
    func createViewController(with editingTask: Task? = .none) -> UIViewController {
        let interactor = TaskFormInteractor()
        let presenter = TaskFormPresenter(interactor: interactor, delegate: self)
        if let editingTask = editingTask {
            presenter.task = editingTask
            presenter.dueDate = editingTask.dueDate
        }
        let controller = TaskFormViewController(presenter: presenter)
        
        return controller
    }
    
}

// MARK: - TaskFormPresenter delegate
extension TaskFormRouter: TaskFormPresenterDelegate {
    func presenterDidFinish() {
        if let nav = navigationController {
            delegate?.taskFormRouterDidFinish()
            nav.popViewController(animated: true)
        }
    }
}
