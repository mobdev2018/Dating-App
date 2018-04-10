//
//  SearchViewController.swift
//  Dots
//
//  Created by Sasha on 8/23/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

var filterJSON: [String: Any] = [:]

/*result["minAge"] = minAge
 result["maxAge"] = maxAge
 
 // Personal
 result["minHeight"] = minHeight
 result["maxHeight"] = maxHeight*/

class SearchViewController: SectionsViewController {
    var filter: Filter! = Filter(JSON: [:])
    @IBOutlet weak var searchView: UIView! {
        didSet {
            // searchView.layer.shadowOffset = CGSize(width: 0, height: 0)
            // searchView.layer.shadowPath = CGPath(rect: searchView.bounds, transform: nil)
            // searchView.layer.shadowRadius = 3.0
            // searchView.layer.shadowOpacity = 0.2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetFilter()
        
        topTitle = "SEARCH"
        
        //, , ,
        
        sections.append(Section([Row(.searchKeyword, type: .text),
                                 Row(.interestedIn, type: .interestedIn),
                                 Row(.searchGender, type: .text),
                                 Row(.searchDistance, type: .slider),
                                 Row(.searchAge, type: .rangeSlider),
                                 Row(.searchTags, type: .interestedIn)],
                                expanded: true))
        
        sections.append(Section([Row(.searchHeight, type: .rangeSlider),
                                 Row(.searchFamily, type: .text)],
                                title: "PERSONAL",
                                expanded: false))
        
        sections.append(Section([Row(.searchPolitics, type: .text),
                                 Row(.searchReligious, type: .text),
                                 Row(.searchZodiac, type: .text)],
                                title: "AFFILIATIONS",
                                expanded: false))
        
        showTopSeparator = true
        shouldShowMenuBtn = true
        //shouldShowSearchBtn = true
    }
    
    func resetFilter() {
        filterJSON = [:]
        
        filterJSON["minAge"] = Int(FirebaseManager.shared.defaultPickers.ages.first!)
        filterJSON["maxAge"] = Int(FirebaseManager.shared.defaultPickers.ages.last!)
        
        filterJSON["minHeight"] = Int(FirebaseManager.shared.defaultPickers.heights.first!)
        filterJSON["maxHeight"] = Int(FirebaseManager.shared.defaultPickers.heights.last!)
        
        filter = Filter(JSON: filterJSON)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.view.layoutIfNeeded()
            self.view.setNeedsDisplay()
        }
    }
}

