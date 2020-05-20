//
//  CircularMenuView.swift
//  ImageTextOverlay
//
//  Created by Surjeet on 28/04/20.
//  Copyright © 2020 Surjeet. All rights reserved.
//

import UIKit

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}

class CircularMenuView: UIView {

    public var arcBackgroundColor = UIColor.systemPink.withAlphaComponent(0.8)
    public var itemsTextColor = UIColor.white
    public var selectorTextColor = UIColor.black
    
    public var itemFont = UIFont.systemFont(ofSize: 15)
    public var nobTitleFont = UIFont.systemFont(ofSize: 15)
    
    public var itemArray: [String]?
    public var nobTitle = ""
    public var itemSpacing: CGFloat?
    
    public var nobImage = UIImage.init(named: "nobImage")
    public var selectorImage: UIImage?
    
    public var shouldScrollToNearest: Bool = true
    
    public var callBack: ((Int, String) -> Void)?
    
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CustomFlowLayout())
    private let selecterView = CircularMenuSelectorview(frame: .zero)
    private let nobIconImageView = UIImageView(frame: .zero)
    private let nobTitleButton = UIButton(type: .custom)
    
    private var selectedIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initContent()
    }
    
    private func initContent() {
        
        nobIconImageView.backgroundColor = .clear
        nobIconImageView.image = nobImage
        nobIconImageView.contentMode = .scaleAspectFit
        
        nobTitleButton.titleLabel?.font = nobTitleFont
        nobTitleButton.contentVerticalAlignment = .center
        nobTitleButton.setTitleColor(.white, for: .normal)
        nobTitleButton.backgroundColor = .clear
        nobTitleButton.addTarget(self, action: #selector(onTitleButtonClick(_:)), for: .touchUpInside)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        self.addSubview(collectionView)
        self.addSubview(selecterView)
        self.addSubview(nobIconImageView)
        self.addSubview(nobTitleButton)

        nobTitleButton.translatesAutoresizingMaskIntoConstraints = false
        nobIconImageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        selecterView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10),
            nobIconImageView.widthAnchor.constraint(equalToConstant: 120),
            nobIconImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            nobIconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            nobTitleButton.centerXAnchor.constraint(equalTo: nobIconImageView.centerXAnchor, constant: -10),
            nobTitleButton.centerYAnchor.constraint(equalTo: nobIconImageView.centerYAnchor, constant: 0),
            nobTitleButton.widthAnchor.constraint(equalTo: nobIconImageView.widthAnchor),
            nobTitleButton.heightAnchor.constraint(equalTo: nobIconImageView.heightAnchor),
            selecterView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            selecterView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            selecterView.heightAnchor.constraint(equalToConstant: 130),
            selecterView.leftAnchor.constraint(equalTo: nobIconImageView.rightAnchor, constant: -12)
        ])
        collectionView.register(CircularMenuCell.self, forCellWithReuseIdentifier: "MenuCell")
        
        if let layout = collectionView.collectionViewLayout as? CustomFlowLayout {
            let xOffset: CGFloat = 120
            layout.shouldSnap = shouldScrollToNearest
            layout.radius = 100
            layout.itemSpacing = 30
            layout.xOffSet = xOffset
            layout.cellSize = CGSize(width: self.frame.size.width-xOffset-10, height: 60)
        }
        updateSelectedValue()
    }
    
    public func updateMenu() {
        if let spacing = itemSpacing, let layout = collectionView.collectionViewLayout as? CustomFlowLayout {
            layout.itemSpacing = spacing
            layout.shouldSnap = shouldScrollToNearest
        }
        collectionView.reloadData()
        nobTitleButton.setTitle(nobTitle, for: .normal)
        nobTitleButton.titleLabel?.font = nobTitleFont
        
        nobIconImageView.image = nobImage
        selecterView.updateSelectorUI(selectorImage, textColor: selectorTextColor, font: itemFont)
        updateSelectedValue()
    }
    
    private func findCenterIndex() -> Int? {
        let center = self.convert(collectionView.center, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: center) {
            return indexPath.row
        }
        return nil
    }
    
    private func updateSelectedValue(_ index: Int = 0) {
        selectedIndex = index
        if let items = itemArray, items.count > index {
            selecterView.updateValue(items[index])
        }
    }
    // For Internal half circle
    override func draw(_ rect: CGRect) {
        
        let radius:CGFloat = self.frame.size.width - 10
        
        let circleColorPath = UIBezierPath(arcCenter: CGPoint.init(x: 0, y: self.bounds.midY), radius: radius, startAngle: CGFloat(-90).degreesToRadians, endAngle: CGFloat(90).degreesToRadians, clockwise: true)
        arcBackgroundColor.setFill()
        circleColorPath.fill()
    }
    
    @objc func onTitleButtonClick(_ sender: UIButton) {
        if let handler = callBack {
            let stringValue = ((itemArray?.count ?? 0 > selectedIndex) ? itemArray?[selectedIndex] : "") ?? ""
            handler(selectedIndex, stringValue)
        }
    }
}

extension CircularMenuView: UICollectionViewDataSource, UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray?.count ?? 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as? CircularMenuCell else {
            return UICollectionViewCell()
        }
        cell.titleLbl?.font = itemFont
        cell.titleLbl?.textColor = itemsTextColor
        if let items = itemArray, items.count > indexPath.row {
            cell.titleLbl?.text = items[indexPath.row]
        }
        return cell
    }
}

extension CircularMenuView {
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let index = findCenterIndex() {
            updateSelectedValue(index)
        }
    }
}
