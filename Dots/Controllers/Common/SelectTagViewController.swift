//
//  SelectTagViewController.swift
//  Dots
//
//  Created by Sasha on 8/12/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

protocol SelectTagViewControllerDelegate: class {
    func didPick(tags: [String])
}

class SelectTagViewController: UIViewController {
    @IBOutlet var tableView: SelectTagsTableView!
    weak var delegate: SelectTagViewControllerDelegate?
    var selectedTags: [String] = []
}

extension SelectTagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseManager.shared.defaultPickers.tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectTagTableViewCell.typeName, for: indexPath) as! SelectTagTableViewCell
        
        let tag = FirebaseManager.shared.defaultPickers.tags[indexPath.row]
        
        cell.tagLbl.text = tag
        cell.isPicked = selectedTags.contains(tag)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = FirebaseManager.shared.defaultPickers.tags[indexPath.row]
        if let index = selectedTags.index(of: (tag)) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
        
        tableView.reloadData()
    }
}

extension SelectTagViewController {
    @IBAction func onCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onApply() {
        delegate?.didPick(tags: selectedTags)
        dismiss(animated: true, completion: nil)
    }
}
