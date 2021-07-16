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

// MARK: - TaskFormPresenterDelegate declaration
protocol TaskFormPresenterDelegate: AnyObject {
    func presenterDidFinish()
    
}

// MARK: - TaskFormPresenterProtocol declaration
protocol TaskFormPresenterProtocol: NSObject {
    
    var viewController: TaskFormViewControllerProtocol? { get set }
    
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
        guard let taskTitle = taskTitle, let taskDesc = taskDesc, let taskReminder = taskReminder else {
            //TODO: implement show error to user
            print("missing some thing")
            return
        }
        let newTask: Task = Task(title: taskTitle, description: taskDesc, dueDate: Date(), reminderText: taskReminder)
        
        viewController?.showLoadingView()
        interactor.addTask(with: newTask)
    }
    
}

// MARK: - TaskFormInteractor delegate
extension TaskFormPresenter: TaskFormInteractorDelegate {
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

