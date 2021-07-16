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
    
    func resetMockInteractorValues() {
        didCallAddTask = false
        newTask = nil
    }
}

private class MockViewController: NSObject, TaskFormViewControllerProtocol {
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
        
        mockInteractor.resetMockInteractorValues()
        
        testedPresenter.setValue(for: 0, with: "title")
        testedPresenter.submit()
        XCTAssertFalse(mockInteractor.didCallAddTask)
        XCTAssertNil(mockInteractor.newTask)
        
        mockInteractor.resetMockInteractorValues()
        
        testedPresenter.setValue(for: 0, with: "Title")
        testedPresenter.setValue(for: 1, with: "Desc")
        testedPresenter.setValue(for: 2, with: "Reminder")
        testedPresenter.submit()
        XCTAssertTrue(mockInteractor.didCallAddTask)
        XCTAssertNotNil(mockInteractor.newTask)
        XCTAssertEqual(mockInteractor.newTask?.title, "Title")
        XCTAssertEqual(mockInteractor.newTask?.id, "")
    }
    
    func testAddTask() {
        testedPresenter.setValue(for: 0, with: "Title")
        testedPresenter.setValue(for: 1, with: "Desc")
        testedPresenter.setValue(for: 2, with: "Reminder")
        testedPresenter.submit()
        XCTAssertTrue(mockViewController.didCallShowLoadingView)
        
        testedPresenter.taskAddFailed(with: TDError(errorString: "error"))
        XCTAssertTrue(mockViewController.didCallDissmissLoadingView)
        XCTAssertFalse(mockDelegate.didCallPresenterDidFinish)
        
        testedPresenter.taskAddSucceeded()
        XCTAssertTrue(mockViewController.didCallDissmissLoadingView)
        XCTAssertTrue(mockDelegate.didCallPresenterDidFinish)
    }
}

