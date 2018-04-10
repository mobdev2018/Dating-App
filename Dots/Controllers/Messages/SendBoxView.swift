//
//  SendBoxView.swift
//  Dots
//
//  Created by Sasha on 9/27/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 35);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

protocol SendBoxViewDelegate: class {
    func didSendText(text: String)
}

class SendBoxView: UIView {
    weak var delegate: SendBoxViewDelegate?
    @IBOutlet var txtField: TextField! {
        didSet{
            txtField.layer.cornerRadius = 17.0
            txtField.layer.borderColor = UIColor.lightGray.cgColor
            txtField.layer.borderWidth = 1.0
        }
    }
    @IBOutlet var sendBtn: UIButton!
}

// MARK:- Actions
extension SendBoxView {
    @IBAction func onSend() {
        delegate?.didSendText(text: txtField.text!)
        txtField.text = ""
        updateState()
    }
}


// MARK:- Internal
extension SendBoxView {
    func updateState() {
        sendBtn.isEnabled = !txtField.text!.isEmpty
        
        if sendBtn.isEnabled {
            sendBtn.setTitleColor( .blue, for: .normal)
        } else {
            sendBtn.setTitleColor( .gray, for: .normal)
        }
    }
}

// MARK:- UITextFieldDelegate methods
extension SendBoxView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        sendBtn.isEnabled = !text.isEmpty
        
        if sendBtn.isEnabled {
            sendBtn.setTitleColor( .blue, for: .normal)
        } else {
            sendBtn.setTitleColor( .gray, for: .normal)
        }
        // Return true so the text field will be changed
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onSend()
        
        return false
    }
}
