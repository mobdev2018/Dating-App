//
//  BaseViewController.swift
//  Dots
//
//  Created by Sasha on 8/3/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import Foundation
import MBProgressHUD

class BaseViewController: UIViewController {
    var topTitle: String = "" {
        didSet {
            let label = UILabel(frame: .zero)
            label.setNavigationTitle(topTitle)
            label.sizeToFit()
            navigationItem.titleView = label
        }
    }
    
    lazy var topSeparator: UIView = { [weak self] in
        let topSeparatorView = UIView(frame: .zero)
        topSeparatorView.backgroundColor = .navBarSeparatorColor
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        self?.view.addSubview(topSeparatorView)
        
        if let v = self?.view {
            let xPos = topSeparatorView.centerXAnchor.constraint(equalTo: v.centerXAnchor)
            let top = topSeparatorView.topAnchor.constraint(equalTo: v.topAnchor, constant: 0.0)
            let width = topSeparatorView.widthAnchor.constraint(equalTo: v.widthAnchor, multiplier: 0.9)
            let height = topSeparatorView.heightAnchor.constraint(equalToConstant: 1.0)
            NSLayoutConstraint.activate([xPos,top,width,height])
        }
        return topSeparatorView
    }()
    
    // set up bools
    var showTopSeparator: Bool = true {
        didSet {
            if showTopSeparator {
                topSeparator.isUserInteractionEnabled = false
            } else {
                topSeparator.removeFromSuperview()
            }
        }
    }
    var shouldShowMenuBtn: Bool = true {
        didSet {
            if shouldShowMenuBtn {
                addMenuBarBtn()
            }
        }
    }
    var shouldShowSearchBtn: Bool = true {
        didSet {
            if shouldShowSearchBtn {
                addSearchBtn()
            }
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        navigationController?.navigationBar.setBackgroundImage(UIImage(named:"header-dots")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.layoutIfNeeded()
    }
    
    func addMenuBarBtn() {
        let backButton = UIBarButtonItem(image: UIImage(named: "d-small")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(BaseViewController.onMenu))
        navigationItem.leftBarButtonItem = backButton
    }
    
    func addSearchBtn() {
        let backButton = UIBarButtonItem(image: UIImage(named: "tabbar-search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(BaseViewController.onSearch))
        navigationItem.rightBarButtonItem = backButton
    }
    
    func addBackButton() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(onBackButton(_:)))
        self.navigationItem.backBarButtonItem = backButton
    }
    
    func showLoader() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideLoader() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}

// MARK:- Actions
extension BaseViewController {
    @IBAction func onBackButton(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onMenu() {
        let menuContr = UIStoryboard.getController(MenuViewController.self) as! MenuViewController
        menuContr.modalPresentationStyle = .overCurrentContext
        menuContr.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.tabBarController?.present(menuContr, animated: true, completion: nil)
        }
    }
    
    @IBAction func onSearch() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 2
        }
    }
}
