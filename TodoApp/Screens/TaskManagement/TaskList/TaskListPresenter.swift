//
//  TaskListPresenter.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 13.7.2021.
//

import Foundation

// MARK: - TaskListPresenterDelegate declaration
protocol TaskListPresenterDelegate: AnyObject {
    func openAddTaskForm()
    
    func openTaskDetail(with taskId: String)
}

// MARK: - TaskListPresenterProtocol declaration
protocol TaskListPresenterProtocol: NSObject {

    var viewController: TaskListViewControllerProtocol? { get set }

    init(interactor: TaskListInteractorProtocol, delegate: TaskListPresenterDelegate)

    // Call when view controller did load
    func viewIsReady()
    
    func addTask()
    
    func numberOfItem(section: Int) -> Int
    
    func taskItem(at indexPath: IndexPath) -> Task
    
    func didSelectItem(at indexPath: IndexPath)
}

// MARK: - TaskListPresenter implementation
class TaskListPresenter: NSObject, TaskListPresenterProtocol {

    weak var viewController: TaskListViewControllerProtocol?

    private let interactor: TaskListInteractorProtocol
    private let delegate: TaskListPresenterDelegate

    private var taskList: TaskList?
    
    required init(interactor: TaskListInteractorProtocol, delegate: TaskListPresenterDelegate) {
        self.interactor = interactor
        self.delegate = delegate

        super.init()
        self.interactor.delegate = self
    }
    
    func viewIsReady() {
        viewController?.refreshView()
    }
    
    func addTask() {
        delegate.openAddTaskForm()
    }
    
    func numberOfItem(section: Int) -> Int {
        return 2
    }
    
    func taskItem(at indexPath: IndexPath) -> Task {
        return Task(id: "id 1", title: "LOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOONG", description: "Description", dueDate: Date(), reminderText: "Reminder text")
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        let task: Task = taskItem(at: indexPath)
        delegate.openTaskDetail(with: task.id)
    }
    
}

// MARK: - TaskListInteractor delegate
extension TaskListPresenter: TaskListInteractorDelegate {
    func taskListFetchSucceeded() {
    }
    
    func taskListFetchFailed() {
    }
}

