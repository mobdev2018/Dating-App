//
//  SetUpTagsViewController.swift
//  Dots
//
//  Created by Sasha on 9/26/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class SetUpTagsViewController: BaseViewController {
    @IBOutlet weak var collectionView: TagsCollectionView!
    @IBOutlet weak var nextButton: UIButton!
    weak var delegate: SetUpProfileViewController?
    
    weak var searchDelegate: SearchViewController?
    
    var minimumCount: Int = 3
    
    var selectedTags: [String] = []
    var allTags: [String] = [ "nature lover", "pet friendly", "sports fanatic","haute culture", "video gamer", "gambler" ,"otaku", "foodie","early bird","night owl","musician","nerd","book worm","architect","logician","commander","debater","advocate","mediator","protagonist","campaigner","responsible","defender","executive","social butterfly","virtuoso","adventurer","entrepreneur","entertainer","mechanic","nurturer","artist","idealist","scientist","thinker","caregiver","visionary","creative","philosopher","sensitive","compassionate","ambitious","traditional","comedian","leader","traveler","obnoxious","arrogant","impatient","sarcastic","nihilist","hustler","gangster"]
    
    var isEditProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditProfile {
            nextButton.setTitle("Save", for: .normal)
        }
        topTitle = "SELECT TAGS"
        showTopSeparator = true
    }
}

// MARK:- Collection View
extension SetUpTagsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionCell.typeName, for: indexPath) as! TagCollectionCell
        
        let tag = allTags[indexPath.row]
        cell.nameLbl.text = tag
        
        cell.isClickable = true
        cell.isClicked = selectedTags.contains(tag)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = allTags[indexPath.row]
        
        if let index = selectedTags.index(of: tag) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = allTags[indexPath.row]
        return getLabelSize(16, text: tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    fileprivate func getLabelSize(_ fontSize: Int, text: String) -> CGSize {
        let label: UILabel = UILabel(frame: CGRect.zero)
        label.numberOfLines = 1
        label.font = UIFont(name: "FiraSans-Regular.otf", size: CGFloat(fontSize))
        label.text = text
        label.sizeThatFits(CGSize(width: Int.max, height: fontSize))
        
        let height = label.intrinsicContentSize.height + 10
        let width = label.intrinsicContentSize.width + 20
        
        return CGSize(width: width, height: height)
    }
}

// MARK:- Actions
extension SetUpTagsViewController {
    @IBAction func onNext() {
        if selectedTags.count < minimumCount {
            if minimumCount == 1 {
                let alert = UIAlertController(title: "Oops", message: "Please select at least one tag, that describe you", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Oops", message: "Please select at least \(minimumCount) tags, that describe you", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } else {
            if isEditProfile {
                delegate?.profile.tags = selectedTags
                delegate?.reloadTags()
                
                searchDelegate?.filter.tags = selectedTags
                
                navigationController?.popViewController(animated: true)
            } else {
                profileJson["tags"] = selectedTags
                performSegue(withIdentifier: "SetUpAbout", sender: nil)
            }
            
        }
    }
}
