//
//  TaskDetailsViewController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 16.7.2021.
//

import UIKit

// MARK: - TaskDetailsViewControllerProtocol declaration
protocol TaskDetailsViewControllerProtocol: BaseViewControllerProtocol {
}

// MARK: - TaskDetailsViewController implementation
class TaskDetailsViewController: BaseViewController {
    
    private let presenter: TaskDetailsPresenterProtocol

    required init(presenter: TaskDetailsPresenterProtocol) {
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

extension TaskDetailsViewController: TaskDetailsViewControllerProtocol {
}
