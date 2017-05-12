//
//  PHSourceManager.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit
import Photos

class PHSourceManager: NSObject {
    
    var manager: PHImageManager?
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - ascending: <#ascending description#>
    ///   - completion: <#completion description#>
    func getMomentsWithAscending(ascending: Bool, completion: ((_ ret: Bool?, _ obj: Any?)->())) -> () {
        
        let options: PHFetchOptions = PHFetchOptions()
        
        options.sortDescriptors = [NSSortDescriptor.init(key: "endDate", ascending: ascending)]
        
        let momentRes: PHFetchResult = PHAssetCollection.fetchMoments(with: options)
        
        var momArray: [Any] = []

        for i in 0 ..< momentRes.count {
            
            guard let collection: PHAssetCollection = momentRes.object(at: i),
                  let endDate = collection.endDate
                  else { return }
            
            let unitFlags = Set<Calendar.Component>([.day, .month, .year])
            let components: DateComponents = Calendar.current.dateComponents(unitFlags, from: endDate)
            
            guard let year = components.year,
                  let month = components.month,
                  let day = components.day
                else {
                    continue
            }
        
        
            let moment = MomentCollection()
            moment.month = month
            moment.year = year
            moment.day = day
            
            let option: PHFetchOptions = PHFetchOptions()
            option.predicate = NSPredicate.init(format: "mediaType = %d", PHAssetMediaType.image as! CVarArg)
            moment.assetObjs = PHAsset.fetchKeyAssets(in: collection, options: option)
            if ((((moment.assetObjs) as? [Any])?.count) ?? 0) > 0 {
                momArray.append(moment)
            }
        }
        completion(true, nil)
    }
    
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - asset: <#asset description#>
    ///   - size: <#size description#>
    ///   - deliveryMode: <#deliveryMode description#>
    ///   - completion: <#completion description#>
    func getThumbnailForAssetObj(asset: PHAsset, size: CGSize, deliveryMode: PHImageRequestOptionsDeliveryMode, completion: @escaping ((_ ret: Bool?, _ image: UIImage?)->())) -> (){
        
        var options = PHImageRequestOptions()
        
        options.resizeMode = PHImageRequestOptionsResizeMode.fast
        
        options.deliveryMode = deliveryMode
        
        var a = asset
        
        var w = a.pixelWidth > a.pixelHeight ? a.pixelHeight : a.pixelWidth
        
        if w > 100{
            w = 100
        }
        
        let rect = CGRect(x: 0, y: 0, width: w, height: w)
        
        options.normalizedCropRect = rect
        
        options.isSynchronous = false
        
        let scale = UIScreen.main.scale
        
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        self.manager?.requestImage(for: asset,
                             targetSize: newSize,
                            contentMode: PHImageContentMode.aspectFill,
                                options: options,
                                resultHandler: { (resutl: UIImage?, info: [AnyHashable : Any]?) in
                                    completion(resutl != nil, resutl)
        })
        
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - asset: <#asset description#>
    ///   - completion: <#completion description#>
    func getURLForPHAsset(asset: PHAsset, completion: @escaping ((_ ret: Bool?, _ url: URL?)->())) -> () {
        asset.requestContentEditingInput(with: nil) { (contentEditingInput, info) in
            let imageUrl = contentEditingInput?.fullSizeImageURL
            completion(true, imageUrl)
        }
    }
    
    
    func getAlbumsWith(completion: ((_ ret: Bool?, _ obj: Any?)->())) -> () {
        
        
    }
    
}

