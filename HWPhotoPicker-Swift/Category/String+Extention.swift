//
//  String+Extention.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/26.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit

extension String {

    static func commonSize(with text: String?, fontNum: CGFloat, size: CGSize) -> (CGSize) {
        
        guard let text = text as NSString? else {
            return CGSize.zero
        }
        
        let font = UIFont.systemFont(ofSize: fontNum)
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size;
    }
    
    static func commonSizeAutoWidth(with text: String?, fontNum: CGFloat, textHeigth: CGFloat) -> (CGSize) {
        
        guard let text = text as NSString? else {
            return CGSize.zero
        }
        
        let size = CGSize(width: CGFloat(MAXFLOAT), height: textHeigth)
        let font = UIFont.systemFont(ofSize: fontNum)
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size;
    }
    
    static func commonSizeAutoHeight(with text: String?, fontNum: CGFloat, textWidth: CGFloat) -> (CGSize) {
        
        guard let text = text as NSString? else {
            return CGSize.zero
        }
        
        let size = CGSize(width: textWidth, height: CGFloat(MAXFLOAT))
        let font = UIFont.systemFont(ofSize: fontNum)
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size;
    }

}
