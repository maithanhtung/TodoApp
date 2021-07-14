//
//  TaskFormRouter.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import UIKit

 // MARK: - TaskFormRouterDelegate declaration
 protocol TaskFormRouterDelegate: AnyObject {
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

     func load() {
         if let nav = navigationController {
             nav.pushViewController(createViewController(), animated: true)
         }
     }

     func createViewController() -> UIViewController {
         let interactor = TaskFormInteractor()
         let presenter = TaskFormPresenter(interactor: interactor, delegate: self)
         let controller = TaskFormViewController(presenter: presenter)

         return controller
     }

 }

 // MARK: - TaskFormPresenter delegate
 extension TaskFormRouter: TaskFormPresenterDelegate {
 }
