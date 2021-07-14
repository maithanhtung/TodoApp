//
//  TaskFormPresenter.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import Foundation

 // MARK: - TaskFormPresenterDelegate declaration
 protocol TaskFormPresenterDelegate: AnyObject {

 }

 // MARK: - TaskFormPresenterProtocol declaration
 protocol TaskFormPresenterProtocol: NSObject {

     var viewController: TaskFormViewControllerProtocol? { get set }

     init(interactor: TaskFormInteractorProtocol, delegate: TaskFormPresenterDelegate)

 }

 // MARK: - TaskFormPresenter implementation
 class TaskFormPresenter: NSObject, TaskFormPresenterProtocol {

     weak var viewController: TaskFormViewControllerProtocol?

     private let interactor: TaskFormInteractorProtocol
     private let delegate: TaskFormPresenterDelegate

     required init(interactor: TaskFormInteractorProtocol, delegate: TaskFormPresenterDelegate) {
         self.interactor = interactor
         self.delegate = delegate

         super.init()
         self.interactor.delegate = self
     }

 }

 // MARK: - TaskFormInteractor delegate
 extension TaskFormPresenter: TaskFormInteractorDelegate {
 }

