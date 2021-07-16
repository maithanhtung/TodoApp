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
    
    func taskItem(at indexPath: IndexPath) -> Task?
    
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
        viewController?.showLoadingView()
        interactor.fetchTaskList()
    }
    
    func addTask() {
        delegate.openAddTaskForm()
    }
    
    func numberOfItem(section: Int) -> Int {
        guard let list = taskList?.tasks, section == 0 else {
            return 0
        }
        return list.count
    }
    
    func taskItem(at indexPath: IndexPath) -> Task? {
        guard let list = taskList?.tasks, list.count > indexPath.row, indexPath.section == 0 else {
            return nil
        }
        return list[indexPath.row]
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        if let task = taskItem(at: indexPath) {
            delegate.openTaskDetail(with: task.id)
        }
    }
    
}

// MARK: - TaskListInteractor delegate
extension TaskListPresenter: TaskListInteractorDelegate {
    func taskListFetchSucceeded(with list: TaskList) {
        taskList = list
        viewController?.refreshView()
        viewController?.dissmissLoadingView()
    }
    
    func taskListFetchFailed(with error: TDError) {
        //TODO: implement show error to user
        print(error.errorString)
        viewController?.dissmissLoadingView()
    }
}

