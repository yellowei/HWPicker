//
//  Common.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit
import Foundation

let IS_IOS7 = (UIDevice.current.systemVersion as NSString).doubleValue >= 7.0
let IS_IOS8 = (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0

let kECScreenWidth = UIScreen.main.bounds.size.width
let kECScreenHeight = UIScreen.main.bounds.size.height

let kECAutoResizingMask = UIViewAutoresizing.init(rawValue: (UIViewAutoresizing.flexibleWidth.rawValue | UIViewAutoresizing.flexibleHeight.rawValue))
