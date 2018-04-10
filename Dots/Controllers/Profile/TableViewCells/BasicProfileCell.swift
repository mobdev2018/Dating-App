//
//  BasicProfileCell.swift
//  Dots
//
//  Created by Sasha on 8/4/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

protocol BasicProfileCellDelegate: class {
    func didChange(value: Any, position: CellPosition)
    func didChange(minValue: Any, maxValue:Any, position: CellPosition)
    func minMaxFor(_ position: CellPosition) -> String
}

class BasicProfileCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    weak var delegate: BasicProfileCellDelegate?
    
    private lazy var topSeparator: UIView = { [weak self] in
        let topSeparatorView = UIView(frame: .zero)
        topSeparatorView.backgroundColor = .cellSeparatorColor
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.layer.zPosition = CGFloat(Int.max)
        self?.contentView.addSubview(topSeparatorView)
        
        if let v = self?.contentView {
            let xPos = topSeparatorView.centerXAnchor.constraint(equalTo: v.centerXAnchor)
            let top = topSeparatorView.topAnchor.constraint(equalTo: v.topAnchor, constant: -0.5)
            let width = topSeparatorView.widthAnchor.constraint(equalTo: v.widthAnchor, multiplier: 0.9)
            let height = topSeparatorView.heightAnchor.constraint(equalToConstant: 1.0)
            NSLayoutConstraint.activate([xPos,top,width,height])
        }
        return topSeparatorView
        }()
    
    private lazy var bottomSeparator: UIView = { [weak self] in
        let bottomSeparatorView = UIView(frame: .zero)
        bottomSeparatorView.backgroundColor = .cellSeparatorColor
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorView.layer.zPosition = CGFloat(Int.max)
        self?.contentView.addSubview(bottomSeparatorView)

        if let v = self?.contentView {
            let xPos = bottomSeparatorView.centerXAnchor.constraint(equalTo: v.centerXAnchor)
            let top = bottomSeparatorView.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: 0.5)
            let width = bottomSeparatorView.widthAnchor.constraint(equalTo: v.widthAnchor, multiplier: 0.9)
            let height = bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1.0)
            NSLayoutConstraint.activate([xPos,top,width,height])
        }
        return bottomSeparatorView
        }()
    
    //
    var positon: CellPosition! {
        didSet {
            applyPosition(pos: positon)
        }
    }
    
    var showTopSeparatorView: Bool = true {
        didSet {
            topSeparator.isHidden = !showTopSeparatorView
        }
    }
    var showBottomSeparatorView: Bool = true {
        didSet {
            bottomSeparator.isHidden = !showBottomSeparatorView
        }
    }
    
    func applyPosition(pos: CellPosition) {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layoutIfNeeded()
        
        contentView.layoutMargins = .zero
        translatesAutoresizingMaskIntoConstraints = false
        
        showTopSeparatorView = true
        showBottomSeparatorView = true
    }
}
