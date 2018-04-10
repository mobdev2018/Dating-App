//
//  SetUpProfileViewController.swift
//  Dots
//
//  Created by Sasha on 8/4/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit
import SDWebImage

var profileJson: [String: Any] = [:]//["name" : "angelina", "age": 24, "education": "University of NY"]

class SetUpProfileViewController: SectionsViewController {
    // Outlets
    @IBOutlet var barDoneBtn: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIButton!
    // Data
    var profile: Profile = Profile(JSON: profileJson)
    var profilePhotos: [ProfilePhoto] = []
    
    var isEditProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditProfile {
            profile = ProfileManager.shared.profile
            doneButton.setTitle("Save", for: .normal)
            topTitle = "EDIT PROFILE"
        } else {
            topTitle = "COMPLETE PROFILE"
        }
        
        shouldShowMenuBtn = false
        shouldShowSearchBtn = false
        
        navigationItem.backBarButtonItem?.title = ""
        
        profilePhotos = profile.getPhotos()
        
        sections = []
        
        if isEditProfile {
            sections.append(Section([Row(.photos, type: .photos),
                                     Row(.name, type: .text),
                                     Row(.gender, type: .text),
                                     Row(.age, type: .text),
                                     Row(.height, type: .text),
                                     Row(.work, type: .text),
                                     Row(.education, type: .text),
                                     Row(.familyPlans, type: .text),
                                     Row(.about, type: .interestedIn),
                                     Row(.interestedIn, type: .interestedIn)],
                                    expanded: true))
        } else {
            sections.append(Section([Row(.photos, type: .photos),
                                     Row(.name, type: .text),
                                     Row(.gender, type: .text),
                                     Row(.age, type: .text),
                                     Row(.height, type: .text),
                                     Row(.work, type: .text),
                                     Row(.education, type: .text),
                                     Row(.familyPlans, type: .text)],
                                    expanded: true))
        }
        
        
        sections.append(Section([Row(.politics, type: .text),
                                 Row(.ethnicity, type: .text),
                                 Row(.religioulsBeliefs, type: .text),
                                 Row(.zodiacSign, type: .text)],
                                title: "AFFILIATIONS"))
        
        
        if isEditProfile {
            sections.append(Section([Row(.tags, type: .profileTags)], title: "TAGS"))
        }
        
        var res: [Row] = []
        
        if let music = profile.music {
            res.append(Row(.music, type: .tags))
            musicController.selectedTags = music
        }
        
        if let movies = profile.movies {
            res.append(Row(.movies, type: .tags))
            moviesController.selectedTags = movies
        }
        
        if let tvShows = profile.tvShows {
            res.append(Row(.tvShows, type: .tags))
            tvShowsController.selectedTags = tvShows
        }
        
        if let sportsTeams = profile.sportsTeams {
            res.append(Row(.sportsTeams, type: .tags))
            sportsTeamsController.selectedTags = sportsTeams
        }
        
        if let books = profile.books {
            res.append(Row(.books, type: .tags))
            booksController.selectedTags = books
        }
        
        if res.count > 0 {
            sections.append(Section(res, title: "INTERESTS"))
        }
        
        tagsController.selectedTags = profile.selectedTags()
        
        // init sections
        
        // Load data
        loadDefaults()
    }
    
    func loadDefaults() {
        /*showLoader()
         FirebaseManager.shared.loadDefaultArrays { (success) in
         self.hideLoader()
         self.tagsController.allTags = FirebaseManager.shared.defaultPickers.tags
         self.tagsController.selectedTags = self.profile.selectedTags()
         
         self.tableView.reloadData()
         }*/
    }
    
    func reloadTags() {
        tagsController.selectedTags = profile.selectedTags()
        tableView.reloadData()
    }
}

