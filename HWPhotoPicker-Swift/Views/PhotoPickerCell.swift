//
//  PhotoPickerCell.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/12.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit

class PhotoPickerCell: UITableViewCell {

    var photoImageView: UIImageView
    
    var titleLabel: UILabel
    
    var countLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        backgroundView?.backgroundColor = UIColor.init(colorLiteralRed: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1)
        
        let backView = UIView.init(frame: CGRect(x: 10, y: 5, width: 75, height: 75))
        backView.layer.cornerRadius = 4
        let borderColor = UIColor.init(colorLiteralRed: Float(0xec)/255.0, green: Float(0xec)/255.0, blue: Float(0xec)/255.0, alpha: 1)
        backView.layer.borderColor = borderColor.cgColor
        backView.layer.borderWidth = 0.5
        photoImageView = UIImageView.init(frame: CGRect(x: 3, y: 3, width: 69, height: 69))
        backView.addSubview(photoImageView)
        contentView.addSubview(backView)
        
        titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.init(colorLiteralRed: 37.0/255.0, green: 37.0/255.0, blue: 37.0/255.0, alpha: 1)
        titleLabel.highlightedTextColor = UIColor.white
        titleLabel.autoresizingMask = kECAutoResizingMask
        contentView.addSubview(titleLabel)
        
        countLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        countLabel.font = UIFont.systemFont(ofSize: 15)
        countLabel.textColor = UIColor.init(white: 0.498, alpha: 1.0)
        countLabel.highlightedTextColor = UIColor.white
        countLabel.autoresizingMask = kECAutoResizingMask
        contentView.addSubview(countLabel)
        
        accessoryType = .disclosureIndicator
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    
    func contentAutoSizeWithText(text: String, boundSize: CGSize, font: UIFont) -> (CGSize) {
        
        
    }
    
}
