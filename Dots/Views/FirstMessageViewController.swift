//
//  FirstMessageViewController.swift
//  Dots
//
//  Created by Sasha on 11/23/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class FirstMessageViewController: KeyboardViewController {
    @IBOutlet var textView: UITextView!
    weak var delegate: ProfileViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.botConstant = 80.0
        
        textView.layer.borderColor = UIColor.selectedMatchColor.cgColor
        textView.layer.borderWidth = 2.0
        textView.layer.cornerRadius = 6.0
        textView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
}


// MARK:- Actions
extension FirstMessageViewController {
    @IBAction func onDone() {
        if textView.text.count > 0 {
            delegate?.didPressSend(message: textView.text)
        }
        
    }
    
    @IBAction func onCancel() {
        delegate?.didPressCancel()
    }
}
