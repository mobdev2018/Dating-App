//
//  MainNavigationManager.swift
//  Flip
//
//  Created by Sasha on 2/8/17.
//  Copyright © 2017 Qbits. All rights reserved.
//

import UIKit

enum SlidingPanelState {
    case LeftVisible
    case CenterVisible
    case RightVisible
}

class SlidingPanelViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let kTopZPostion = CGFloat(2.0)
    let kBottomZPosition = CGFloat(1.0)
    //MARK: - Public properties
    
    //MARK: - return current visible controller
    var visibleController: UIViewController?
    
    //MARK: - Width(Percentage of screen) that will show left sliding panel
    
    // Default Value - 0.5 (Range between 0 and 1)
    var leftPanelVisibleWidth: CGFloat = 0.84
    
    
    
    //MARK: - Width(Percentage of screen) that will show right sliding panel
    // Default Value - 0.5 (Range between 0 and 1)
    var rightPanelVisibleWidth: CGFloat = 1.0
    
    
    
    //MARK: - Movement(Percentage of screen) after that panel will toggel its state
    // Default Value - 0.15 (Range between 0 and 1)
    var panMovementThresold: CGFloat = 0.15
    
    
    
    //MARK: - Time used for animation while toggling sliding panels
    // Default Value - 0.2 (Seconds)
    var animationDuration: Double = 0.2
    
    
    
    //MARK: - Enabling panning on center sliding panel
    var shouldPanEnabledSliding: Bool = true
    
    //MARK: - Enabling panning on  top view controller of
    // center sliding panel only
    var shouldPanningLimitedToTopViewController: Bool = true
    
    
    //MARK: - Enabling  left over panning on center sliding panel
    var shouldAllowLeftOverPanning: Bool = true
    
    
    //MARK: - Enabling right over panning on center sliding panel
    var shouldAllowRightOverPanning: Bool = true
    
    
    
    //MARK: - Enabling tapping on center sliding panel
    var shouldTapEnabledSliding: Bool = true
    
    
    
    //MARK: - Enabling rotaion of controller with rotation of device
    var shouldAutoRotationEnabled: Bool = true
    
    
    //MARK: - Applying animation while toggling side panel
    var shouldAnimateSidePanel: Bool = false
    
    
    //MARK: - Applying animation while toggling side panel
    var shouldBounceEnableSliding: Bool = true
    
    //MARK: - Time used for bounce while toggling sliding panels
    // Default Value - 0.3 (Seconds)
    var bounceDuration: Double = 0.1
    
    //MARK: - Left panel holding the controller to show
    var leftPanel: UIViewController? {
        didSet{
            oldValue?.willMove(toParentViewController: nil)
            oldValue?.view.removeFromSuperview()
            oldValue?.removeFromParentViewController()
            
            self.leftPanel?.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.addChildViewController(self.leftPanel!)
            self.leftPanelContainerView.addSubview((self.leftPanel?.view)!)
            self.leftPanel?.didMove(toParentViewController: self)
            
            if self.shouldPanEnabledSliding {
                self.addPanGestureToView(view: (self.leftPanel?.view)!)
            }
        }
    }
    
    //MARK: - Center panel holding the controller to show
    var centerPanel: UIViewController? {
        didSet{
            
            oldValue?.willMove(toParentViewController: nil)
            oldValue?.view.removeFromSuperview()
            oldValue?.removeFromParentViewController()
            
            self.centerPanel?.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.addChildViewController(self.centerPanel!)
            self.centerPanelContainerView.addSubview((self.centerPanel?.view)!)
            self.centerPanel?.didMove(toParentViewController: self)
            
            /*if self.shouldPanEnabledSliding {
                self.addPanGestureToView(view: (self.centerPanel?.view)!)
            }*/
            
        }
    }
    
    //MARK: - Right panel holding the controller to show
    var rightPanel: UIViewController? {
        didSet{
            oldValue?.willMove(toParentViewController: nil)
            oldValue?.view.removeFromSuperview()
            oldValue?.removeFromParentViewController()
            
            self.rightPanel?.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.addChildViewController(self.rightPanel!)
            self.rightPanelContainerView.addSubview((self.rightPanel?.view)!)
            self.rightPanel?.didMove(toParentViewController: self)
        }
    }
    
    //MARK: - Private properties
    var leftPanelContainerView: UIView = UIView()
    private var centerPanelContainerView: UIView = UIView()
    private var rightPanelContainerView: UIView = UIView()
    private var tapView: UIView?
    private static var defaultImage: UIImage!
    private var locationBeforePan: CGPoint?
    private var centerPanelRestingFrame: CGRect?
    
    private var slidingPanelState: SlidingPanelState = .CenterVisible {
        didSet{
            switch self.slidingPanelState {
            case .LeftVisible:
                self.visibleController = self.leftPanel
                self.leftPanelContainerView.isUserInteractionEnabled = true
                
            case .CenterVisible:
                self.visibleController = self.centerPanel
                self.leftPanelContainerView.isUserInteractionEnabled = false
                self.rightPanelContainerView.isUserInteractionEnabled = false
                
            case .RightVisible:
                self.visibleController = self.rightPanel
                self.rightPanelContainerView.isUserInteractionEnabled = true
                
            }
        }
    }
    
    private var leftSlidingPanelVisibleWidth: CGFloat {
        return self.view.bounds.width * self.leftPanelVisibleWidth
    }
    
    private var rightSlidingPanelVisibleWidth: CGFloat {
        return self.view.bounds.width * self.rightPanelVisibleWidth
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.leftPanelContainerView.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        var leftPanelFrame = self.view.bounds
        leftPanelFrame.size.width = self.leftSlidingPanelVisibleWidth
        self.leftPanelContainerView.frame = leftPanelFrame
        self.leftPanel?.view.frame = self.leftPanelContainerView.frame
        
        self.centerPanelContainerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.centerPanelContainerView.frame = self.view.bounds
        self.centerPanel?.view.frame = self.centerPanelContainerView.frame
        
        
        self.rightPanelContainerView.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        var rightPanelFrame = self.view.bounds
        rightPanelFrame.size.width = self.rightSlidingPanelVisibleWidth
        self.rightPanelContainerView.frame = rightPanelFrame
        self.rightPanel?.view.frame = self.rightPanelContainerView.frame
        
       //centerPanelContainerView.layer.zPosition = 3
        leftPanelContainerView.layer.zPosition = kTopZPostion
        rightPanelContainerView.layer.zPosition = kBottomZPosition
        rightPanelContainerView.alpha = 0.0
        leftPanelContainerView.alpha = 1.0
        
        self.view.addSubview(self.centerPanelContainerView)
        self.view.addSubview(self.leftPanelContainerView)
        self.view.addSubview(self.rightPanelContainerView)
        
        
        self.hamburgurButtonForLeftPanel()
        self.hamburgurButtonForRightPanel()
        
        self.slidingPanelState = .CenterVisible
        self.view?.bringSubview(toFront: self.leftPanelContainerView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.layoutPanelContainer()
        self.styleForContainer(containerView: self.centerPanelContainerView, animationOption: false)
    }
    
    open override var shouldAutorotate: Bool {
        get {
            if let controller = self.visibleController {
                if self.shouldAutoRotationEnabled { return controller.shouldAutorotate }
            }
            return false
        }
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.layoutPanelContainer()
        self.styleForContainer(containerView: self.centerPanelContainerView, animationOption: false)
    }
    
    //MARK: - Container Layout Methods
    
    private func layoutPanelContainer() {
        self.layoutCenterPanelContainer()
        self.layoutSidePanelContainer()
    }
    
    private func layoutCenterPanelContainer() {
        
        var centerPanelFrame = self.view.bounds
        
        switch self.slidingPanelState {
        case .LeftVisible:
            centerPanelFrame.origin.x = self.leftSlidingPanelVisibleWidth
            leftPanelContainerView.layer.zPosition = kTopZPostion
            rightPanelContainerView.layer.zPosition = kBottomZPosition
            
            rightPanelContainerView.alpha = 0.0
            leftPanelContainerView.alpha = 1.0
            
        case .CenterVisible:
            centerPanelFrame.origin.x = 0.0
            
        case .RightVisible:
            centerPanelFrame.origin.x = centerPanelFrame.origin.x - self.rightSlidingPanelVisibleWidth
            
            leftPanelContainerView.layer.zPosition = kBottomZPosition
            rightPanelContainerView.layer.zPosition = kTopZPostion
            
            rightPanelContainerView.alpha = 1.0
            leftPanelContainerView.alpha = 0.0
        }
        
        self.centerPanelContainerView.frame = centerPanelFrame
        self.centerPanelRestingFrame = centerPanelFrame
    }
    
    
    private func layoutSidePanelContainer() {
        
        var leftPanelFrame = self.view.bounds
        var rightPanelFrame = self.view.bounds
        
        if self.shouldAnimateSidePanel {
            switch self.slidingPanelState {
            case .LeftVisible:
                leftPanelFrame.origin.x = 0.0
                leftPanelFrame.size.width = self.leftSlidingPanelVisibleWidth
                rightPanelFrame.origin.x = self.view.frame.width + self.leftSlidingPanelVisibleWidth
                leftPanelContainerView.layer.zPosition = kTopZPostion
                rightPanelContainerView.layer.zPosition = kBottomZPosition
                
                rightPanelContainerView.alpha = 0.0
                leftPanelContainerView.alpha = 1.0
                
            case .CenterVisible:
                leftPanelFrame.origin.x = self.view.frame.origin.x - self.leftSlidingPanelVisibleWidth
                leftPanelFrame.size.width = self.leftSlidingPanelVisibleWidth
                rightPanelFrame.origin.x = self.view.frame.width
                rightPanelFrame.size.width = self.rightSlidingPanelVisibleWidth
            case .RightVisible:
                leftPanelFrame.origin.x = self.view.frame.origin.x - leftPanelFrame.width
                rightPanelFrame.origin.x = rightPanelFrame.width - self.rightSlidingPanelVisibleWidth
                rightPanelFrame.size.width = self.rightSlidingPanelVisibleWidth
                rightPanelContainerView.layer.zPosition = kTopZPostion
                leftPanelContainerView.layer.zPosition = kBottomZPosition
                
                rightPanelContainerView.alpha = 1.0
                leftPanelContainerView.alpha = 0.0
            }
            
        } else {
            leftPanelFrame.origin.x = 0.0
            leftPanelFrame.size.width = self.leftSlidingPanelVisibleWidth
            rightPanelFrame.origin.x = rightPanelFrame.size.width - self.rightSlidingPanelVisibleWidth
            rightPanelFrame.size.width = self.rightSlidingPanelVisibleWidth
        }
        
        self.leftPanelContainerView.frame = leftPanelFrame
        self.rightPanelContainerView.frame = rightPanelFrame
    }
    
    
    //MARK: - Hambuger Button Addition Methods
    
    func hamburgurButtonForLeftPanel() {
        if (self.leftPanel != nil) {
            if let controllerForHamburgur = self.centerPanel as? UINavigationController {
                
                let barButton =  self.leftPanelHamburgurButton()
                barButton.tintColor = UIColor.black
                controllerForHamburgur.viewControllers.first?.navigationItem.leftBarButtonItem = barButton
            }
        }
    }
    
    func hamburgurButtonForRightPanel() {
        if (self.rightPanel != nil) {
            if let controllerForHamburgur = self.centerPanel as? UINavigationController {
                
                let barButton =  self.rightPanelHamburgurButton()
                barButton.tintColor = UIColor.black
                controllerForHamburgur.viewControllers.first?.navigationItem.rightBarButtonItem = barButton
            }
        }
    }
    
    //MARK: - Internal Methods
    
    private func animateCenterSlidingPanel( onCompletion closure: ((Bool) -> Void)?) {
        var animationDuration = 0.2
        
        let xStart = centerPanelContainerView.frame.origin.x
        let width = centerPanelContainerView.frame.width
        let xEnd = xStart + width
        
        switch slidingPanelState {
        case .LeftVisible:
            animationDuration = TimeInterval((width - xStart) / width)
        case .CenterVisible:
            animationDuration = TimeInterval(abs(xStart / width))
        case .RightVisible:
            animationDuration = TimeInterval(xEnd / width)
        }
        
        if animationDuration > 1.0 {
            animationDuration = 1.0
        }
        
        animationDuration = animationDuration * 0.7
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [.layoutSubviews], animations: {
            self.layoutPanelContainer()
        }, completion: { (finished) in
            self.layoutCenterPanelContainer()
            
            if let closureToCall = closure {
                closureToCall(finished)
            }
        })
    }
    
    
    private func styleForContainer(containerView: UIView?, animationOption animated:Bool) {
        if let view = containerView {
            
            let shadowPath = UIBezierPath(rect: view.bounds)
            if animated {
                
                let animation = CABasicAnimation(keyPath: "shadowPath")
                animation.fromValue = view.layer.shadowPath
                animation.toValue = shadowPath.cgPath
                animation.duration = 0.2
                view.layer.add(animation, forKey: "shadowPath")
            }
            
            view.layer.shadowPath = shadowPath.cgPath;
            view.layer.shadowColor = UIColor.black.cgColor;
            view.layer.shadowRadius = 7.0
            view.layer.shadowOpacity = 0.25
            view.clipsToBounds = false
        }
    }
    
    private func timeForAnimation() -> Double {
        
        let remaining = self.centerPanelContainerView.frame.origin.x - (self.centerPanelRestingFrame?.origin.x)!
        let max = (self.locationBeforePan?.x)! == self.centerPanelRestingFrame?.origin.x ? remaining : self.locationBeforePan!.x - (self.centerPanelRestingFrame?.origin.x)!
        
        return max > 0.0 ? self.animationDuration * Double(remaining / max) : self.animationDuration
    }
    
    //MARK: - Gesture(Tap/Pan)  Methods
    
    private func addTapViewOnCenterPanelContainer() {
        if self.tapView == nil {
            self.tapView = UIView()
            self.tapView?.backgroundColor = UIColor.clear
            self.tapView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        self.tapView?.frame = self.centerPanelContainerView.bounds
        self.centerPanelContainerView.addSubview(self.tapView!)
        self.centerPanelContainerView.bringSubview(toFront: self.tapView!)
        
        if self.shouldTapEnabledSliding {
            self.addTapGestureToView(view: self.tapView!)
        }
        
        if self.shouldPanEnabledSliding {
            self.addPanGestureToView(view: self.leftPanelContainerView)
        }
    }
    
    
    private func removeTapViewOnCenterPanelContainer() {
        self.tapView?.removeFromSuperview()
    }
    
    private func addTapGestureToView(view: UIView) {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCenterPanel))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Pan Gesture  Methods
    private func addPanGestureToView(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGesture.delegate = self
        panGesture.maximumNumberOfTouches = 1;
        panGesture.minimumNumberOfTouches = 1;
        view.addGestureRecognizer(panGesture)
    }
    
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        if !self.shouldPanEnabledSliding {
            return
        }
        
        if gesture.state == .began {
            locationBeforePan = self.centerPanelContainerView.frame.origin
        }
        
        let translate = gesture.translation(in: self.leftPanelContainerView)
        var frame = self.centerPanelRestingFrame!
        frame.origin.x += self.correctMovement(movement: translate.x)
        
        self.leftPanelContainerView.frame = frame
        
        if centerPanelContainerView.frame.origin.x < 0 {
            leftPanelContainerView.layer.zPosition = kBottomZPosition
            rightPanelContainerView.layer.zPosition = kTopZPostion
            
            rightPanelContainerView.alpha = 1.0
            leftPanelContainerView.alpha = 0.0
            
        } else {
            leftPanelContainerView.layer.zPosition = kTopZPostion
            rightPanelContainerView.layer.zPosition = kBottomZPosition
            
            rightPanelContainerView.alpha = 0.0
            leftPanelContainerView.alpha = 1.0
        }
        
        if gesture.state == .ended {
            
            let deltaX =  frame.origin.x - locationBeforePan!.x;
            if self.validateThresoldPanMovement(delta: deltaX) {
                
                switch self.slidingPanelState {
                case .CenterVisible:
                    if deltaX > 0.0 {
                        self.showLeftPanel(animated: true)
                    }
                    else {
                        self.showRightPanel(animated: true)
                    }
                case .LeftVisible:
                    self.showCenterPanel(animated: true)
                    
                case .RightVisible:
                    self.showCenterPanel(animated: true)
                }
            }
            else {
                self.undoPanEvent()
            }
        }else if gesture.state == .cancelled {
            self.undoPanEvent()
        }
    }
    
    private func correctMovement(movement: CGFloat) -> CGFloat {
        let position = (self.centerPanelRestingFrame?.origin.x)! + movement
        
        switch self.slidingPanelState {
        case .LeftVisible:
            if (position > self.leftSlidingPanelVisibleWidth) {
                return 0.0
            }
            else if  position < 0.0 {
                return -(self.centerPanelRestingFrame?.origin.x)!;
            }
            else if position < self.leftPanelContainerView.frame.origin.x {
                return self.leftPanelContainerView.frame.origin.x - (self.centerPanelRestingFrame?.origin.x)!
            }
            
            
        case .CenterVisible:
            if (position > 0.0  && self.leftPanel == nil) || (position < 0.0  && self.rightPanel == nil) {
                return 0.0
            }
            else if self.shouldAllowRightOverPanning &&  position > self.leftSlidingPanelVisibleWidth {
                return self.leftSlidingPanelVisibleWidth
            }
            else if self.shouldAllowRightOverPanning && position < -self.rightSlidingPanelVisibleWidth {
                return -self.rightSlidingPanelVisibleWidth
            }
            
            
        case .RightVisible:
            if position < -self.rightSlidingPanelVisibleWidth {
                return 0.0;
            }
            else if  position > 0.0 {
                return -self.centerPanelRestingFrame!.origin.x
            }
            else if position > self.rightPanelContainerView.frame.origin.x {
                return self.rightPanelContainerView.frame.origin.x - self.centerPanelRestingFrame!.origin.x;
            }
        }
        
        return movement
    }
    
    private func validateThresoldPanMovement(delta: CGFloat) -> Bool {
        let minimum = self.view.bounds.size.width * self.panMovementThresold
        switch self.slidingPanelState {
        case .LeftVisible:
            return delta <= -minimum
            
        case .CenterVisible:
            return fabs(delta) >= minimum
            
        case .RightVisible:
            return delta >= minimum
        }
    }
    
    private func undoPanEvent()  {
        switch self.slidingPanelState {
        case .LeftVisible:
            self.showLeftPanel(animated: true)
            
        case .CenterVisible:
            self.showCenterPanel(animated: true)
            
        case .RightVisible:
            self.showRightPanel(animated: true)
        }
    }
    
    //MARK: Checking controller is on top level or not
    func isTopeLevelViewController(_ controller: UIViewController?) -> Bool {
        guard let topController = controller else {
            return false
        }
        
        if topController is UINavigationController {
            return (topController as! UINavigationController).viewControllers.count == 1 //navigation.viewControllers.count == 1
        }
        return true
    }
    
    //MARK: Left Sliding Panel show/hide methods
    func toggleLeftSlidingPanel() {
        if self.slidingPanelState == SlidingPanelState.LeftVisible {
            
            self.showCenterPanel(animated: true)
        }
        else {
            self.showLeftPanel(animated: true)
        }
    }
    
    func showLeftPanel(animated:Bool) {
        leftPanelContainerView.layer.zPosition = kTopZPostion
        rightPanelContainerView.layer.zPosition = kBottomZPosition
        
        rightPanelContainerView.alpha = 0.0
        leftPanelContainerView.alpha = 1.0
        
        self.slidingPanelState = .LeftVisible
        if animated {
            self.animateCenterSlidingPanel(onCompletion: { (finished: Bool) in
                self.leftPanel?.viewWillAppear(animated)
                self.addTapViewOnCenterPanelContainer()
            })
        }
        else {
            self.layoutPanelContainer()
            self.styleForContainer(containerView: self.centerPanelContainerView, animationOption: true)
            self.leftPanel?.viewWillAppear(animated)
            self.addTapViewOnCenterPanelContainer()
        }
    }
    
    //MARK: Center Sliding Panel show/hide method
    func showCenterPanel(animated:Bool) {
        self.slidingPanelState = .CenterVisible
        self.hamburgurButtonForLeftPanel()
        self.hamburgurButtonForRightPanel()
        
        //if animated {
        
        self.animateCenterSlidingPanel(onCompletion: {[weak self] (finished: Bool) in
            self?.removeTapViewOnCenterPanelContainer()
        })
        /*}
         else {
         self.layoutPanelContainer()
         self.styleForContainer(containerView: self.centerPanelContainerView, animationOption: true)
         self.removeTapViewOnCenterPanelContainer()
         }*/
        
    }
    
    func toggleRightSlidingPanel() {
        if self.slidingPanelState == SlidingPanelState.RightVisible {
            self.showCenterPanel(animated: true)
        }
        else {
            self.showRightPanel(animated: true)
        }
    }
    
    func showRightPanel(animated:Bool) {
        self.slidingPanelState = .RightVisible
        
        leftPanelContainerView.layer.zPosition = kBottomZPosition
        rightPanelContainerView.layer.zPosition = kTopZPostion
        
        rightPanelContainerView.alpha = 1.0
        leftPanelContainerView.alpha = 0.0
        
        if animated {
            
            self.animateCenterSlidingPanel(onCompletion: { (finished: Bool) in
                self.rightPanel?.viewWillAppear(animated)
                self.addTapViewOnCenterPanelContainer()
            })
        }
        else {
            self.layoutPanelContainer()
            self.styleForContainer(containerView: self.centerPanelContainerView, animationOption: true)
            self.rightPanel?.viewWillAppear(animated)
            self.addTapViewOnCenterPanelContainer()
        }
        
    }
    
    func leftPanelHamburgurButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: SlidingPanelViewController.defaultHamburgerImage(), style: UIBarButtonItemStyle.done, target: self, action: #selector(toggleLeftSlidingPanel))
    }
    
    func rightPanelHamburgurButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: SlidingPanelViewController.defaultHamburgerImage(), style: UIBarButtonItemStyle.done, target: self, action: #selector(toggleRightSlidingPanel))
    }
    
    //MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIButton {
            return false
        }
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.view == self.tapView) {
            return true
        }
        else if self.shouldPanningLimitedToTopViewController && !self.isTopeLevelViewController(self.centerPanel) {
            return false
        }
        else if let gesture =  gestureRecognizer as? UIPanGestureRecognizer {
            
            let translate = gesture.translation(in: self.centerPanelContainerView)
            
            if translate.x < 0 && !self.shouldAllowRightOverPanning {
                return false
            }
            
            if translate.x > 0 && !self.shouldAllowLeftOverPanning {
                return false
            }
            
            let possible = translate.x != 0 && ((fabs(translate.y) / fabs(translate.x)) < 1.0)
            
            if (possible && ((translate.x > 0 && self.leftPanel != nil) || (translate.x < 0 && self.rightPanel != nil))) {
                return true;
            }
        }
        return false
    }
    
    
    //MARK: Hamburgur image
    
    static func defaultHamburgerImage() -> UIImage {
        guard let image = defaultImage else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 20, height: 13), false, 0.0)
            UIColor.black.setFill()
            
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 20, height: 1)).fill()
            UIBezierPath(rect: CGRect(x: 0, y: 5, width: 20, height: 1)).fill()
            UIBezierPath(rect: CGRect(x: 0, y: 10, width: 20, height: 1)).fill()
            
            UIColor.white.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 1, width: 20, height: 2)).fill()
            UIBezierPath(rect: CGRect(x: 0, y: 6, width: 20, height: 2)).fill()
            UIBezierPath(rect: CGRect(x: 0, y: 11, width: 20, height: 2)).fill()
            
            defaultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return defaultImage;
        }
        
        return image
    }
}
