//
//  TaskFormViewController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import UIKit

 // MARK: - TaskFormViewControllerProtocol declaration
 protocol TaskFormViewControllerProtocol: NSObject {

 }

 // MARK: - TaskFormViewController implementation
 class TaskFormViewController: UIViewController {

     private let presenter: TaskFormPresenterProtocol

     required init(presenter: TaskFormPresenterProtocol) {
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

 // MARK: - TaskFormViewControllerProtocol implementation
 extension TaskFormViewController: TaskFormViewControllerProtocol {

 }
