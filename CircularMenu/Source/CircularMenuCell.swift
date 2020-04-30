//
//  CircularMenuCell.swift
//  ImageTextOverlay
//
//  Created by Surjeet on 29/04/20.
//  Copyright © 2020 Surjeet. All rights reserved.
//

import UIKit

class CircularMenuCell: UICollectionViewCell {
    
    public var titleLbl: UILabel?
    public var font = UIFont.systemFont(ofSize: 18)
    public var textColor: UIColor = .black
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }
    
    func setUpUI() {
        titleLbl = UILabel.init(frame: .zero)
        titleLbl?.font = font
        titleLbl?.textAlignment = .center
        titleLbl?.textColor = textColor
        titleLbl?.backgroundColor = .clear
        self.addSubview(titleLbl!)
        titleLbl?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLbl!.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            titleLbl!.leftAnchor.constraint(equalTo: self.leftAnchor),
            titleLbl!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            titleLbl!.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
}