// MARK:- Actions
extension SetUpProfileViewController {
    @IBAction func onDone() {
        let (isValid, message) = profile.isValid()
        if isValid {
            if profilePhotos.count == 0 {
                let alert = UIAlertController(title: "Oops", message: "Please add at least 1 photo", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            } else {
                self.showLoader()
                self.uploadPhotos({
                    
                })
            }
            
        } else {
            let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func uploadPhotos(_ completion:(() -> Void)?) {
        let filteredPhotos = self.profilePhotos.filter({"" == $0.path || $0.path == nil })
        
        if (filteredPhotos.count == 0) {
            profile.photos = (profilePhotos.map({$0.path})) as? [String]
            uploadProfile()
            return
        }
        
        var recipePhoto = filteredPhotos.first
        
        guard let imageData = UIImageJPEGRepresentation((recipePhoto?.image)!, 1.0) as NSData? else {
            self.uploadPhotos(nil)
            return
        }
        
        var data: Data!
        if imageData.length < 300 {
            data = UIImageJPEGRepresentation((recipePhoto?.image)!, 1.0)
        } else if imageData.length < 1000 {
            data = UIImageJPEGRepresentation((recipePhoto?.image)!, 0.3)
        } else {
            data = UIImageJPEGRepresentation((recipePhoto?.image)!, 0.1)
        }
        
        var dateString = Date().description
        dateString = dateString.replacingOccurrences(of: " ", with: "_")
        
        var prefix = ""
        
        if let imagePrefix = FirebaseManager.shared.imagePrefix() {
            prefix = imagePrefix
        }
        
        let fileName = prefix + "/" + dateString
        FirebaseManager.shared.uploadPhoto(data: data, fileName: fileName) {(path, error) in
            if error == nil {
                for i in 0..<self.profilePhotos.count {
                    let l = self.profilePhotos[i]
                    if l.path == "" || l.path == nil {
                        self.profilePhotos[i].path = path
                        break
                    }
                }
                self.uploadPhotos(nil)
            } else {
                print("couldnt upload new image")
            }
        }
    }
    
    private func uploadProfile() {
        FirebaseManager.shared.update(profile: profile)
        self.hideLoader()
        
        ProfileManager.shared.profile = profile
        if isEditProfile {
            if let s = self.navigationController?.viewControllers.first as? ProfileViewController {
                s.profile = profile
                s.reloadData()
            }
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            NavigationCoordinator.presentMainTabBar()
        }
    }
}

// MARK:- Table View DataSource, Table View Delegate
extension SetUpProfileViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let position = sections[indexPath.section].rows[indexPath.row].position
        let type =  sections[indexPath.section].rows[indexPath.row].cellType
        
        switch type {
        case .photos:
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosCell.typeName, for: indexPath) as! PhotosCell
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            cell.delegate = self
            cell.collectionView.reloadData()
            return cell
        case .profileTags:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTagsCell.typeName, for: indexPath) as! ProfileTagsCell
            cell.isEmpty = false
            cell.isEmpty = profile.isTagsEmpty()
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
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.typeName, for: indexPath) as! TextFieldCell
            cell.nameLbl.text = String(indexPath.row)
            cell.nameLbl.setAttrTitle(nameFor(position: position).uppercased())
            cell.toolBarLabel.text = nameFor(position: position).capitalized
            cell.toolBarLabel.sizeToFit()
            cell.positon = position
            cell.applyValue(value: profile.valueFor(position))
            cell.delegate = self
            
            if isEditProfile && position == .name {
                cell.textField.isUserInteractionEnabled = false
            } else {
                cell.textField.isUserInteractionEnabled = true
            }
            
            return cell
        case .interestedIn:
            let cell = tableView.dequeueReusableCell(withIdentifier: InterestedInCell.typeName, for: indexPath) as! InterestedInCell
            cell.nameLbl.setAttrTitle(nameFor(position: position).uppercased())
            
            return cell
        case .tags:
            let cell = tableView.dequeueReusableCell(withIdentifier: TagsCell.typeName, for: indexPath) as! TagsCell
            cell.isEmpty = false
            cell.nameLbl.isHidden = false
            switch position {
            case .music:
                cell.collectionView.delegate = self.musicController
                cell.collectionView.dataSource = self.musicController
                
            case .movies:
                cell.collectionView.delegate = self.moviesController
                cell.collectionView.dataSource = self.moviesController
                
            case .tvShows:
                cell.collectionView.delegate = self.tvShowsController
                cell.collectionView.dataSource = self.tvShowsController
                
            case .sportsTeams:
                cell.collectionView.delegate = self.sportsTeamsController
                cell.collectionView.dataSource = self.sportsTeamsController
                
            case .books:
                cell.collectionView.delegate = self.booksController
                cell.collectionView.dataSource = self.booksController
            default:
                cell.nameLbl.isHidden = true
                cell.isEmpty = profile.isTagsEmpty()
                cell.collectionView.delegate = tagsController
                cell.collectionView.dataSource = tagsController
            }

