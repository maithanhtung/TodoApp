//
//  BaseViewController.swift
//  TodoApp
//
//  Created by Mai Thanh Tung on 16.7.2021.
//

import UIKit

protocol BaseViewControllerProtocol: NSObject {
    func showLoadingView()
    func dissmissLoadingView()
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    
    let loadingView: LoadingView = LoadingView()
    
    func presentLoading() {
        fill(with: loadingView)
    }
    
    func dismissLoading() {
        loadingView.removeFromSuperview()
    }
    
    func fill(with subView: UIView) {
        view.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: view.availableGuide.leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: view.availableGuide.trailingAnchor),
            subView.topAnchor.constraint(equalTo: view.availableGuide.topAnchor),
            subView.bottomAnchor.constraint(equalTo: view.availableGuide.bottomAnchor)
        ])
    }
    
    func showLoadingView() {
        presentLoading()
    }
    
    func dissmissLoadingView() {
        dismissLoading()
    }
}
