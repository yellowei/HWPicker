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
    
    
    /// <#Description#>
    ///
    /// - Parameter completion: completion description
    func getAlbumsWith(completion: ((_ ret: Bool?, _ obj: Any?)->())) -> () {
        
        if IS_IOS8{
            self.phManager?.getAlbumsWith(completion: { (ret, obj) in
                completion(ret, obj)
            })
        }
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - album: <#album description#>
    ///   - completion: <#completion description#>
    func getPosterImageForAlbumObj(album: AlbumObj, completion: @escaping ((_ ret: Bool?, _ obj: Any?)->())) -> () {
        
        if IS_IOS8 {
            
            self.phManager?.getPosterImageForAlbumObj(album: album, completion: { (ret, obj) in
                
                completion(ret, obj)
            })
        }
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - group: <#group description#>
    ///   - completion: <#completion description#>
    func getPhotosWith(group: AlbumObj, completion: ((_ ret: Bool?, _ obj: Any?)->())) -> () {
        
        if IS_IOS8 {
            
            self.phManager?.getPhotosWith(group: group, completion: { (ret, obj) in
                
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
    func getImageForPhotoObj(asset: PHAsset, size: CGSize, completion: @escaping ((_ ret: Bool?, _ obj: Any?)->())) -> () {
        
        if IS_IOS8 {
            
            self.phManager?.getImageForPHAsset(asset: asset, size: size, completion: { (ret, image) in
                completion(ret, image)
            })
        }
    }
    
    
    func canAccessInPhotos() -> (Bool) {
        
        if IS_IOS8 {
            
            return (self.phManager?.canAccessInPhotos()) ?? false
        }
        else{
            return false;
        }
    }
    
}
