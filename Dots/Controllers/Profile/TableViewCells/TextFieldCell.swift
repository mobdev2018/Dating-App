//
//  TextFieldCell.swift
//  Dots
//
//  Created by Sasha on 8/4/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class TextFieldCell: BasicProfileCell {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerField: PickerTextField!
    @IBOutlet weak var arrowImg: UIImageView!
    var isPicker: Bool = false {
        didSet {
            if isPicker {
                arrowImg.isHidden = false
                if self.picker == nil {
                    self.picker = UIPickerView()
                    self.picker.backgroundColor = .white
                    self.picker.dataSource = self
                    self.picker.delegate = self
                }
                self.pickerField.inputView = nil
                self.pickerField.reloadInputViews()
                self.pickerField.inputView = self.picker
                self.pickerField.isHidden = false
                self.textField.isHidden = true
            } else {
                arrowImg.isHidden = true
                self.textField.inputView = nil
                self.textField.reloadInputViews()
                self.textField.inputView?.backgroundColor = .white
                self.pickerField.isHidden = true
                self.textField.isHidden = false
            }
        }
    }
    var entries: [String] = []
    var picker: UIPickerView!
    
    var toolBarLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: 40.0))
        let spaceItem1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceItem2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIButton(frame: CGRect(x: 0, y: 0, width: 45, height: 50))
        
        doneButton.titleLabel?.font = UIFont(name: "FiraSans-Bold", size: 14.0)
        doneButton.setTitleColor(.cellDoneButton, for: .normal)
        doneButton.addTarget(self, action: #selector(onPickerDoneButton), for: .touchUpInside)
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.sizeToFit()
        doneButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 0, right: 0)
        
        toolBarLabel = UILabel(frame: .zero)
        toolBarLabel.font = UIFont(name: "FiraSans-Medium", size: 20.0)
        toolBarLabel.text = "sdf"
        toolBarLabel.sizeToFit()
        let center = UIBarButtonItem(customView: toolBarLabel)
        let done = UIBarButtonItem(customView: doneButton)

        toolBar.items = [spaceItem1,center,spaceItem2, done]
        toolBar.backgroundColor = .white
        textField.inputAccessoryView = toolBar
        pickerField.inputAccessoryView = toolBar
    }
    
    @objc func onPickerDoneButton() {
        if isPicker {
            pickerField.resignFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    override func applyPosition(pos: CellPosition) {
        textField.placeholder = "Enter your \(nameFor(position: pos))..."
        pickerField.placeholder = "Pick your \(nameFor(position: pos))..."
        switch pos {
        case .gender:
            entries = FirebaseManager.shared.defaultPickers.genders
            isPicker = true
        case .age:
            entries = FirebaseManager.shared.defaultPickers.ages
            isPicker = true
        case .height:
            entries = FirebaseManager.shared.defaultPickers.heights
            isPicker = true
        case .zodiacSign:
            entries = FirebaseManager.shared.defaultPickers.zodiacSigns
            isPicker = true
        case .searchGender:
            pickerField.placeholder = "Looking for ..."
            entries = FirebaseManager.shared.defaultPickers.searchGenders
            isPicker = true
        case .familyPlans:
            entries = FirebaseManager.shared.defaultPickers.family
            isPicker = true
        case .politics:
            entries = FirebaseManager.shared.defaultPickers.politics
            isPicker = true
        case .ethnicity:
            entries = FirebaseManager.shared.defaultPickers.ethnicity
            isPicker = true
        case .religioulsBeliefs:
            entries = FirebaseManager.shared.defaultPickers.religious
            isPicker = true
        case .searchKeyword:
            textField.placeholder = "Enter Search Keyword..."
            isPicker = false
          
        case .searchPolitics:
            pickerField.placeholder = "Looking for ..."
            entries = FirebaseManager.shared.defaultPickers.politics
            isPicker = true
            
        case .searchReligious:
            pickerField.placeholder = "Looking for ..."
            entries = FirebaseManager.shared.defaultPickers.religious
            isPicker = true
            
        case .searchFamily:
            pickerField.placeholder = "Looking for ..."
            entries = FirebaseManager.shared.defaultPickers.family
            isPicker = true
            
        case .searchZodiac:
            pickerField.placeholder = "Looking for ..."
            entries = FirebaseManager.shared.defaultPickers.zodiacSigns
            isPicker = true
        default:
            isPicker = false
        }
    }
    
    func applyValue(value: String?) {
        if isPicker {
            pickerField.text = value
            
            if positon == .height {
                if let v = value {
                    let i = Int(v)!
                    pickerField.text = cmToFeet(cm: i)
                }
            }
            
            guard let strictValue = value else {
                 return
            }
            if let index = entries.index(of: strictValue) {
                if index < picker.numberOfRows(inComponent: 0) {
                    picker.selectRow(index, inComponent: 0, animated: false)
                }
            }
        } else {
            textField.text = value
        }
        
    }
}

// MARK:- UITextFieldDelegate
extension TextFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text! as NSString
        let textString = text.replacingCharacters(in: range, with: string) as String
        delegate?.didChange(value: textString, position: positon)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        textField.resignFirstResponder()
        return true
    }
}

// MARK:- UITextFieldDelegate
extension TextFieldCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return entries.count
    }
    
    /*func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return entries[row]
    }*/
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "FiraSans-Light.otf", size: 20)
        
        // where data is an Array of String
        
        if positon == .height {
            let i = Int(entries[row])!
            label.text = cmToFeet(cm: i)
        } else {
            label.text = entries[row]
        }
        
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didChange(value: entries[row], position: positon)
        
        if positon == .height {
            let i = Int(entries[row])!
            pickerField.text = cmToFeet(cm: i)
        } else {
            pickerField.text = entries[row]
        }
    }
}
