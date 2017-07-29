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
        
        
        
        let backView = UIView.init(frame: CGRect(x: 10, y: 5, width: 75, height: 75))
        backView.layer.cornerRadius = 4
        let borderColor = UIColor.init(colorLiteralRed: Float(0xec)/255.0, green: Float(0xec)/255.0, blue: Float(0xec)/255.0, alpha: 1)
        backView.layer.borderColor = borderColor.cgColor
        backView.layer.borderWidth = 0.5
        photoImageView = UIImageView.init(frame: CGRect(x: 3, y: 3, width: 69, height: 69))
        backView.addSubview(photoImageView)
        
        
        titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.init(colorLiteralRed: 37.0/255.0, green: 37.0/255.0, blue: 37.0/255.0, alpha: 1)
        titleLabel.highlightedTextColor = UIColor.white
        titleLabel.autoresizingMask = kECAutoResizingMask
        
        
        countLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        countLabel.font = UIFont.systemFont(ofSize: 15)
        countLabel.textColor = UIColor.init(white: 0.498, alpha: 1.0)
        countLabel.highlightedTextColor = UIColor.white
        countLabel.autoresizingMask = kECAutoResizingMask
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundView?.backgroundColor = UIColor.init(colorLiteralRed: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1)
        
        contentView.addSubview(backView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        accessoryType = .disclosureIndicator

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func contentAutoSizeWithText(text: String, boundSize: CGSize, font: UIFont) -> (CGSize) {
        
        var size: CGSize = CGSize(width: 0, height: 0)
        
        let nsText = text as NSString
        
        if IS_IOS7, nsText.length > 0 {
            
            let tdic = ["\(NSFontAttributeName)": font]
            let options = NSStringDrawingOptions.init(rawValue: (NSStringDrawingOptions.truncatesLastVisibleLine.rawValue | NSStringDrawingOptions.usesLineFragmentOrigin.rawValue))
            size = nsText.boundingRect(with: boundSize, options: options, attributes: tdic, context: nil).size
        }
        
        return size
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        contentView.frame = self.bounds
        
        let width = self.contentView.bounds.size.width - 20
        
        let height = self.contentView.bounds.size.height
        
        let imageViewSize = CGSize(width: height - 1, height: height - 1)
        
        var titleTextSize = self.contentAutoSizeWithText(text: titleLabel.text ?? "", boundSize: CGSize(width: CGFloat(MAXFLOAT), height: 20), font: titleLabel.font)
        if titleTextSize.width > width {
            titleTextSize.width = width
        }
        
        var countTextSize = self.contentAutoSizeWithText(text: countLabel.text ?? "", boundSize: CGSize(width: CGFloat(MAXFLOAT), height: 20), font: countLabel.font)
        
        if countTextSize.width > width {
            countTextSize.width = width
        }
        
        var countLabelFrame: CGRect
        var titleLabelFrame: CGRect
        
        if (titleTextSize.width + countTextSize.width + 10) > width {
            
            titleLabelFrame = CGRect(x: imageViewSize.width + 10, y: 0, width: width - countTextSize.width - 10, height: imageViewSize.height);
            
            countLabelFrame = CGRect(x: titleLabelFrame.origin.x + titleLabelFrame.size.width + 2, y: 0, width: countTextSize.width, height: imageViewSize.height)
            
        } else {
            
            titleLabelFrame = CGRect(x: imageViewSize.width + 10, y: 0, width: titleTextSize.width, height: imageViewSize.height);
            
            countLabelFrame = CGRect(x: titleLabelFrame.origin.x + titleLabelFrame.size.width + 2, y: 0, width: countTextSize.width, height: imageViewSize.height)
        }
        
        titleLabel.frame = titleLabelFrame
        countLabel.frame = countLabelFrame
    }
    
}
