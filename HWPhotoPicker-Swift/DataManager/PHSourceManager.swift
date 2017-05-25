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
    
    var manager: PHImageManager
    
    override init() {
    
        manager = PHImageManager()
        
        super.init()
    }
    
    
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
            
            guard let collection = momentRes.object(at: i) as? PHAssetCollection,
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
            option.predicate = NSPredicate.init(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
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
        
        let options = PHImageRequestOptions()
        
        options.resizeMode = PHImageRequestOptionsResizeMode.fast
        
        options.deliveryMode = deliveryMode
        
        let a = asset
        
        var w = a.pixelWidth > a.pixelHeight ? a.pixelHeight : a.pixelWidth
        
        if w > 100{
            w = 100
        }
        
        let rect = CGRect(x: 0, y: 0, width: w, height: w)
        
        options.normalizedCropRect = rect
        
        options.isSynchronous = false
        
        let scale = UIScreen.main.scale
        
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        self.manager.requestImage(for: asset,
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
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - album: <#album description#>
    ///   - completion: <#completion description#>
    func getPosterImageForAlbumObj(album: AlbumObj, completion: @escaping ((_ ret: Bool?, _ obj: Any?)->())) -> () {
        
        if let asset = (album.collection?.lastObject) as? PHAsset {
        
            self.getThumbnailForAssetObj(asset: asset,
                                         size: CGSize(width: 180, height: 180),
                                         deliveryMode: PHImageRequestOptionsDeliveryMode.opportunistic)
            { (ret, image) in
                
                completion(ret, image)
                
            }
        }
    }
    
    
    /// <#Description#>
    ///
    /// - Parameter completion: <#completion description#>
    func getAlbumsWith(completion: ((_ ret: Bool?, _ obj: Any?)->())) -> () {
        
        var tmpAry = [Any]()
        
        let option = PHFetchOptions()
        option.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        option.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        
        let cameraRo = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.smartAlbumUserLibrary, options: nil)
        
        if let colt = cameraRo.lastObject {
            
            let fetchR = PHAsset.fetchAssets(in: colt, options: option)
            
            let obj = AlbumObj()
            obj.type = PHAssetCollectionSubtype.smartAlbumUserLibrary.rawValue
            obj.name = colt.localizedTitle
            obj.count = fetchR.count
            obj.collection = fetchR as? PHFetchResult<AnyObject>
            if obj.count > 0 {
                
                tmpAry.append(obj)
                
                self.getPosterImageForAlbumObj(album: obj, completion: { (ret, object) in
                    obj.posterImage = object as? UIImage
                })
            }
        }
        
        let tp = PHAssetCollectionSubtype.init(rawValue: PHAssetCollectionSubtype.albumRegular.rawValue | PHAssetCollectionSubtype.albumSyncedAlbum.rawValue) ?? PHAssetCollectionSubtype.albumRegular
        let albums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album,
                                                             subtype: tp,
                                                             options: nil)
        
        for i in 0..<albums.count {
            
            let col = albums.object(at: i)
            
            let fRes = PHAsset.fetchAssets(in: col, options: option)
            
            let obj = AlbumObj()
            obj.name = col.localizedTitle
            obj.collection = fRes as? PHFetchResult<AnyObject>
            obj.count = fRes.count
            
            if fRes.count > 0 {
                
                tmpAry.append(obj)
                
                self.getPosterImageForAlbumObj(album: obj, completion: { (ret, object) in
                    obj.posterImage = object as? UIImage
                })
                
            }
            
        }
        
        completion(true, tmpAry)
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - group: <#group description#>
    ///   - completion: <#completion description#>
    func getPhotosWith(group: AlbumObj, completion: ((_ ret: Bool?, _ obj: Any?)->())) -> () {
        
        var elements = [Any]()
        
        if let fetchResult = group.collection {
            
            for i in 0..<fetchResult.count {
                
                let photoObj = PhotoObj()
                photoObj.photoObj = fetchResult.object(at: i) as? PHAsset
                elements.append(photoObj)
            }
            
        }
        
        completion(true, elements)
    }
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - asset: <#asset description#>
    ///   - size: <#size description#>
    ///   - completion: <#completion description#>
    func getImageForPHAsset(asset: PHAsset, size: CGSize, completion: @escaping ((_ ret: Bool?, _ image: UIImage?)->())) -> () {
        
        let options = PHImageRequestOptions()
        
        options.isSynchronous = true
        
        self.manager.requestImage(for: asset,
                                  targetSize: size,
                                  contentMode: PHImageContentMode.aspectFill,
                                  options: options,
                                  resultHandler: { (result, info) in
            completion(true, result)
        })
    }
    
    
    func canAccessInPhotos() -> (Bool) {
        
        return ( PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.restricted &&
                 PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.denied )
    }
}

