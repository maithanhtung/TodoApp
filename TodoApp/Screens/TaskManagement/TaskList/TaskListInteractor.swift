//
//  TaskListInteractor.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 13.7.2021.
//

import Foundation

// MARK: - TaskListInteractorDelegate declaration
protocol TaskListInteractorDelegate: AnyObject {
    
    func taskListFetchSucceeded(with list: TaskList)
    
    func taskListFetchFailed()
}

// MARK: - TaskListInteractorProtocol declaration
protocol TaskListInteractorProtocol: NSObject {
    var delegate: TaskListInteractorDelegate? { get set }
    
    func fetchTaskList()
}

// MARK: - TaskListInteractor implementation
class TaskListInteractor: NSObject, TaskListInteractorProtocol {
    weak var delegate: TaskListInteractorDelegate?
    required override init() {
        super.init()
    }
    
    func fetchTaskList() {
        // to be implement, using some dummy data now
        delegate?.taskListFetchSucceeded(with: taskListMock)
    }
    
    private lazy var taskListMock: TaskList = {
        var taskList: TaskList = TaskList(tasks: [])
        let task1: Task = Task(id: "task 1", title: "title 1", description: "description 1", dueDate: Date(), reminderText: "reminder 1")
        let task2: Task = Task(id: "task 2", title: "title 2", description: "description 2", dueDate: Date(), reminderText: "reminder 2")
        let task3: Task = Task(id: "task 3", title: "title 3", description: "description 3", dueDate: Date(), reminderText: "reminder 3")
        let task4: Task = Task(id: "task 4", title: "title 4", description: "description 4", dueDate: Date(), reminderText: "reminder 4")
        taskList.tasks = [task1, task2, task3, task4]
        
        return taskList
    }()
}
