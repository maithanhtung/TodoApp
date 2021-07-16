//
//  TaskListPresenterTest.swift
//  TodoAppTests
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import XCTest
@testable import TodoApp

private class MockDelegate: TaskListPresenterDelegate {
    var didCallOpenAddTaskForm: Bool = false
    func openAddTaskForm() {
        didCallOpenAddTaskForm = true
    }
    
    var didCallOpenTaskDetail: Bool = false
    var taskIdForDetail: String?
    func openTaskDetail(with taskId: String) {
        didCallOpenTaskDetail = true
        taskIdForDetail = taskId
    }
    
    var didCallLogout: Bool = false
    func logout() {
        didCallLogout = true
    }
    
    func resetMockDelegateValues() {
        didCallOpenAddTaskForm = false
        didCallOpenTaskDetail = false
        didCallLogout = false
        taskIdForDetail = nil
    }
}

private class MockInteractor: NSObject, TaskListInteractorProtocol {
    weak var delegate: TaskListInteractorDelegate?
    
    var didCallFetchTaskList: Bool = false
    func fetchTaskList() {
        didCallFetchTaskList = true
    }
}

private class MockViewController: NSObject, TaskListViewControllerProtocol {
    var didCallShowLoadingView: Bool = false
    func showLoadingView() {
        didCallShowLoadingView = true
    }
    
    var didCallDissmissLoadingView: Bool = false
    func dissmissLoadingView() {
        didCallDissmissLoadingView = true
    }
    
    var didCallRefreshView: Bool = false
    func refreshView() {
        didCallRefreshView = true
    }
    
    func resetMockViewControllerValues() {
        didCallShowLoadingView = false
        didCallDissmissLoadingView = false
        didCallRefreshView = false
    }
}

class TaskListPresenterTest: XCTestCase {

    private var testedPresenter: TaskListPresenter!
    private var mockInteractor: MockInteractor!
    private var mockDelegate: MockDelegate!
    private var mockViewController: MockViewController!

    override func setUp() {
        super.setUp()

        mockDelegate = MockDelegate()
        mockInteractor = MockInteractor()
        testedPresenter = TaskListPresenter(interactor: mockInteractor, delegate: mockDelegate)
        mockViewController = MockViewController()
        testedPresenter.viewController = mockViewController
    }
    
    func testInit() {
        XCTAssertNotNil(testedPresenter)
    }
    
    func testViewIsReady() {
        testedPresenter.viewIsReady()
        
        XCTAssertTrue(mockViewController.didCallShowLoadingView)
        XCTAssertTrue(mockInteractor.didCallFetchTaskList)
        
        testedPresenter.taskListFetchSucceeded(with: taskListMock)
        XCTAssertTrue(mockViewController.didCallDissmissLoadingView)
        XCTAssertTrue(mockViewController.didCallRefreshView)
    }
    
    func testAddTask() {
        testedPresenter.addTask()
        
        XCTAssertTrue(mockDelegate.didCallOpenAddTaskForm)
    }
    
    func testLogout() {
        testedPresenter.logout()
        
        XCTAssertTrue(mockDelegate.didCallLogout)
    }
    
    func testNumberOfItem() {
        testedPresenter.taskListFetchFailed(with: TDError(errorString: "error"))
        XCTAssertTrue(mockViewController.didCallDissmissLoadingView)
        XCTAssertEqual(testedPresenter.numberOfItem(section: 0), 0)
        
        testedPresenter.taskListFetchSucceeded(with: taskListMock)
        
        XCTAssertTrue(mockViewController.didCallDissmissLoadingView)
        XCTAssertEqual(testedPresenter.numberOfItem(section: 0), 4)
        XCTAssertEqual(testedPresenter.numberOfItem(section: 1), 0)
    }
    
    func testItemAtIndexPath() {
        testedPresenter.taskListFetchFailed(with: TDError(errorString: "error"))
        XCTAssertNil(testedPresenter.taskItem(at: IndexPath(row: 0, section: 0)))
        
        testedPresenter.taskListFetchSucceeded(with: taskListMock)
        XCTAssertEqual(testedPresenter.taskItem(at: IndexPath(row: 0, section: 0))?.title, "title 1")
        XCTAssertEqual(testedPresenter.taskItem(at: IndexPath(row: 1, section: 0))?.title, "title 2")
        XCTAssertNil(testedPresenter.taskItem(at: IndexPath(row: 10, section: 0)))
        XCTAssertNil(testedPresenter.taskItem(at: IndexPath(row: 0, section: 2)))
    }
    
    func testDidSelectItemAtIndexPath() {
        testedPresenter.taskListFetchFailed(with: TDError(errorString: "error"))
        testedPresenter.didSelectItem(at: IndexPath(row: 0, section: 0))
        XCTAssertFalse(mockDelegate.didCallOpenTaskDetail)
        XCTAssertNil(mockDelegate.taskIdForDetail)
        
        mockDelegate.resetMockDelegateValues()
        
        testedPresenter.taskListFetchSucceeded(with: taskListMock)
        testedPresenter.didSelectItem(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mockDelegate.didCallOpenTaskDetail)
        XCTAssertEqual(mockDelegate.taskIdForDetail, "task 1")

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
