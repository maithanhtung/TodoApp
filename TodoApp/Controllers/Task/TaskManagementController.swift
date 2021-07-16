//
//  TaskManagementController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 15.7.2021.
//

import Foundation

// MARK: - TaskFormViewController implementation
class TaskManagementController {
    
    private let taskListKey: String = "Task list"
    
    let userDefault: UserDefaults = UserDefaults.standard
    
    private func loadTaskList(from jsonString: String) -> TaskList? {
        if let dataFromJsonString = jsonString.data(using: .utf8) {
            return try? JSONDecoder().decode(TaskList.self, from: dataFromJsonString)
        }
        return nil
    }
    
    private func encodedData(with taskList: TaskList) -> String? {
        if let encodedData = try? JSONEncoder().encode(taskList) {
            return String(data: encodedData, encoding: .utf8)
        }
        return nil
    }
    
    private func taskList(from oldTasks: [Task]?, with newTask: Task) -> TaskList {
        var task: Task = newTask
        var taskArray: [Task] = []
        
        if let tasks = oldTasks, let lastItemId = tasks.last?.id {
            // if there is existing tasks, append new task with id = last task id + 1.
            task.id = String((Int(lastItemId) ?? 0).advanced(by: 1))
            taskArray = tasks
        } else {
            // start with 0
            task.id = String(0)
        }
        taskArray.append(task)
        
        return TaskList(tasks: taskArray)
    }
    
    func fetchTaskList(onSuccess: @escaping (TaskList) -> Void,
                       onFail: (TDError) -> Void) {
        // get Task List Json string from local
        guard let taskListString = userDefault.string(forKey: taskListKey) else {
            // return empty taskList if there is nothing saved
            let taskList: TaskList = TaskList(tasks: [])
            onSuccess(taskList)
            return
        }
        
        // decode Json string to Object
        guard let list = loadTaskList(from: taskListString) else {
            onFail(TDError(errorString: "Unable to unarchived"))
            return
        }
        onSuccess(list)
    }
    
    func addTask(with newTask: Task, onSuccess: () -> Void,
                 onFail: (TDError) -> Void) {
        // get Task List Json string from local
        guard let taskListData = userDefault.string(forKey: taskListKey) else {
            // first time - create new Task List
            let newTaskList: TaskList = taskList(from: nil, with: newTask)
            // encode to Json String with new TaskList
            guard let newTaskListEncodeString = encodedData(with: newTaskList) else {
                onFail(TDError(errorString: "Unable to encode"))
                return
            }
            // set value to user default
            userDefault.setValue(newTaskListEncodeString, forKey: taskListKey)
            onSuccess()
            return
        }
        
        // decode Json string to Object
        guard let oldList = loadTaskList(from: taskListData) else {
            onFail(TDError(errorString: "Unable to encode"))
            return
        }
        
        // create new taskList base on old Task list with new Task
        let newTaskList: TaskList = taskList(from: oldList.tasks, with: newTask)
        
        // encode to Json String with new TaskList
        guard let newTaskListEncodeString = encodedData(with: newTaskList) else {
            onFail(TDError(errorString: "Unable to archived"))
            return
        }
        
        // set value to user default
        userDefault.setValue(newTaskListEncodeString, forKey: taskListKey)
        onSuccess()
    }
    
    func editTask(with task: Task, onSuccess: () -> Void,
                  onFail: (TDError) -> Void) {
        // get Task List Json string from local
        guard let taskListString = userDefault.string(forKey: taskListKey) else {
            onFail(TDError(errorString: "TaskList not created yet to be edit"))
            return
        }
        
        // decode Json string to Object
        guard let oldList = loadTaskList(from: taskListString) else {
            onFail(TDError(errorString: "Unable to encode"))
            return
        }
        
        // find task need to be edit
        var tasks = oldList.tasks
        guard let index = tasks.firstIndex(where: {$0.id == task.id}) else {
            onFail(TDError(errorString: "Task not found"))
            return
        }
        
        // remove the old task from list
        tasks.remove(at: index)
        // insert the new task
        tasks.insert(task, at: index)
        
        // encode to Json String with new TaskList
        guard let newTaskListEncodeString = encodedData(with: TaskList(tasks: tasks)) else {
            onFail(TDError(errorString: "Unable to encode"))
            return
        }
        
        // set value to user default
        userDefault.setValue(newTaskListEncodeString, forKey: taskListKey)
        
        onSuccess()
    }
    
    func deleteTask(with taskId: String, onSuccess: () -> Void,
                    onFail: (TDError) -> Void) {
        guard let taskListData = userDefault.string(forKey: taskListKey) else {
            onFail(TDError(errorString: "TaskList not created yet to be edit"))
            return
        }
        
        guard let oldList = loadTaskList(from: taskListData) else {
            onFail(TDError(errorString: "Unable to encode"))
            return
        }
        
        var tasks = oldList.tasks
        guard let index = tasks.firstIndex(where: {$0.id == taskId}) else {
            onFail(TDError(errorString: "Task not found"))
            return
        }
        tasks.remove(at: index)
        
        guard let newTaskListEncodeString = encodedData(with: TaskList(tasks: tasks)) else {
            onFail(TDError(errorString: "Unable to encode"))
            return
        }
        // set value
        userDefault.setValue(newTaskListEncodeString, forKey: taskListKey)
        
        onSuccess()
    }
    
    // clear everything
    func resetUserDefaults() {
        userDefault.removePersistentDomain(forName: Bundle.main.bundleIdentifier ?? "")
        userDefault.synchronize()
    }
    
}
