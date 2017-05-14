//
//  AlbumObj.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

class AlbumObj: NSObject {
    
    var name: String?
    var posterImage: UIImage?
    var count: Int = 0
    var type: Int = 0
    
    private var fetRes: PHFetchResult<AnyObject>?
    
   
    
    var collection: PHFetchResult<AnyObject>?

}
