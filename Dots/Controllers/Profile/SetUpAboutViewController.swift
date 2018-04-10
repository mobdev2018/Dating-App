//
//  SetUpAboutViewController.swift
//  Dots
//
//  Created by Sasha on 10/13/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class SetUpAboutViewController: KeyboardViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textView: UITextView!

    weak var delegate: SetUpProfileViewController?
    
    var about: String = ""
    var isEditProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = about
        
        textView.layer.borderColor = UIColor.selectedMatchColor.cgColor
        textView.layer.borderWidth = 2.0
        textView.layer.cornerRadius = 6.0
        textView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
        
        if isEditProfile {
            nextButton.setTitle("Save", for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    @IBAction func onNext() {
        if textView.text.characters.count == 0 {
            let alert = UIAlertController(title: "Oops", message: "Please describe yourself a bit", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            if isEditProfile {
                delegate?.profile.about = textView.text
                navigationController?.popViewController(animated: true)
            } else {
                profileJson["about"] = textView.text
                performSegue(withIdentifier: "CompleteSetUp", sender: nil)
            }
            
        }
    }
}

extension SetUpAboutViewController: UITextViewDelegate {
    
}
