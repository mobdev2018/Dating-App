//
//  SwipeView.swift
//  Иwipedemo
//
//  Created by Sasha on 1/24/17.
//  Copyright © 2017 QBits. All rights reserved.
//

import UIKit

protocol SwipeViewDelegate: class {
    func swipeViewLeft(_ card: SwipeView)
    func swipeViewRight(_ card: SwipeView)
    func swipeViewTapped(_ card: SwipeView)
    func swipeViewUp(_ card: SwipeView)
    func swipeViewDown(_ card: SwipeView)
}

class SwipeView: UIView {
    weak var delegate: SwipeViewDelegate?
    
    var leftOverlay: UIImageView!
    var rightOverlay: UIImageView!
    var imgView: UIImageView!
    var aboutUser: AboutUserView!

    
    private let actionMargin: CGFloat = 30.0
    private let rotationStrength: CGFloat = 320.0
    private let rotationAngle: CGFloat = CGFloat(M_PI) / CGFloat(8.0)
    private let rotationMax: CGFloat = 1
    private let scaleStrength: CGFloat = -2
    private let scaleMax: CGFloat = 1.02
    
    private var xFromCenter: CGFloat = 0.0
    private var yFromCenter: CGFloat = 0.0
    private var originalPoint = CGPoint.zero
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        /*imgView = UIImageView(frame: self.frame)
        imgView.isUserInteractionEnabled = true
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 5.0
        addSubview(imgView)*/
        
        aboutUser = AboutUserView.loadFromNib()
        aboutUser.frame = self.bounds
        aboutUser.contentMode = .scaleAspectFill
        aboutUser.isUserInteractionEnabled = true
        aboutUser.clipsToBounds = true
        aboutUser.layer.cornerRadius = 5.0
        
        addSubview(aboutUser)
        
        aboutUser.page.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        //aboutUser.layer.transform = CATransform3DRotate(aboutUser.layer.transform, CGFloat(M_PI_2)/1.8, 0, 1, 0)
        
        leftOverlay = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        leftOverlay.isUserInteractionEnabled = true
        leftOverlay.image = UIImage(named: "check-list")
        leftOverlay.alpha = 0.0
        
        leftOverlay.center = self.center
        addSubview(leftOverlay)
        
        rightOverlay = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        rightOverlay.isUserInteractionEnabled = true
        rightOverlay.image = UIImage(named: "next")
        rightOverlay.alpha = 0.0
        rightOverlay.center = self.center
        addSubview(rightOverlay)
        
