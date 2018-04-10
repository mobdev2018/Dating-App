//
//  AboutUserView.swift
//  Dots
//
//  Created by Sasha on 11/21/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

final class AboutUserView: UIView {
    //@IBOutlet var distanceLbl: UILabel!
    /*@IBOutlet var aboutmeLbl: UILabel!
     @IBOutlet var ethnicityLbl: UILabel!
     @IBOutlet var heightLbl: UILabel!
     @IBOutlet var workplaceLbl: UILabel!
     @IBOutlet var educationLbl: UILabel!
     @IBOutlet var nameLbl: UILabel!
     @IBOutlet var backImgView: UIImageView!*/
    
    @IBOutlet weak var profileImgView: ProfileImgView!
    @IBOutlet weak var profileInfoView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var workLbl: UILabel!
    @IBOutlet weak var educationLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var arrowTopImgView: UIImageView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var page: UIPageControl!
    
    var profile: Profile!
    
    weak var delegate: MatchViewController?
    
    static func loadFromNib() ->  AboutUserView {
        let view = Bundle.main.loadNibNamed(AboutUserView.typeName, owner: self, options: nil)?[0] as! AboutUserView
        
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return view
    }
    
    func updateData() {
        if let name = profile.name {
            if let age = profile.age {
                nameLbl.text = "\(name), \(age)"
            } else {
                nameLbl.text = "\(name)"
            }
        } else {
            if let age = profile.age {
                nameLbl.text = "\(age)"
            }
        }
        
        if let work = profile.work {
            workLbl.text = work
            
            if let education = profile.education  {
                educationLbl.text = education
            }
        } else {
            if let education = profile.education  {
                workLbl.text = education
            }
        }
        
        locationLbl.text = "2 miles away"
        
        if let about = profile.about {
            detailsLbl.text = about
        }
        
        profileImgView.page.numberOfPages = profile.photos!.count
        profileImgView.page.isHidden = profile.photos!.count == 1
    }
}

// MARK:- Actions
extension AboutUserView {
    @IBAction func onShowProfile() {
        if bottomConstraint.constant > -profileInfoView.bounds.size.height {
            
            bottomConstraint.constant = -profileInfoView.bounds.size.height
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [], animations: { [weak self] in
                guard let s = self else { return }
                s.arrowTopImgView.transform = s.arrowTopImgView.transform.rotated(by: CGFloat(Float.pi))
                s.layoutIfNeeded()
                
                }, completion: nil)
        } else {
            bottomConstraint.constant = -110
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [], animations: { [weak self] in
                guard let s = self else { return }
                s.arrowTopImgView.transform = s.arrowTopImgView.transform.rotated(by: CGFloat(Float.pi))
                s.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    @IBAction func onOpenProfile() {
        let profileVC = UIStoryboard.getController(ProfileViewController.self) as! ProfileViewController
        profileVC.isMyProfile = false
        profileVC.profile = profile
        delegate?.navigationController?.pushViewController(profileVC, animated: true)
    }
}
