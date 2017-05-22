//
//  HWShowImageView.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/22.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit
import Photos
import MBProgressHUD

class HWShowImageView: UIScrollView, UIScrollViewDelegate {

    //MARK: - 私有属性
    private var imageView: UIImageView
    private var customerHUD: MBProgressHUD?
    private var dataImage: UIImage?
    private var activityIndicatorView: UIActivityIndicatorView?
    private var singleTaps: UITapGestureRecognizer?
    private var netLabel: UILabel?
    
    
    //MARK: - 公开属性
    var image: UIImage?
    var imageData: Any?
    
    ///逆向传值闭包
    var singleTapBlock: ((_ tap: UITapGestureRecognizer) -> ())?
    var saveResultBlock: ((_ result: Error?) -> ())?
    
    
    //MARK: - 生命周期方法
    override init(frame: CGRect) {
        
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kECScreenWidth, height: frame.size.height))
        
        super.init(frame: frame)
        //设置缩放倍数
        self.maximumZoomScale = 3.0
        self.minimumZoomScale = 0.5
        
        //设置滚动条隐藏
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.isPagingEnabled = false
        self.bouncesZoom = false
        
        //设置代理
        self.delegate = self as? UIScrollViewDelegate
        
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = false
        
        self.clipsToBounds = false
        imageView.clipsToBounds = false
        self.autoresizingMask = kECAutoResizingMask
        self.addSubview(imageView)
        
        //设置点击手势来放大和缩小图片
        let doubleTap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(tap:)))
        doubleTap.delegate = self as? UIGestureRecognizerDelegate
        doubleTap.numberOfTapsRequired = 2
        
        //单击移除
        singleTaps = UITapGestureRecognizer.init(target: self, action: #selector(onTouch(tap:)))
        self.singleTaps?.numberOfTapsRequired = 1
        self.singleTaps?.require(toFail: doubleTap)
        
        self.addGestureRecognizer(self.singleTaps!)
        imageView.addGestureRecognizer(doubleTap)
        
        self.zoomScale = 0.99
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Events
    @objc private func tapAction(tap: UITapGestureRecognizer) {
        
    }
    
    @objc private func onTouch(tap: UITapGestureRecognizer) {
    
    }
    
    
    //MARK: - 公开方法
    func saveImageData() {
        
        if self.dataImage != nil {
            
            UIImageWriteToSavedPhotosAlbum(self.dataImage!, self, #selector(didFinishSavingWith(error:contextInfo:)), nil)
            if self.activityIndicatorView != nil {
                
                self.activityIndicatorView?.stopAnimating()
                self.activityIndicatorView?.isHidden = true
            }
            
        }else {
            
            if self.activityIndicatorView == nil {
                
                self.activityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
                let size = self.activityIndicatorView?.frame.size ?? CGSize.zero
                self.activityIndicatorView?.frame = CGRect(x: (self.frame.width - size.width) / 2,
                                                           y: (self.frame.height - size.height) / 2,
                                                           width: size.width,
                                                           height: size.height)
                self.activityIndicatorView?.isHidden = true
                self.addSubview(self.activityIndicatorView!)
            }
            self.activityIndicatorView?.isHidden = false
            self.activityIndicatorView?.startAnimating()
        }
    }
    
    func setImageData(newValue: Any?) {
        
        guard let newValue = newValue else {
            return
        }
        
        self.imageData = newValue
        
        if let imageData = self.imageData as? Dictionary<String, Any> {
            
            guard let data = imageData["data"] as? Data else {
                return
            }
            
            let tempImage = UIImage.init(data: data)
            self.dataImage = tempImage
            imageView.image = tempImage
        }
        else if let imageData = self.imageData as? URL {
            
            
        }
        else if let imageData = self.imageData as? UIImage {
            
            
        }
        else if let imageData = self.imageData as? PhotoObj {
            
            guard let guardPHAsset = imageData.photoObj else {
                return
            }
            
            ImageDataAPI.shared.getImageForPhotoObj(asset: guardPHAsset, size: (IS_IOS8 ? PHImageManagerMaximumSize : CGSize.zero), completion: { [weak self](ret, image) in
                
                self?.dataImage = image as? UIImage
                self?.imageView.image = image as? UIImage
            })
        }
    }
    
    //MARK: - 私有方法
    @objc private func didFinishSavingWith(error: Error, contextInfo: Any) {
        
        if (self.saveResultBlock != nil) {
            self.saveResultBlock!(error)
        }
    }
    
    
    
    private func showCustomWaiting(title: String?, subTitle: String?) {
        let width: CGFloat = 180.0
        let height: CGFloat = 120.0
        var labStr_1, labStr_2: String
        
        if ((title as NSString?)?.length ?? 0) <= 0 {
            labStr_1 = "正在努力加载中"
        }
        else {
            labStr_1 = String.init(stringLiteral: title!)
        }
        
        if ((subTitle as NSString?)?.length ?? 0) <= 0 {
            labStr_2 = "请稍候..."
        }
        else {
            labStr_2 = String.init(stringLiteral: subTitle!)
        }
        
        if customerHUD == nil {
            
            customerHUD = MBProgressHUD.init(view: UIApplication.shared.keyWindow!)
            customerHUD?.backgroundColor = UIColor.init(white: 0.0, alpha: 0.5)
            customerHUD?.bezelView.color = UIColor.white
            customerHUD?.bezelView.layer.cornerRadius = 4.0
            customerHUD?.mode = MBProgressHUDMode.customView
            customerHUD?.removeFromSuperViewOnHide = true
            UIApplication.shared.keyWindow?.addSubview(customerHUD!)
        }
        
        let customView = UIView.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        customView.backgroundColor = UIColor.white
        
        let imgView = UIImageView.init(frame: CGRect(x: width / 2 - 20, y: 10, width: 40, height: 40))
        imgView.image = UIImage.init(named: "icon_common_waiting")
        customView.addSubview(imgView)
        
        var rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = M_PI * 2.0
        rotationAnimation.duration = 1
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = MAXFLOAT
        imgView.layer.add(rotationAnimation, forKey: "rotationAnimation")
        
        let label_1 = UILabel.init(frame: CGRect(x: width / 2.0 - 80, y: 60, width: 160, height: 30))
        label_1.font = UIFont.systemFont(ofSize: 18.0)
        label_1.text = labStr_1
        label_1.textAlignment = NSTextAlignment.center
        label_1.textColor = UIColor.gray
        customView.addSubview(label_1)
        
        let label_2 = UILabel.init(frame: CGRect(x: width / 2.0 - 60, y: 90, width: 120, height: 20))
        label_2.font = UIFont.systemFont(ofSize: 14.0)
        label_2.text = labStr_2
        label_2.textAlignment = NSTextAlignment.center
        label_2.textColor = UIColor.init(white: 0, alpha: 0.3)
        customView.addSubview(label_2)
        
        customerHUD?.customView = customView
        
        customerHUD?.show(animated: true)
        
    }
    
    private func showSimpleWating() {
        
        self.showCustomWaiting(title: nil, subTitle: nil)
    }
    
    private func hideWating() {
        
        if customerHUD != nil {
            
            customerHUD?.hide(animated: true)
            customerHUD = nil
        }
    }
    
    //MARK: - UIScrollViewDelegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let ws = scrollView.frame.size.width - scrollView.contentInset.left - scrollView.contentInset.right
        let hs = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let w = self.imageView.frame.size.width
        let h = self.imageView.frame.size.height
        
        var rct = self.imageView.frame
        
        rct.origin.x = max((ws - w) / 2.0, 0)
        rct.origin.y = max((hs - h) / 2.0, 0)
        self.imageView.frame = rct
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        let rct = self.imageView.frame
        
        if self.zoomScale == 1 {
            
            scrollView.zoomScale = 0.99
        }
        
        if rct.size.width < kECScreenWidth - 8 {
            
            UIView.animate(withDuration: 0.35, animations: { 
                scrollView.zoomScale = 0.99
            })
            
        }else if rct.size.height < kECScreenHeight - 8 {
            
            UIView.animate(withDuration: 0.35, animations: { 
                scrollView.zoomScale = 0.99
            })
        }
    }
}
