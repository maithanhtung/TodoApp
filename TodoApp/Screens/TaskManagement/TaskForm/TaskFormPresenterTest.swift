//
//  TaskFormPresenterTest.swift
//  TodoAppTests
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import XCTest
@testable import TodoApp

private class MockDelegate: TaskFormPresenterDelegate {
    var didCallPresenterDidFinish: Bool = false
    func presenterDidFinish() {
        didCallPresenterDidFinish = true
    }
    
    func resetMockDelegateValues() {
        didCallPresenterDidFinish = false
    }
}

private class MockInteractor: NSObject, TaskFormInteractorProtocol {
    
    weak var delegate: TaskFormInteractorDelegate?
    
    var didCallAddTask: Bool = false
    var newTask: Task?
    func addTask(with task: Task) {
        didCallAddTask = true
        newTask = task
    }
    
    var didCallEditTask: Bool = false
    var editedTask: Task?
    func editTask(with task: Task) {
        didCallEditTask = true
        editedTask = task
    }
    
    func resetMockInteractorValues() {
        didCallAddTask = false
        newTask = nil
        didCallEditTask = false
        editedTask = nil
    }
}

private class MockViewController: NSObject, TaskFormViewControllerProtocol {
    
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
    
    var didCallRefreshView: Bool = false
    func refreshView() {
        didCallRefreshView = true
    }
    
    func resetMockViewControllerValues() {
        didCallShowLoadingView = false
        didCallDissmissLoadingView = false
        didCallRefreshView = false
        didCallShowSuccessBanner = false
        didCallShowErrorBanner = false
    }
}

class TaskFormPresenterTest: XCTestCase {
    
    private var testedPresenter: TaskFormPresenter!
    private var mockInteractor: MockInteractor!
    private var mockDelegate: MockDelegate!
    private var mockViewController: MockViewController!
    
    override func setUp() {
        super.setUp()
        
        mockDelegate = MockDelegate()
        mockInteractor = MockInteractor()
        testedPresenter = TaskFormPresenter(interactor: mockInteractor, delegate: mockDelegate)
        mockViewController = MockViewController()
        testedPresenter.viewController = mockViewController
    }
    
    func testInit() {
        XCTAssertNotNil(testedPresenter)
    }
    
    func testSetValueAndSubmit() {
        testedPresenter.submit()
        XCTAssertFalse(mockInteractor.didCallAddTask)
        XCTAssertNil(mockInteractor.newTask)
        XCTAssertTrue(mockViewController.didCallShowErrorBanner)
        
        mockInteractor.resetMockInteractorValues()
        
        testedPresenter.setValue(for: 0, with: "title")
        testedPresenter.submit()
        XCTAssertFalse(mockInteractor.didCallAddTask)
        XCTAssertNil(mockInteractor.newTask)
        XCTAssertTrue(mockViewController.didCallShowErrorBanner)
        
        mockInteractor.resetMockInteractorValues()
        
        testedPresenter.setValue(for: 0, with: "Title")
        testedPresenter.setValue(for: 1, with: "Desc")
        testedPresenter.setValue(for: 2, with: "Reminder")
        testedPresenter.dueDate = Date()
        testedPresenter.submit()
        XCTAssertTrue(mockViewController.didCallShowErrorBanner)
        XCTAssertFalse(mockInteractor.didCallAddTask)
        XCTAssertNil(mockInteractor.newTask)
        
        mockInteractor.resetMockInteractorValues()
        
        testedPresenter.dueDate = Date(timeIntervalSinceNow: 30)
        testedPresenter.submit()
        XCTAssertTrue(mockInteractor.didCallAddTask)
        XCTAssertNotNil(mockInteractor.newTask)
        XCTAssertEqual(mockInteractor.newTask?.title, "Title")
        XCTAssertNil(mockInteractor.newTask?.id)
        XCTAssertEqual(mockInteractor.newTask?.taskStatus, .active)
        
        mockInteractor.resetMockInteractorValues()
        testedPresenter.task = Task(id: "some id", title: "some title", description: "some desc", dueDate: Date(timeIntervalSinceNow: 30), reminderText: "some reminder", taskStatus: .done)
        testedPresenter.taskStatus = .done
        testedPresenter.submit()
        XCTAssertFalse(mockInteractor.didCallAddTask)
        XCTAssertTrue(mockInteractor.didCallEditTask)
        XCTAssertNotNil(mockInteractor.editedTask)
        XCTAssertEqual(mockInteractor.editedTask?.title, "some title")
        XCTAssertNotNil(mockInteractor.editedTask?.id)
        XCTAssertEqual(mockInteractor.editedTask?.id, "some id")
        XCTAssertEqual(mockInteractor.editedTask?.taskStatus, .done)
    }
    
    func testAddTask() {
        testedPresenter.setValue(for: 0, with: "Title")
        testedPresenter.setValue(for: 1, with: "Desc")
        testedPresenter.setValue(for: 2, with: "Reminder")
        testedPresenter.dueDate = Date(timeIntervalSinceNow: 30)
        testedPresenter.submit()
        XCTAssertTrue(mockViewController.didCallShowLoadingView)
        XCTAssertTrue(mockInteractor.didCallAddTask)
        
        testedPresenter.taskAddFailed(with: TDError(errorString: "error"))
        XCTAssertTrue(mockViewController.didCallShowErrorBanner)
        XCTAssertTrue(mockViewController.didCallDissmissLoadingView)
        XCTAssertFalse(mockDelegate.didCallPresenterDidFinish)
        
        testedPresenter.taskAddSucceeded()
        XCTAssertTrue(mockViewController.didCallShowSuccessBanner)
        XCTAssertTrue(mockViewController.didCallDissmissLoadingView)
        XCTAssertTrue(mockDelegate.didCallPresenterDidFinish)
    }
    
    func testEditTask() {
        testedPresenter.task = Task(id: "some id", title: "some title", description: "some desc", dueDate: Date(timeIntervalSinceNow: 30), reminderText: "some reminder")
        testedPresenter.dueDate = Date(timeIntervalSinceNow: 30)
        testedPresenter.taskStatus = .done
        testedPresenter.submit()
        XCTAssertTrue(mockViewController.didCallShowLoadingView)
        XCTAssertTrue(mockInteractor.didCallEditTask)
        
        testedPresenter.taskEditFailed(with: TDError(errorString: "error"))
        XCTAssertTrue(mockViewController.didCallShowErrorBanner)
        XCTAssertTrue(mockViewController.didCallDissmissLoadingView)
        XCTAssertFalse(mockDelegate.didCallPresenterDidFinish)
        
        testedPresenter.taskEditSucceeded()
        XCTAssertTrue(mockViewController.didCallShowSuccessBanner)
        XCTAssertTrue(mockViewController.didCallDissmissLoadingView)
        XCTAssertTrue(mockDelegate.didCallPresenterDidFinish)
    }
}

