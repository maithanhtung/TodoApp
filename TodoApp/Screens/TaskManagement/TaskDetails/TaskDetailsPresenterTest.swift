//
//  TaskDetailsPresenterTest.swift
//  TodoAppTests
//
//  Created by Mai Thanh Tung on 16.7.2021.
//

import XCTest
@testable import TodoApp

private class MockDelegate: TaskDetailsPresenterDelegate {
    
    var didCallPresenterFinish: Bool = false
    func presenterDidFinish() {
        didCallPresenterFinish = true
    }
    
    var didCallOpenEditTaskForm: Bool = false
    var taskForEdit: Task?
    func openEditTaskForm(with task: Task) {
        didCallOpenEditTaskForm = true
        taskForEdit = task
    }
    
}

private class MockInteractor: NSObject, TaskDetailsInteractorProtocol {
    var delegate: TaskDetailsInteractorDelegate?
    
    var didCallDeleteTask: Bool = false
    var taskToDelete: Task?
    func delete(task: Task) {
        didCallDeleteTask = true
        taskToDelete = task
    }
    
    var didCallFetchTask: Bool = false
    var taskIdForFetching: String?
    func fetchTask(taskId: String) {
        didCallFetchTask = true
        taskIdForFetching = taskId
    }
}

private class MockViewController: NSObject, TaskDetailsViewControllerProtocol {
    
    var didCallRefreshView: Bool = false
    func refreshView() {
        didCallRefreshView = true
    }
    
    var didCallShowSuccessBanner: Bool = false
    func showSuccessBanner(with message: String) {
        didCallShowSuccessBanner = true
    }
    
    var didCallShowErrorBanner: Bool = false
    func showErrorBanner(with errorString: String) {
        didCallShowErrorBanner = true
    }
    
    var didCallShowLoadingView: Bool = false
    func showLoadingView() {
        didCallShowLoadingView = true
    }
    
    var didCallDissmissLoadingView: Bool = false
    func dissmissLoadingView() {
        didCallDissmissLoadingView = true
    }
    
    func resetMockViewControllerValues() {
        didCallShowLoadingView = false
        didCallDissmissLoadingView = false
        didCallShowSuccessBanner = false
        didCallShowErrorBanner = false
        didCallRefreshView = false
    }
}

class TaskDetailsPresenterTest: XCTestCase {
    private var testedPresenter: TaskDetailsPresenter!
    private var mockInteractor: MockInteractor!
    private var mockDelegate: MockDelegate!
    private var mockViewController: MockViewController!

    override func setUp() {
        super.setUp()

        mockDelegate = MockDelegate()
        mockInteractor = MockInteractor()
        testedPresenter = TaskDetailsPresenter(interactor: mockInteractor, delegate: mockDelegate, task: Task(id: "test id", title: "test title", description: "test desc", dueDate: Date(), reminderText: "test reminder text"))
        mockViewController = MockViewController()
        testedPresenter.viewController = mockViewController
    }
    
    func testInit() {
        XCTAssertNotNil(testedPresenter)
    }
    
    func testEditTask() {
        testedPresenter.editTask()
        XCTAssertTrue(mockDelegate.didCallOpenEditTaskForm)
        XCTAssertNotNil(mockDelegate.taskForEdit)
        XCTAssertEqual(mockDelegate.taskForEdit?.id, "test id")
    }
    
    func testDeleteTask() {
        testedPresenter.deleteTask()
        XCTAssertTrue(mockInteractor.didCallDeleteTask)
        XCTAssertTrue(mockViewController.didCallShowLoadingView)
        XCTAssertNotNil(mockInteractor.taskToDelete)
        XCTAssertEqual(mockInteractor.taskToDelete?.id,"test id")
        
        testedPresenter.deleteTaskFailed(with: TDError(errorString: "error"))
        XCTAssertFalse(mockDelegate.didCallPresenterFinish)
        XCTAssertTrue(mockViewController.didCallShowErrorBanner)
        XCTAssertFalse(mockViewController.didCallShowSuccessBanner)
        XCTAssertTrue(mockViewController.didCallDissmissLoadingView)
        
        mockViewController.resetMockViewControllerValues()
        
        testedPresenter.deleteTaskSucceeded()
        XCTAssertTrue(mockDelegate.didCallPresenterFinish)
        XCTAssertFalse(mockViewController.didCallShowErrorBanner)
        XCTAssertTrue(mockViewController.didCallShowSuccessBanner)
        XCTAssertTrue(mockViewController.didCallDissmissLoadingView)
    }
    
    func testUpdateTask() {
        testedPresenter = TaskDetailsPresenter(interactor: mockInteractor, delegate: mockDelegate, task: Task(id: nil, title: "test title", description: "test desc", dueDate: Date(), reminderText: "test reminder text"))
        testedPresenter.fetchUpdateTask()
        XCTAssertFalse(mockInteractor.didCallFetchTask)
        
        testedPresenter = TaskDetailsPresenter(interactor: mockInteractor, delegate: mockDelegate, task: Task(id: "test id", title: "test title", description: "test desc", dueDate: Date(), reminderText: "test reminder text"))
        testedPresenter.fetchUpdateTask()
        XCTAssertTrue(mockInteractor.didCallFetchTask)
    }
    
}