// MARK:- Table view delegate
extension SearchViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = sections[indexPath.section].rows[indexPath.row].position
        let type =  sections[indexPath.section].rows[indexPath.row].cellType
        
        switch type {
        case .photos:
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosCell.typeName, for: indexPath) as! PhotosCell
            /*cell.collectionView.delegate = self
             cell.collectionView.dataSource = self
             cell.delegate = self
             cell.collectionView.reloadData()*/
            return cell
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.typeName, for: indexPath) as! TextFieldCell
            cell.nameLbl.text = String(indexPath.row)
            
            cell.nameLbl.setAttrTitle(nameFor(position: position).uppercased())
            cell.toolBarLabel.text = nameFor(position: position).capitalized
            cell.toolBarLabel.sizeToFit()
            cell.positon = position
            cell.applyValue(value: filter.valueFor(position))
            cell.delegate = self
            return cell
        case .tags:
            let cell = tableView.dequeueReusableCell(withIdentifier: TagsCell.typeName, for: indexPath) as! TagsCell
            
            cell.isEmpty = filter.isTagsEmpty()
            cell.collectionView.delegate = tagsController
            cell.collectionView.dataSource = tagsController
            
            
            if !cell.isEmpty {
                cell.collectionView.reloadData()
                if self.tagsHeight != cell.collectionView.collectionViewLayout.collectionViewContentSize.height {
                    self.tagsHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
                }
            } else {
                tagsHeight = textCellHeight
            }
            
            return cell
        case .slider:
            let cell = tableView.dequeueReusableCell(withIdentifier: SliderViewCell.typeName, for: indexPath) as! SliderViewCell
            cell.nameLbl.setAttrTitle(nameFor(position: position).uppercased())
            return cell
        case .interestedIn:
            let cell = tableView.dequeueReusableCell(withIdentifier: InterestedInCell.typeName, for: indexPath) as! InterestedInCell
            if position == .searchTags {
                cell.nameLbl.setAttrTitle("TAGS")
                if !filter.selectedTags().isEmpty {
                    cell.nameLbl.textColor = .cellDoneButton
                }
            } else {
                cell.nameLbl.setAttrTitle("INTERESTED IN")
                
                if let interestedIn = filter.interestedIn {
                    if !interestedIn.isEmpty {
                        cell.nameLbl.textColor = .cellDoneButton
                    }
                }
            }
            
            return cell
        case .rangeSlider:
            let cell = tableView.dequeueReusableCell(withIdentifier: RangeSliderCell.typeName, for: indexPath) as! RangeSliderCell
            
            cell.positon = position
            cell.nameLbl.setAttrTitle(nameFor(position: position).uppercased())
            cell.rangeSlider.minimumValue = filter.minValueFor(position)
            cell.rangeSlider.maximumValue = filter.maxValueFor(position)
            cell.rangeSlider.lowerValue = filter.sliderLowerValue(position)
            cell.rangeSlider.upperValue = filter.sliderUpperValue(position)
            cell.valueLbl.text = filter.valueFor(position)!
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch sections[indexPath.section].rows[indexPath.row].cellType {
        case .text:
            return textCellHeight
        case .photos:
            return photosCellHeight
        case .tags:
            return tagsHeight
        case .slider:
            return textCellHeight
        case .rangeSlider:
            return textCellHeight
        case .interestedIn:
            return interestedInHeight
        default:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if indexPath.row == 0 && indexPath.section == 0 {
            presentTagsController(with: filter.selectedTags(), delegate: self)
        }*/
        
        let position = sections[indexPath.section].rows[indexPath.row].position
        
        if position == .interestedIn {
            let t = UIStoryboard.getController(SetUpInterestedInViewController.self) as! SetUpInterestedInViewController
            t.isEditProfile = true
            t.isSearch = true
            t.searchDelegate = self
            if let s = filter.interestedIn {
                t.selectedState = s
            }
            self.navigationController?.pushViewController(t, animated: true)
        }
        
        if position == .searchTags {
            let t = UIStoryboard.getController(SetUpTagsViewController.self) as! SetUpTagsViewController
            t.isEditProfile = true
            t.searchDelegate = self
            t.selectedTags = filter.selectedTags()
            t.minimumCount = 1
            self.navigationController?.pushViewController(t, animated: true)
        }
    }
}

// MARK:- SelectTagViewControllerDelegate
extension SearchViewController: SelectTagViewControllerDelegate {
    func didPick(tags: [String]) {
        tagsController.selectedTags = tags
        filter.tags = tags
        tableView.reloadData()
    }
}

// MARK:- Basic Profile Cell Delegate
extension SearchViewController: BasicProfileCellDelegate {
    func minMaxFor(_ position: CellPosition) -> String {
        return filter.valueFor(position)!
    }
    
    func didChange(value: Any, position: CellPosition) {
        filter.apply(value, position: position)
    }
    
    func didChange(minValue: Any, maxValue: Any, position: CellPosition) {
        filter.apply(min: minValue, max: maxValue, position: position)
        //self.tableView.reloadData()
    }
}

// MARK:- Actions
extension SearchViewController {
    @IBAction func onSearchBtn() {
        self.showLoader()
        
        
        FirebaseManager.shared.downloadAds { (ads) in
            FirebaseManager.shared.downloadUsers { (profiles) in
                if let resultProfiles = profiles {
                    var filteredArray = resultProfiles.filter({ (profile) -> Bool in
                        return profile.isValid(for: self.filter) && !ProfileManager.shared.profile.likes.contains(profile.userID)
                    })
                    
                    var res: [Profile] = []
                    
                    if filteredArray.count > 20 {
                        for i in 0..<20 {
                            res.append(filteredArray[i])
                        }
                    } else {
                        res = filteredArray
                    }
                    
                    print("")
                    self.hideLoader()
                    let searchResultsVC = UIStoryboard.getController(SearchResultsViewController.self) as! SearchResultsViewController
                    searchResultsVC.results = createSearchResults(from: res)
                    
                    if var resAds = ads {
                        if resAds.count > 0 {
                            resAds.shuffle()
                            searchResultsVC.results.append(SearchResult(ad: resAds.first!, type: .Ad))
                        }
                    }
                    
                    searchResultsVC.results.shuffle()
                    
                    self.navigationController?.pushViewController(searchResultsVC, animated: true)
                } else {
                    self.hideLoader()
                    print("")
                }
            }
        }
        
        //filter.interestedIn = ProfileManager.shared.profile.interestedIn
        
        //guard let g = filter.gender {
            
        //}
        
    }
    
    @IBAction func onClear() {
        resetFilter()
        self.view.resignFirstResponder()
        tableView.reloadData()
    }
}
