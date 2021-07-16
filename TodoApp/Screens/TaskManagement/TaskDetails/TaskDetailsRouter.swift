//
//  TaskDetailsRouter.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 16.7.2021.
//

import UIKit

// MARK: - TaskDetailsRouterDelegate declaration
protocol TaskDetailsRouterDelegate: AnyObject {
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
    
    func load() {
        if let nav = navigationController {
            nav.pushViewController(createViewController(), animated: true)
        }
    }
    
    func createViewController() -> UIViewController {
        let interactor = TaskDetailsInteractor()
        let presenter = TaskDetailsPresenter(interactor: interactor, delegate: self)
        let controller = TaskDetailsViewController(presenter: presenter)
        self.presenter = presenter
        return controller
    }
    
}

// MARK: - TaskDetailsPresenter delegate
extension TaskDetailsRouter: TaskDetailsPresenterDelegate {
}


