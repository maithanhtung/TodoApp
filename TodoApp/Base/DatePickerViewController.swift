//
//  DatePickerViewController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 16.7.2021.
//
import UIKit
protocol DatePickerViewControllerDelegate: AnyObject {
    func didSelectDate(date: Date)
}

class DatePickerViewController: BaseViewController {
    
    weak var delegate: DatePickerViewControllerDelegate?
    var containerViewBottomConstraint: NSLayoutConstraint?
    var containerViewDefaultHeight: CGFloat = 0.0
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var datePickerView: UIDatePicker = {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.timeZone = NSTimeZone.local
        datePickerView.backgroundColor = UIColor.white
        datePickerView.datePickerMode = .dateAndTime
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return datePickerView
    }()
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        delegate?.didSelectDate(date: sender.date)
    }
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.2
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPanGesture()
        view.backgroundColor = .clear
        setupView()
        setupConstraints()
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragAction(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }

    @objc func handleDragAction(gesture: UIPanGestureRecognizer) {
        let maxContainerHeight: CGFloat = containerViewDefaultHeight - 20
        let minContainerHeight: CGFloat = containerViewDefaultHeight - 40

        let translation = gesture.translation(in: view)
        
        // Calculate new height base on dragging
        let newHeight = containerViewDefaultHeight - translation.y
        
        // Handle based on gesture state
        switch gesture.state {
        case .changed:
            // When user is dragging
            if newHeight < maxContainerHeight {
                // Keep updating the height constraint
                containerViewBottomConstraint?.constant = translation.y
                // refresh layout
                view.layoutIfNeeded()
            }
        case .ended:
            // If new height is below min, dismiss controller
            if newHeight < minContainerHeight {
                self.dismiss(animated: true)
            }
        default:
            break
        }
    }
    
    func setupView() {
        containerView.addSubview(datePickerView)
        view.addSubview(dimmedView)
        view.addSubview(containerView)
    }
    
    func setupConstraints() {
        
        if UIDevice.current.orientation.isLandscape {
            containerViewDefaultHeight = UIScreen.main.bounds.size.height * 0.6
        } else {
            containerViewDefaultHeight = UIScreen.main.bounds.size.width * 0.7
        }
        
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.availableGuide.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.availableGuide.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.availableGuide.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.availableGuide.trailingAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.availableGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.availableGuide.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: containerViewDefaultHeight),
            
            datePickerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            datePickerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            datePickerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.availableGuide.bottomAnchor, constant: 0)
        
        containerViewBottomConstraint?.isActive = true
    }
    
    // dismiss view when tap out side the calendar
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        if sender?.state == .ended {
            self.dismiss(animated: true)
        }
    }
}

