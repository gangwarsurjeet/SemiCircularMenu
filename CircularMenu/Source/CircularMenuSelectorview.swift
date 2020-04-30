//
//  CircularMenuSelectorview.swift
//  ImageTextOverlay
//
//  Created by Surjeet on 29/04/20.
//  Copyright © 2020 Surjeet. All rights reserved.
//

import UIKit

class CircularMenuSelectorview: UIView {

    public var titleLbl = UILabel.init(frame: .zero)
    
    private var selectorImageView: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initContent()
    }
    
    private func initContent() {
        selectorImageView = UIImageView.init(frame: .zero)
        selectorImageView?.backgroundColor = UIColor.clear
        selectorImageView?.contentMode = .scaleToFill
    
        titleLbl.font = UIFont.systemFont(ofSize: 18)
        titleLbl.textAlignment = .center
        titleLbl.textColor = UIColor.black
        titleLbl.numberOfLines = 2
        titleLbl.backgroundColor = .clear
        self.addSubview(selectorImageView!)
        self.addSubview(titleLbl)
        
        selectorImageView?.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectorImageView!.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            selectorImageView!.leftAnchor.constraint(equalTo: self.leftAnchor),
            selectorImageView!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            selectorImageView!.rightAnchor.constraint(equalTo: self.rightAnchor),
            titleLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            titleLbl.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 5),
            titleLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            titleLbl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5)
        ])
    }
    
    public func updateSelectorUI(_ image: UIImage?, textColor: UIColor?, font: UIFont) {
        selectorImageView?.image = image
        if let color = textColor {
            titleLbl.textColor = color
        }
        titleLbl.font = font
    }
    
    public func updateValue(_ text: String) {
        titleLbl.text = text
    }
    
}
