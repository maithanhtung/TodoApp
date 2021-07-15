//
//  TaskFormViewController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import UIKit

enum TaskFormInputFields: Int, CaseIterable {
    case titleInput = 0,
         descInput,
         reminderInput
}

 // MARK: - TaskFormViewControllerProtocol declaration
 protocol TaskFormViewControllerProtocol: NSObject {

 }

 // MARK: - TaskFormViewController implementation
 class TaskFormViewController: UIViewController {

     private let presenter: TaskFormPresenterProtocol

     required init(presenter: TaskFormPresenterProtocol) {
         self.presenter = presenter

         super.init(nibName: .none, bundle: .none)

         self.presenter.viewController = self
     }

     required init?(coder aDecoder: NSCoder) {
         assertionFailure("init(coder:) has not been implemented")
         return nil
     }

     override func viewDidLoad() {
         super.viewDidLoad()
        title = "Task Form"
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        edgesForExtendedLayout = .all
        setupView()
     }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    private lazy var contentView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = CCMargin.small
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var taskTitleInputView: CCInputFieldView = {
        let inputView: CCInputFieldView = CCInputFieldView()
        inputView.title = "taskTitleInputView"
        inputView.textFieldDelegate = self
        inputView.tag = TaskFormInputFields.titleInput.rawValue
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    private lazy var taskDescInputView: CCInputFieldView = {
        let inputView: CCInputFieldView = CCInputFieldView()
        inputView.title = "taskDescInputView"
        inputView.textFieldDelegate = self
        inputView.tag = TaskFormInputFields.descInput.rawValue
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    private lazy var dueDatePickerView: CCCellView = {
        let dueDatePickerView: CCCellView = CCCellView()
        dueDatePickerView.title = "Select duedate"
        dueDatePickerView.subTitle = "Please select"
        dueDatePickerView.translatesAutoresizingMaskIntoConstraints = false
        return dueDatePickerView
    }()
    
    private lazy var taskReminderInputView: CCInputFieldView = {
        let inputView: CCInputFieldView = CCInputFieldView()
        inputView.title = "taskRemindernputView"
        inputView.textFieldDelegate = self
        inputView.tag = TaskFormInputFields.reminderInput.rawValue
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    private lazy var submitButton: CCButton = {
        let button: CCButton = CCButton()
        
        button.setTitle("Submit", for: .normal)
        button.setBackgroundColor(.systemBlue, for: .normal)
        button.actionHandler = { [weak self] _ in
            self?.submitButtonPressed()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private func submitButtonPressed() {
        // check data require and send to presenter
    }
    
    private func setupView() {
        contentView.addArrangedSubview(taskTitleInputView)
        contentView.addArrangedSubview(taskDescInputView)
        contentView.addArrangedSubview(dueDatePickerView)
        contentView.addArrangedSubview(taskReminderInputView)
        
        scrollView.addSubview(contentView)
        scrollView.addSubview(submitButton)
        
        view.addSubview(scrollView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            submitButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CCMargin.x_large),
            submitButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -CCMargin.x_large),
            submitButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CCMargin.xx_large),
            submitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -CCMargin.large),
            
            
            scrollView.leadingAnchor.constraint(equalTo: view.availableGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.availableGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.availableGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.availableGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.availableGuide.widthAnchor)
        ])
        
        view.layoutIfNeeded()
    }

 }

 // MARK: - TaskFormViewControllerProtocol implementation
 extension TaskFormViewController: TaskFormViewControllerProtocol {

 }

// MARK: - UITextFieldDelegate implementation
extension TaskFormViewController: UITextFieldDelegate {
    
}
