//
//  UIColor+Extension.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit

extension UIColor{
    
    
    /// 16进制色彩转RGB色彩
    ///
    /// - Parameter hex: 16进制参数
    /// - Returns: RGB UIColor
    class func color(hex: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((hex & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(hex & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
    
}
