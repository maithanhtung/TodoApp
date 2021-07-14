//
//  TaskFormInteractor.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import Foundation

 // MARK: - TaskFormInteractorDelegate declaration
 protocol TaskFormInteractorDelegate: AnyObject {
 }

 // MARK: - TaskFormInteractorProtocol declaration
 protocol TaskFormInteractorProtocol: NSObject {
     var delegate: TaskFormInteractorDelegate? { get set }
 }

 // MARK: - TaskFormInteractor implementation
 class TaskFormInteractor: NSObject, TaskFormInteractorProtocol {
     weak var delegate: TaskFormInteractorDelegate?
     required override init() {
         super.init()
     }
 }
