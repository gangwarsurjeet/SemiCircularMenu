//
//  CustomFlowLayout.swift
//  ImageTextOverlay
//
//  Created by Surjeet on 28/04/20.
//  Copyright © 2020 Surjeet. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {

    public var cellCount = 0
    
    public var xOffSet: CGFloat = 100
    public var itemHeight: CGFloat = 0
    public var itemSpacing: CGFloat = 0
    public var radius: CGFloat = 0
    public var shouldSnap: Bool = true
    
    public var cellSize = CGSize.zero {
        didSet {
            self.itemSize = cellSize
            self.itemHeight = cellSize.height
        }
    }
    
    public var selectedItem: Int = 0
    
    private var _offset: CGFloat = 0
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.sectionInset = .zero
        self.scrollDirection = .horizontal
    }
    
    override func prepare() {
        super.prepare()
        
        if let collectionView = self.collectionView {
            cellCount = (collectionView.numberOfSections > 0) ? collectionView.numberOfItems(inSection: 0) : 0
            _offset = -collectionView.contentOffset.y / itemHeight
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        
        let maxVisibleHalf = 180 / itemSpacing
        for i in 0..<cellCount {
            let itemFrame = self.getRectForItem(item: i)
            if(rect.intersects(itemFrame) && CGFloat(i) > (-1*_offset-maxVisibleHalf) && CGFloat(i) < (-1*_offset+maxVisibleHalf)) {
                let indexPath = IndexPath.init(item: i, section: 0)
                if let layoutAttr = self.layoutAttributesForItem(at: indexPath) {
                    attributes.append(layoutAttr)
                }
            }
        }
        return attributes
    }
    
    func getRectForItem(item: Int) -> CGRect {
        let newIndex = CGFloat(item) + _offset
        let scale: CGFloat = 1.0
        let deltaX = cellSize.width / 2
        
        let rX = cosf(Float(itemSpacing * newIndex * CGFloat(Double.pi/180))) * Float(self.radius + (deltaX*scale))
        let rY = sinf(Float(itemSpacing * newIndex * CGFloat(Double.pi/180))) * Float(self.radius + (deltaX*scale))
        let oX = -radius + xOffSet - (0.5 * cellSize.width)
        var oY = ((self.collectionView?.bounds.size.height ?? 0) * 0.5) + (self.collectionView?.contentOffset.y ?? 0)
           oY -= (cellSize.height * 0.5)
        
        let itemFrame = CGRect(x: oX + CGFloat(rX), y: oY + CGFloat(rY), width: cellSize.width, height: cellSize.height)
        return itemFrame
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if shouldSnap {
            let index = Int(floor(proposedContentOffset.y / itemHeight))
            let yOffset = CGFloat(Int(proposedContentOffset.y) % Int(itemHeight))
            
            let targetY = (yOffset > itemHeight * 0.5 && index <= cellCount) ? CGFloat(index+1) * itemHeight : CGFloat(index) * itemHeight
            return CGPoint(x: proposedContentOffset.x, y: targetY)
        }
        return proposedContentOffset
    }
    
    override func targetIndexPath(forInteractivelyMovingItem previousIndexPath: IndexPath, withPosition position: CGPoint) -> IndexPath {
        return IndexPath(row: 0, section: 0)
    }
    
    override var collectionViewContentSize: CGSize {
        if let collectionView = self.collectionView {
            return CGSize(width: collectionView.bounds.size.width, height: CGFloat(cellCount-1) * itemHeight + collectionView.bounds.size.height)
        }
        return CGSize.zero
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let newIndex = CGFloat(indexPath.item) + _offset

        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        layoutAttributes.size = cellSize
        
        let rotationT = CGAffineTransform(rotationAngle: (itemSpacing * newIndex * CGFloat(Double.pi/180)))
        let minRange = -itemSpacing/2.0
        let maxRange = itemSpacing/2.0
        let currentAngle = itemSpacing * newIndex
        if ((currentAngle > minRange) && (currentAngle < maxRange)) {
            selectedItem = indexPath.row
        }
        
        let scale: CGFloat = 1.0 //fmax(0.6, 1 - fabsf(Float(newIndex * 0.25)))
        layoutAttributes.frame = self.getRectForItem(item: indexPath.row)
        let translationT = CGAffineTransform(translationX: 0, y: 0)
        let scaleT = CGAffineTransform(scaleX: scale, y: scale)
        
        layoutAttributes.alpha = scale
        layoutAttributes.isHidden = false
        layoutAttributes.transform = scaleT.concatenating(translationT.concatenating(rotationT))

        return layoutAttributes
    }
}
