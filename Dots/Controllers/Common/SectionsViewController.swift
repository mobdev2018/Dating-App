//
//  SectionsViewController.swift
//  Dots
//
//  Created by Sasha on 8/24/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

//
let textCellHeight = CGFloat(70.0)
let photosCellHeight = CGFloat(112.0)
let headerViewHeight = CGFloat(66.0)
let interestedInHeight = CGFloat(46.0)

class SectionsViewController: KeyboardViewController {
    @IBOutlet weak var tableView: SetUpProfileTableView!
    
    var sections: [Section] = []
    var tagsController: TagsController! = TagsController()
    
    var musicController: TagsController! = TagsController()
    var moviesController: TagsController! = TagsController()
    var tvShowsController: TagsController! = TagsController()
    var booksController: TagsController! = TagsController()
    var sportsTeamsController: TagsController! = TagsController()
    
    var tagsHeight: CGFloat = textCellHeight
    
    
    var moviesHeight: CGFloat = textCellHeight
    var tvShowsHeight: CGFloat = textCellHeight
    var sportsTeamsHeight: CGFloat = textCellHeight
    var booksHeight: CGFloat = textCellHeight
    var musicHeight: CGFloat = textCellHeight
}

// MARK:- Table view methods
extension SectionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].expanded ? sections[section].rows.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        assertionFailure("Override \"cellForRowAt\" method")
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let s = sections[section].title.characters.count
        return s > 0 ? headerViewHeight : CGFloat(0.0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.typeName) as! HeaderView
        headerView.nameLbl.setHeaderCellTitle(sections[section].title)
        headerView.tag = section
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        assertionFailure("Override \"heightForRowAt\" method")
        return 0.0
    }
}

// MARK:- HeaderViewDelegate
extension SectionsViewController: HeaderViewDelegate {
    func onHeader(_ index: Int) {
        sections[index].expanded = !sections[index].expanded
        
        let indexSet = NSIndexSet(index: index)
        tableView.reloadSections(indexSet as IndexSet, with: .automatic)
        
        if sections[index].expanded {
            tableView.scrollToRow(at: NSIndexPath(item: 0, section: index) as IndexPath, at: .top, animated: true)
        }
    }
}

// MARK:- Public 
extension SectionsViewController {
    func presentTagsController(with tags: [String], delegate: SelectTagViewControllerDelegate) {
        let tagsController = UIStoryboard.getController(SelectTagViewController.self) as! SelectTagViewController
        
        tagsController.selectedTags = tags
        tagsController.delegate = delegate
        tagsController.modalPresentationStyle = .overCurrentContext
        tagsController.modalTransitionStyle = .crossDissolve
        
        DispatchQueue.main.async {
            if let tabBarController = self.tabBarController {
                tabBarController.present(tagsController, animated: true, completion: nil)
            } else {
                self.present(tagsController, animated: true, completion: nil)
            }
        }
    }
}
