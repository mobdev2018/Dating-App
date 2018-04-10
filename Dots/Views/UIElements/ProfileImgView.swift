//
//  ProfileImgView.swift
//  Dots
//
//  Created by Sasha on 9/26/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit


// MARK:- ProfileImgView
protocol ProfileImgViewDelegate: class {
    func profileImgSwipeUp()
    func profileImgSwipeDown()
}

protocol MatchProfileImgViewDelegate: class {
    func profileImgSwipeUp(_ profileImg: ProfileImgView)
    func profileImgSwipeDown(_ profileImg: ProfileImgView)
}

class ProfileImgView: UIImageView {
    weak var delegate: ProfileImgViewDelegate?
    weak var matchDelegate: MatchProfileImgViewDelegate?
    @IBOutlet var page: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isUserInteractionEnabled = true
        initGestures()
    }
    
    func initGestures() {
        if let _ = self.delegate {
            let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(gesture:)))
            swipeGestureUp.direction = UISwipeGestureRecognizerDirection.up
            self.addGestureRecognizer(swipeGestureUp)
            
            let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(gesture:)))
            swipeGestureDown.direction = UISwipeGestureRecognizerDirection.down
            self.addGestureRecognizer(swipeGestureDown)
        } else {
            let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(gesture:)))
            swipeGestureUp.direction = UISwipeGestureRecognizerDirection.right
            self.addGestureRecognizer(swipeGestureUp)
            
            let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(gesture:)))
            swipeGestureDown.direction = UISwipeGestureRecognizerDirection.left
            self.addGestureRecognizer(swipeGestureDown)
        }
        
    }
    
    @objc func swipeUp(gesture: UISwipeGestureRecognizer) {
        delegate?.profileImgSwipeUp()
        matchDelegate?.profileImgSwipeUp(self)
    }
    
    @objc func swipeDown(gesture: UISwipeGestureRecognizer) {
        delegate?.profileImgSwipeDown()
        matchDelegate?.profileImgSwipeUp(self)
    }
}
