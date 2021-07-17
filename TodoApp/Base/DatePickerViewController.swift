//
//  PickerViewController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 16.7.2021.
//
import UIKit

@objc enum PickerViewControllerStyle: Int, CaseIterable {
    case datePicker = 0,
         selectionPicker
}

protocol PickerViewControllerDelegate: AnyObject {
    func didSelectDate(date: Date)
    
    func didSelectCell(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    
    func rowTitlePickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
}

class PickerViewController: BaseViewController {
    
    weak var delegate: PickerViewControllerDelegate?
    var containerViewBottomConstraint: NSLayoutConstraint?
    var containerViewDefaultHeight: CGFloat = 0.0
    var style: PickerViewControllerStyle
    var pickerViewDataSource: UIPickerViewDataSource?
    
    required init(style: PickerViewControllerStyle) {
        self.style = style
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        datePickerView.setValue(UIColor.black, forKeyPath: "textColor")
        datePickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return datePickerView
    }()
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        // set new date that start with 0 sec
        let calendar: Calendar = Calendar.current
        var dateComponents: DateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: sender.date)
        dateComponents.setValue(0, for: .second)
        
        delegate?.didSelectDate(date: calendar.date(from: dateComponents) ?? sender.date)
    }
    
    private lazy var selectionView: UIPickerView = {
        let pickerView: UIPickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = pickerViewDataSource
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.setValue(UIColor.black, forKeyPath: "textColor")
        
        return pickerView
    }()
    
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
        if style == .datePicker {
            containerView.addSubview(datePickerView)
        } else {
            containerView.addSubview(selectionView)
        }
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        
        setupConstraints()
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
            containerView.heightAnchor.constraint(equalToConstant: containerViewDefaultHeight)
        ])
        
        if style == .datePicker {
            NSLayoutConstraint.activate([
                datePickerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                datePickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                datePickerView.topAnchor.constraint(equalTo: containerView.topAnchor),
                datePickerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                selectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                selectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                selectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
                selectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            ])
        }
        
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

// MARK: - UIPickerViewDelegate implementation
extension PickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectCell(pickerView, didSelectRow: row, inComponent: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        delegate?.rowTitlePickerView(pickerView, titleForRow: row, forComponent: component)
    }
}

