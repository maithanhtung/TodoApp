//
//  TaskListViewController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 13.7.2021.
//

import UIKit

// MARK: - TaskListViewControllerProtocol declaration
protocol TaskListViewControllerProtocol: NSObject {
    
}

// MARK: - TaskListViewController implementation
class TaskListViewController: UIViewController {
    
    private let presenter: TaskListPresenterProtocol

    required init(presenter: TaskListPresenterProtocol) {
        self.presenter = presenter

        super.init(nibName: .none, bundle: .none)

        self.presenter.viewController = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// MARK: - TaskListViewControllerProtocol implementation
extension TaskListViewController: TaskListViewControllerProtocol {

}

