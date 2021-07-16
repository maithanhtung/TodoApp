//
//  TaskListViewController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 13.7.2021.
//

import UIKit

// MARK: - TaskListViewControllerProtocol declaration
protocol TaskListViewControllerProtocol: BaseViewControllerProtocol {
    func refreshView()
}

// MARK: - TaskListViewController implementation
class TaskListViewController: BaseViewController {
    
    private let presenter: TaskListPresenterProtocol

    required init(presenter: TaskListPresenterProtocol) {
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
        title = "Manage your tasks"
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        navigationController?.navigationBar.barTintColor = UIColor(named: "viewBackgroundColor")
        
        setupView()
        // tell presenter fetch task list
        presenter.viewIsReady()
    }
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = CCMargin.large
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
        collectionView.register(CCCell.self, forCellWithReuseIdentifier: "CCCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: CCMargin.large, bottom: 0, right: CCMargin.xx_large + CCMargin.xx_large)
        
        return collectionView
    }()
    
    func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .systemRed
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .systemGreen
        
        view.addSubview(collectionView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.availableGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.availableGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.availableGuide.topAnchor, constant: CCMargin.large),
            collectionView.bottomAnchor.constraint(equalTo: view.availableGuide.bottomAnchor, constant: -CCMargin.large),
        ])
    }
    
    @objc func addTaskButtonPressed() {
        presenter.addTask()
    }
    
    @objc func logoutButtonPressed() {
        view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
}


// MARK: - TaskListViewController UICollectionViewDelegate
extension TaskListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItem(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CCCell", for: indexPath) as! CCCell
        
        if let item = presenter.taskItem(at: indexPath) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YY"
            
            cell.title = dateFormatter.string(from: item.dueDate)
            cell.subTitle = item.title
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath)
    }

}

// MARK: - TaskListViewControllerProtocol implementation
extension TaskListViewController: TaskListViewControllerProtocol {
    func refreshView() {
        collectionView.reloadData()
    }
}