        layer.shadowRadius = 1
        layer.shadowOpacity = 1.0
        layer.shadowColor = UIColor(white: 0.7, alpha: 1.0).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 5.0
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragEvent(gesture:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        
        /*let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEvent(gesture:)))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(gesture:)))
        swipeGestureUp.delegate = self
        swipeGestureUp.direction = UISwipeGestureRecognizerDirection.up
        self.addGestureRecognizer(swipeGestureUp)
        
        let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(gesture:)))
        swipeGestureDown.delegate = self
        swipeGestureDown.direction = UISwipeGestureRecognizerDirection.down
        self.addGestureRecognizer(swipeGestureDown)
        
        panGesture.require(toFail: swipeGestureUp)
        panGesture.require(toFail: swipeGestureDown)*/
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leftOverlay = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        leftOverlay.isUserInteractionEnabled = true
        leftOverlay.image = UIImage(named: "like_red")
        leftOverlay.alpha = 0.0
        
        leftOverlay.center = self.center
        addSubview(leftOverlay)
        
        rightOverlay = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        rightOverlay.isUserInteractionEnabled = true
        rightOverlay.image = UIImage(named: "next")
        rightOverlay.alpha = 0.0
        rightOverlay.center = self.center
        addSubview(rightOverlay)
        
        layer.shadowRadius = 3
        layer.shadowOpacity = 2.0
        layer.shadowColor = UIColor(white: 0.7, alpha: 1.0).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 5.0
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragEvent(gesture:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Gesture recognizers
    @objc func dragEvent(gesture: UIPanGestureRecognizer) {
        xFromCenter = gesture.translation(in: self).x
        yFromCenter = gesture.translation(in: self).y
        
        switch gesture.state {
        case .began:
            self.originalPoint = self.center
            
            break
        case .changed:
            let rStrength = min(xFromCenter / self.rotationStrength, rotationMax) * 0.2
            let rAngle = -self.rotationAngle * rStrength
            
            
            let scale = min(1 - fabs(rStrength) / self.scaleStrength, self.scaleMax)
            self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y/* + yFromCenter*/)
            let transform = CGAffineTransform(rotationAngle: rAngle)
            let scaleTransform = transform.scaledBy(x: scale, y: scale)
            self.transform = scaleTransform
            self.updateOverlay(xFromCenter)
            break
        case .ended:
            self.afterSwipeAction()
            break
        default:
            break
        }
    }
    var i = 0
    
    /*func tapEvent(gesture: UITapGestureRecognizer) {
        //delegate?.swipeViewTapped(self)
        let duration1 = 0.15
        let duration2 = 0.15
        let k = CGFloat(1.8)
        
        if i % 2 == 0 {
            UIView.animate(withDuration: duration1, delay: 0.0, options: .curveLinear , animations: {
                self.imgView.layer.transform = CATransform3DRotate(self.imgView.layer.transform, CGFloat(M_PI_2)/k, 0, 1.0, 0)
            }) { (complted) in
                self.imgView.isHidden = true
                self.aboutUser.isHidden = false
            }
            
            UIView.animate(withDuration: duration2, delay: duration1, usingSpringWithDamping: 0.4 , initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                //self.aboutUser.layer.transform = CATransform3DRotate(self.aboutUser.layer.transform, -CGFloat(M_PI_2)/k, 0, 1.0, 0)
            }) { (complted) in
                
            }
        } else {
            UIView.animate(withDuration: duration1, delay: 0.0, options: .curveLinear , animations: {
                self.aboutUser.layer.transform = CATransform3DRotate(self.aboutUser.layer.transform, CGFloat(M_PI_2)/k, 0, 1.0, 0)
            }) { (complted) in
                self.aboutUser.isHidden = true
                self.imgView.isHidden = false
            }
            
            UIView.animate(withDuration: duration2, delay: duration1, usingSpringWithDamping: 0.4 , initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.imgView.layer.transform = CATransform3DRotate(self.imgView.layer.transform, -CGFloat(M_PI_2)/k, 0, 1.0, 0)
                
            }) { (complted) in
                self.aboutUser.layer.transform = CATransform3DRotate(self.aboutUser.layer.transform, -CGFloat(M_PI_2)/k, 0, 1.0, 0)
            }
        }
        i = i + 1
    }*/
    
    @objc func swipeUp(gesture: UISwipeGestureRecognizer) {
        delegate?.swipeViewUp(self)
    }
    
    @objc func swipeDown(gesture: UISwipeGestureRecognizer) {
        delegate?.swipeViewDown(self)
    }

    private func afterSwipeAction() {
        if xFromCenter > actionMargin {
            self.rightAction()
        } else if xFromCenter < -actionMargin {
            self.leftAction()
        } else {
            UIView.animate(withDuration: 0.3) {
                self.center = self.originalPoint
                self.transform = CGAffineTransform.identity
                self.leftOverlay?.alpha = 0.0
                self.rightOverlay?.alpha = 0.0
            }
        }
    }
    
    private func updateOverlay(_ distance: CGFloat) {
        var activeOverlay: UIView?
        if (distance < 0) {
            self.leftOverlay?.alpha = 0.0
            activeOverlay = self.rightOverlay
        } else {
            self.rightOverlay?.alpha = 0.0
            activeOverlay = self.leftOverlay
        }
        
        activeOverlay?.alpha = min(fabs(distance)/100, 1.0)
        
        _ = min(fabs(distance)/100, 1.0) * 1.5
        
        //activeOverlay?.layer.transform = CATransform3DMakeRotation(s + CGFloat(M_PI_2), 0, 1, 0)
    }
    
    public func rightAction() {
        let finishPoint = CGPoint(x: 500, y: 2 * yFromCenter + self.originalPoint.y)
        UIView.animate(withDuration: 0.3, animations: {
            self.center = finishPoint
            self.alpha = 0.0
        }) { _ in
            self.removeFromSuperview()
        }
        self.delegate?.swipeViewRight(self)
    }
    
    public func leftAction() {
        let finishPoint = CGPoint(x: -200, y: 2 * yFromCenter + self.originalPoint.y)
        UIView.animate(withDuration: 0.3, animations: {
            self.center = finishPoint
            self.alpha = 0.0
        }) { _ in
            self.removeFromSuperview()
        }
        self.delegate?.swipeViewLeft(self)
    }
    
    deinit {
        print("deinited \(tag)")
    }
}

// MARK: UIGestureRecognizerDelegate
extension SwipeView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UISwipeGestureRecognizer.classForCoder()) {
            return true
        }
        
        if otherGestureRecognizer.isKind(of: UISwipeGestureRecognizer.classForCoder()) {
            return true
        }
        return false
    }
}
