//
//  TaskDetailsViewController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 16.7.2021.
//

import UIKit

// MARK: - TaskDetailsViewControllerProtocol declaration
protocol TaskDetailsViewControllerProtocol: BaseViewControllerProtocol {
    func refreshView()
}

// MARK: - TaskDetailsViewController implementation
class TaskDetailsViewController: BaseViewController {
    
    private let presenter: TaskDetailsPresenterProtocol
    
    required init(presenter: TaskDetailsPresenterProtocol) {
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
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        title = "Task Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTaskButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .systemGreen
        
        // custom back button
        self.navigationItem.hidesBackButton = true
            
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        setupView()
    }
    
    @objc func back() {
        presenter.back()
    }
    
    @objc func editTaskButtonPressed() {
        presenter.editTask()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
    
    private func createDividerLine() -> UIView {
        return {
            let divider: UIView = UIView()
            divider.backgroundColor = UIColor(named: "dividerLineColor")
            divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
            return divider
        }()
    }
    
    private lazy var contentView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
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
    
    private lazy var titleView: CCCellView = {
        let view: CCCellView = CCCellView()
        view.title = "Title"
        view.subTitle = presenter.task.title
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descView: CCCellView = {
        let view: CCCellView = CCCellView()
        view.title = "Description"
        view.subTitle = presenter.task.description
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dueDateView: CCCellView = {
        let view: CCCellView = CCCellView()
        view.title = "Duedate"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY HH:mm"
        view.subTitle = dateFormatter.string(from: presenter.task.dueDate)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var reminderView: CCCellView = {
        let view: CCCellView = CCCellView()
        view.title = "Reminder"
        view.subTitle = presenter.task.reminderText
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var deleteButton: CCButton = {
        let button: CCButton = CCButton()
        
        button.setTitle("Delete", for: .normal)
        button.setBackgroundColor(.systemRed, for: .normal)
        button.actionHandler = { [weak self] _ in
            self?.deleteButtonPressed()
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private func setupView() {
        contentView.addArrangedSubview(titleView)
        contentView.addArrangedSubview(createDividerLine())
        contentView.addArrangedSubview(descView)
        contentView.addArrangedSubview(createDividerLine())
        contentView.addArrangedSubview(dueDateView)
        contentView.addArrangedSubview(createDividerLine())
        contentView.addArrangedSubview(reminderView)
        
        scrollView.addSubview(contentView)
        scrollView.addSubview(deleteButton)
        
        fill(with: scrollView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            deleteButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CCMargin.x_large),
            deleteButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -CCMargin.x_large),
            deleteButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CCMargin.xx_large),
            deleteButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -CCMargin.xx_large),
            
            scrollView.widthAnchor.constraint(equalTo: view.availableGuide.widthAnchor)
        ])
        
        view.layoutIfNeeded()
    }
    
    private func deleteButtonPressed() {
        showWarning(title: "Are you sure want to delete?", message: "", completion: { [weak self] accepted in
            if accepted {
                self?.presenter.deleteTask()
            }
        })
    }
    
    private func showWarning(title: String, message: String, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes, delete!", style: .destructive, handler: { (action) in
            completion(true)
        }))
        
        alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: { (action) in
            completion(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension TaskDetailsViewController: TaskDetailsViewControllerProtocol {
    func refreshView() {
        titleView.subTitle = presenter.task.title
        descView.subTitle = presenter.task.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY HH:mm"
        dueDateView.subTitle = dateFormatter.string(from: presenter.task.dueDate)
        
        reminderView.subTitle = presenter.task.reminderText
    }
}
