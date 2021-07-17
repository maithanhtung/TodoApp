//
//  TaskFormViewController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 14.7.2021.
//

import UIKit

// MARK: - TaskFormViewControllerProtocol declaration
protocol TaskFormViewControllerProtocol: BaseViewControllerProtocol {
    func refreshView()
}

// MARK: - TaskFormViewController implementation
class TaskFormViewController: BaseViewController {
    
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
        title = presenter.task == nil ? "Task Form" : "Edit task"
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
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
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var taskTitleInputView: CCInputFieldView = {
        let inputView: CCInputFieldView = CCInputFieldView()
        inputView.title = "taskTitleInputView"
        inputView.textFieldDelegate = self
        if let task = presenter.task {
            inputView.inputText = task.title
        }
        inputView.inputTag = TaskFormInputFields.titleInput.rawValue
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    private lazy var taskDescInputView: CCInputFieldView = {
        let inputView: CCInputFieldView = CCInputFieldView()
        inputView.title = "taskDescInputView"
        inputView.textFieldDelegate = self
        if let task = presenter.task {
            inputView.inputText = task.description
        }
        inputView.inputTag = TaskFormInputFields.descInput.rawValue
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    private lazy var dueDatePickerView: CCCellView = {
        let dueDatePickerView: CCCellView = CCCellView(style: .selectionCell)
        dueDatePickerView.title = "Due date"
        dueDatePickerView.subTitle = "Select date"
        dueDatePickerView.translatesAutoresizingMaskIntoConstraints = false
        if let dueDate = presenter.dueDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YY HH:mm"
            
            dueDatePickerView.subTitle = dateFormatter.string(from: dueDate)
        }
        dueDatePickerView.isUserInteractionEnabled = true
        dueDatePickerView.addGestureRecognizer(createTapRecognizer())
        
        return dueDatePickerView
    }()
    
    private lazy var taskReminderInputView: CCInputFieldView = {
        let inputView: CCInputFieldView = CCInputFieldView()
        inputView.title = "taskRemindernputView"
        inputView.textFieldDelegate = self
        if let task = presenter.task {
            inputView.inputText = task.reminderText
        }
        inputView.inputTag = TaskFormInputFields.reminderInput.rawValue
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
        view.endEditing(true)
        presenter.submit()
    }
    
    private func setupView() {
        contentView.addArrangedSubview(taskTitleInputView)
        contentView.addArrangedSubview(taskDescInputView)
        contentView.addArrangedSubview(dueDatePickerView)
        contentView.addArrangedSubview(taskReminderInputView)
        
        scrollView.addSubview(contentView)
        scrollView.addSubview(submitButton)
        
        fill(with: scrollView)
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
            submitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -CCMargin.xx_large),
            
            scrollView.widthAnchor.constraint(equalTo: view.availableGuide.widthAnchor)
        ])
        
        view.layoutIfNeeded()
    }
    
    // Tap handle
    func createTapRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        if let nav = navigationController, sender?.state == .ended {
            let datePickerVC: DatePickerViewController = DatePickerViewController()
            datePickerVC.delegate = self
            nav.modalPresentationStyle = .popover
            nav.present(datePickerVC, animated: true, completion: nil)
        }
    }
    
}

// MARK: - TaskFormViewControllerProtocol implementation
extension TaskFormViewController: TaskFormViewControllerProtocol {
    func refreshView() {
        if let dueDate = presenter.dueDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YY HH:mm"
            
            dueDatePickerView.subTitle = dateFormatter.string(from: dueDate)
        }
    }
}

// MARK: - UITextFieldDelegate implementation
extension TaskFormViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.setValue(for: textField.tag, with: textField.text)
    }
}

// MARK: - DatePickerViewControllerDelegate implementation
extension TaskFormViewController: DatePickerViewControllerDelegate {
    func didSelectDate(date: Date) {
        presenter.dueDate = date
    }
}
