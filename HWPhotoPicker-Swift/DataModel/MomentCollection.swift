//
//  MomentCollection.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit
import Photos

class MomentCollection: NSObject {

    var month: Int = 0
    var year: Int = 0
    var day: Int = 0
    
    private var assets: PHFetchResult<AnyObject>?
    
    var assetObjs: Any?{
        get{
            if IS_IOS8{
                return assets
            }
            else{
                return nil
            }
        }
        set{
            if IS_IOS8{
                assets = newValue as? PHFetchResult<AnyObject>
            }
            else{
                
            }
        }
        
    }
    
}
