//
//  TaskFormPresenter.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import Foundation

enum TaskFormInputFields: Int, CaseIterable {
    case titleInput = 0,
         descInput,
         reminderInput
}

enum TaskFormSelectionCell: Int, CaseIterable {
    case dueDateSelection = 0,
         statusSelection
}


// MARK: - TaskFormPresenterDelegate declaration
protocol TaskFormPresenterDelegate: AnyObject {
    func presenterDidFinish()
    
}

// MARK: - TaskFormPresenterProtocol declaration
protocol TaskFormPresenterProtocol: NSObject {
    
    var viewController: TaskFormViewControllerProtocol? { get set }
    
    var dueDate: Date? { get set }
    
    var taskStatus: TaskStatus? { get set }
    
    var task: Task? { get set }
    
    init(interactor: TaskFormInteractorProtocol, delegate: TaskFormPresenterDelegate)
    
    func setValue(for field: TaskFormInputFields.RawValue, with value: String?)
    
    func submit()
    
}

// MARK: - TaskFormPresenter implementation
class TaskFormPresenter: NSObject, TaskFormPresenterProtocol {
    
    weak var viewController: TaskFormViewControllerProtocol?
    
    private let interactor: TaskFormInteractorProtocol
    private let delegate: TaskFormPresenterDelegate
    
    private var taskTitle: String?
    private var taskDesc: String?
    private var taskReminder: String?
    
    var taskStatus: TaskStatus? {
        didSet {
            viewController?.refreshView()
        }
    }
    
    var dueDate: Date? {
        didSet {
            viewController?.refreshView()
        }
    }
    
    var task: Task? {
        didSet {
            if let task = task {
                self.taskTitle = task.title
                self.taskDesc = task.description
                self.taskReminder = task.reminderText
            }
        }
    }

    required init(interactor: TaskFormInteractorProtocol, delegate: TaskFormPresenterDelegate) {
        self.interactor = interactor
        self.delegate = delegate
        
        super.init()
        self.interactor.delegate = self
    }
    
    func setValue(for field: TaskFormInputFields.RawValue, with value: String?) {
        switch field {
        case TaskFormInputFields.titleInput.rawValue:
            taskTitle = value
            return
        case TaskFormInputFields.descInput.rawValue:
            taskDesc = value
            return
        case TaskFormInputFields.reminderInput.rawValue:
            taskReminder = value
            return
        default:
            return
        }
    }
    
    func submit() {
        guard let taskTitle = taskTitle, taskTitle.count > 0, let taskDesc = taskDesc, taskDesc.count > 0, let taskReminder = taskReminder, taskReminder.count > 0, let dueDate = dueDate else {
            viewController?.showErrorBanner(with: "All field must be filled")
            return
        }
        if dueDate <= Date() {
            viewController?.showErrorBanner(with: "Due date should be in future")
            return
        }
        
        if let taskStatus = taskStatus, taskStatus == .overdue {
            viewController?.showErrorBanner(with: "Can't set task over due")
            return
        }
        
        let newTask: Task = Task(id: task?.id, title: taskTitle, description: taskDesc, dueDate: dueDate, reminderText: taskReminder, taskStatus: taskStatus ?? .active)
        
        viewController?.showLoadingView()
        if task == nil {
            interactor.addTask(with: newTask)
        } else {
            interactor.editTask(with: newTask)
        }
    }
    
}

// MARK: - TaskFormInteractor delegate
extension TaskFormPresenter: TaskFormInteractorDelegate {
    func taskEditSucceeded() {
        viewController?.showSuccessBanner(with: "Edit task successfully")
        delegate.presenterDidFinish()
        viewController?.dissmissLoadingView()
    }
    
    func taskEditFailed(with error: TDError) {
        viewController?.showErrorBanner(with: error.errorString)
        viewController?.dissmissLoadingView()
    }
    
    func taskAddSucceeded() {
        viewController?.showSuccessBanner(with: "Add task successfully")
        delegate.presenterDidFinish()
        viewController?.dissmissLoadingView()
    }
    
    func taskAddFailed(with error: TDError) {
        viewController?.showErrorBanner(with: error.errorString)
        viewController?.dissmissLoadingView()
    }
}

