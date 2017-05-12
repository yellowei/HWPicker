//
//  ImageDataAPI.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit
import Photos

class ImageDataAPI: NSObject {
    

    ///MARK: - 单例
    static let sharedInstance = ImageDataAPI()
    
    //MARK: - 属性
    var phManager: PHSourceManager?
    
    ///重写INIT
    override init() {
        
        phManager = PHSourceManager()
        
        super.init()
    }
    
    //MARK: - 公开方法
    func getMomentsWithBatchReturn(batch: Bool, ascending: Bool, completion: ((_ done: Bool?, _ obj: Any?)->())) -> () {
        if IS_IOS8 {
            phManager?.getMomentsWithAscending(ascending: ascending, completion: { (ret, obj) in
                completion(ret, obj)
            })
        }
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - asset: <#asset description#>
    ///   - size: <#size description#>
    ///   - completion: <#completion description#>
    func getThumbnailForAssetObj(asset: PHAsset, size: CGSize, completion: @escaping ((_ ret: Bool?, _ image: UIImage?)->())) -> () {
        
        if IS_IOS8{
            self.phManager?.getThumbnailForAssetObj(asset: asset, size: size, deliveryMode: PHImageRequestOptionsDeliveryMode.opportunistic, completion: { (ret, image) in
                completion(ret, image)
            })
        }
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - asset: <#asset description#>
    ///   - completion: <#completion description#>
    func getURLForAssetObj(asset: PHAsset, completion: @escaping ((_ ret: Bool?, _ url: URL?)->())) -> () {
        if IS_IOS8{
            self.phManager?.getURLForPHAsset(asset: asset, completion: { (ret, url) in
                completion(ret, url)
            })
        }
    }
    
    
    func getAlbumsWith(completion: ((_ ret: Bool?, _ obj: Any?)->())) -> () {
        
        if IS_IOS8{
            self.phManager.get
        }
    }
}