            if !cell.isEmpty {
                cell.collectionView.reloadData()
                let tagsH = CGFloat(14.0)
                
                switch position {
                case .music:
                    cell.nameLbl.setAttrTitle("MUSIC")
                    if self.musicHeight != cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH {
                        self.musicHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH
                    }
                case .movies:
                    cell.nameLbl.setAttrTitle("MOVIES")
                    if self.moviesHeight != cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH {
                        self.moviesHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH
                    }
                case .tvShows:
                    cell.nameLbl.setAttrTitle("TV SHOWS")
                    if self.tvShowsHeight != cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH {
                        self.tvShowsHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH
                    }
                case .sportsTeams:
                    cell.nameLbl.setAttrTitle("SPORTS TEAMS")
                    if self.sportsTeamsHeight != cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH {
                        self.sportsTeamsHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH
                    }
                case .books:
                    cell.nameLbl.setAttrTitle("BOOKS")
                    if self.booksHeight != cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH {
                        self.booksHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height + tagsH
                    }
                default:
                    if self.tagsHeight != cell.collectionView.collectionViewLayout.collectionViewContentSize.height {
                        self.tagsHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
                    }
                }
            } else {
                tagsHeight = textCellHeight
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let position = sections[indexPath.section].rows[indexPath.row].position
        let type =  sections[indexPath.section].rows[indexPath.row].cellType
        
        if type == .profileTags {
            return tagsHeight
        }
        
        switch sections[indexPath.section].rows[indexPath.row].cellType {
        case .text:
            return textCellHeight
        case .photos:
            return photosCellHeight
        case .tags:
            switch position {
            case .music:
                return musicHeight
            case .movies:
                return moviesHeight
            case .tvShows:
                return tvShowsHeight
            case .sportsTeams:
                return sportsTeamsHeight
            case .books:
                return booksHeight
            default:
                return tagsHeight
            }
        case .interestedIn:
            return interestedInHeight
        default:
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let position = sections[indexPath.section].rows[indexPath.row].position
        let type = sections[indexPath.section].rows[indexPath.row].cellType
        if type == .profileTags {
            //presentTagsController(with: profile.selectedTags(), delegate: self)
            let t = UIStoryboard.getController(SetUpTagsViewController.self) as! SetUpTagsViewController
            t.isEditProfile = true
            t.delegate = self
            t.selectedTags = profile.selectedTags()
            self.navigationController?.pushViewController(t, animated: true)
        }
        
        if position == .interestedIn {
            let t = UIStoryboard.getController(SetUpInterestedInViewController.self) as! SetUpInterestedInViewController
            t.isEditProfile = true
            t.delegate = self
            if let s = profile.interestedIn {
                t.selectedState = s
            }
            self.navigationController?.pushViewController(t, animated: true)
        }
        
        if position == .about {
            let t = UIStoryboard.getController(SetUpAboutViewController.self) as! SetUpAboutViewController
            t.isEditProfile = true
            t.delegate = self
            if let s = profile.about {
                t.about = s
            }
            self.navigationController?.pushViewController(t, animated: true)
        }
        /*if indexPath.item == 0 && indexPath.section == 4 {
         presentTagsController(with: profile.selectedTags(), delegate: self)
         }*/
    }
}

// MARK:- SelectTagViewControllerDelegate
extension SetUpProfileViewController: SelectTagViewControllerDelegate {
    func didPick(tags: [String]) {
        tagsController.selectedTags = tags
        profile.tags = tags
        tableView.reloadData()
    }
}


// MARK:- Basic Profile Cell Delegate
extension SetUpProfileViewController: BasicProfileCellDelegate {
    func didChange(value: Any, position: CellPosition) {
        profile.apply(value, position: position)
    }
    func didChange(minValue: Any, maxValue: Any, position: CellPosition) {
        
    }
    func minMaxFor(_ position: CellPosition) -> String { return ""}
}

// MARK:- AddPhotoCollectionCellDelegate
extension SetUpProfileViewController: AddPhotoCollectionCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func didPressAddNewPhoto() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.presentCameraSource(.camera)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.presentCameraSource(.photoLibrary)
        }))
        actionSheet.view.tintColor = .cellDoneButton
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentCameraSource(_ source: UIImagePickerControllerSourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = source
            present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePhotos.append(ProfilePhoto(image: chosenImage))
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- PhotoCollectionCellDelegate 
extension SetUpProfileViewController: PhotoCollectionCellDelegate {
    func didPressDeletePhoto(at index: Int) {
        profilePhotos.remove(at: index)
        tableView.reloadData()
    }
}

// MARK:- Photos collection view
extension SetUpProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = profilePhotos.count + 1
        return count > profilePhotosMAX ? profilePhotosMAX : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (profilePhotos.count < profilePhotosMAX) && (indexPath.row == 0) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCollectionCell.typeName, for: indexPath) as! AddPhotoCollectionCell
            cell.delegate = self
            return cell
        }
        let index = profilePhotos.count >= profilePhotosMAX ? indexPath.row : indexPath.row - 1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.typeName, for: indexPath) as! PhotoCollectionCell
        if let photoURLString = profilePhotos[index].path {
            cell.imgView.sd_setImage(with: URL(string: photoURLString))
        } else {
            cell.imgView.image = profilePhotos[index].image!
        }
        cell.tag = index
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 102.0, height: 100.0)
    }
}
