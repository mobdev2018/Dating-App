//
//  TagsDelegate.swift
//  Dots
//
//  Created by Sasha on 8/12/17.
//  Copyright © 2017 ConnectingDots. All rights reserved.
//

import UIKit

class TagsController: NSObject {
    var selectedTags: [String] = []
}

extension TagsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionCell.typeName, for: indexPath) as! TagCollectionCell
        cell.nameLbl.text = selectedTags[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = selectedTags[indexPath.row]
        return getLabelSize(16, text: tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    private func getLabelSize(_ fontSize: Int, text: String) -> CGSize {
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

class FlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesForElementsInRect = super.layoutAttributesForElements(in: rect)
        var newAttributesForElementsInRect = [AnyObject]()
        // use a value to keep track of left margin
        var leftMargin: CGFloat = 0.0;
        for attributes in attributesForElementsInRect! {
            let refAttributes = attributes
            // assign value if next row
            if (refAttributes.frame.origin.x == self.sectionInset.left) {
                leftMargin = self.sectionInset.left
            } else {
                // set x position of attributes to current margin
                var newLeftAlignedFrame = refAttributes.frame
                newLeftAlignedFrame.origin.x = leftMargin
                refAttributes.frame = newLeftAlignedFrame
            }
            // calculate new value for current margin
            leftMargin += refAttributes.frame.size.width + 10.0
            newAttributesForElementsInRect.append(refAttributes)
        }
        return newAttributesForElementsInRect as? [UICollectionViewLayoutAttributes]
    }
}
