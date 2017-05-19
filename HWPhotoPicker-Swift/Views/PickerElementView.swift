//
//  PickerElementView.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/17.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit

@objc protocol PickerElementViewDelegate: NSObjectProtocol {
    
    @objc optional func elementViewCanSelect(elementView: PickerElementView) -> (Bool)
    
    @objc optional func elementViewDidChangeSelectionState(selectionState: Bool, elementView: PickerElementView)
    
    @objc optional func elementViewShowBigImage(elementView: PickerElementView)
}

class PickerElementView: UIView {

    //MARK: - 私有属性
    var delegate: PickerElementViewDelegate?
    
    var selected: Bool{
        get{
            return self.overlayImageView.isSelected
        }
        set{
            self.overlayImageView.isSelected = newValue
        }
    }
    
    private var _element: PhotoObj?
    var element: PhotoObj?{
        get{
            return _element
        }
        set{
            _element = newValue
            
            self.thumbnail()
        }
    }
    
    private var _allowMultipleSelect = false
    var allowMultipleSelect: Bool {
        get{
            return _allowMultipleSelect
        }
        set{
            _allowMultipleSelect = newValue
            
            if _allowMultipleSelect {
                self.overlayImageView.isHidden = false
            }
            else{
                self.overlayImageView.isHidden = true
            }
        }
    }
    
    //MARK: - 公开属性
    private var imageView: UIImageView
    
    private var overlayImageView: UIButton
    
    private var videoInfoView: VideoElementInfoView
    
    private var thumbnailImage: UIImage?
    
    private var tintedThumbnailImage: UIImage?
    
    override init(frame: CGRect) {
        
        imageView = UIImageView()
        videoInfoView = VideoElementInfoView()
        overlayImageView = UIButton(type: .custom)
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        
        //imageView
        imageView.frame = self.bounds
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizingMask = kECAutoResizingMask
        self.addSubview(imageView)
        
        //videoInfoView
        videoInfoView.frame = CGRect(x: 0,
                                     y: self.bounds.size.height - 17,
                                     width: self.bounds.size.width,
                                     height: 17)
        videoInfoView.isHidden = true
        videoInfoView.autoresizingMask = UIViewAutoresizing.init(rawValue: (UIViewAutoresizing.flexibleTopMargin.rawValue | UIViewAutoresizing.flexibleWidth.rawValue))
        self.addSubview(videoInfoView)
        
        //Overlay image View
        overlayImageView.frame = CGRect(x: self.bounds.width - 25,
                                        y: 0,
                                        width: 25,
                                        height: 25)
        overlayImageView.contentMode = .scaleAspectFill
        overlayImageView.setBackgroundImage(UIImage.init(named: "photopicker_nor"), for: .normal)
        overlayImageView.setBackgroundImage(UIImage.init(named: "photopicker_sel"), for: .selected)
        overlayImageView.autoresizingMask = kECAutoResizingMask
        overlayImageView.clipsToBounds = true
        overlayImageView.addTarget(self, action: #selector(onSelectedClick(sender:)), for: .touchUpInside)
        self.addSubview(overlayImageView)
        
        //添加一个手势
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(onSelectedClick(sender:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: -私有方法
    private func thumbnail() {
        
        self.imageView.image = nil
        self.imageView.backgroundColor = UIColor.gray
        
        guard let photoObj = self.element?.photoObj else {
            return
        }
        ImageDataAPI.shared.getThumbnailForAssetObj(asset: photoObj, size: CGSize(width: 540, height: 540)) { [weak self] (ret, image) in
            self?.imageView.image = image
            self?.thumbnailImage = image
        }
    }
    
    private func tintedThumbnail() -> (UIImage?) {
        
        guard let guardTintedThumbnailImage = self.tintedThumbnailImage else {
            
            guard let thumbnail = self.thumbnailImage else {
                return nil
            }
            
            UIGraphicsBeginImageContext(thumbnail.size)
            
            let rect = CGRect(x: 0, y: 0, width: thumbnail.size.width, height: thumbnail.size.height)
            
            thumbnail.draw(in: rect)
            
            UIColor.init(white: 0, alpha: 0.5).set()
            
            UIRectFillUsingBlendMode(rect, .sourceAtop)
            
            let tintedThumbnail = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            self.tintedThumbnailImage = tintedThumbnail
            
            return tintedThumbnail
        }
        
        return guardTintedThumbnailImage
    }
    
    //MARK: - Events
    @objc private func onSelectedClick(sender: UIButton?) {
        
        if self.selected {
            
            self.selected = false
            
            if (self.delegate?.responds(to: #selector(PickerElementViewDelegate.elementViewDidChangeSelectionState(selectionState:elementView:))))! {
                
                self.delegate?.elementViewDidChangeSelectionState!(selectionState: self.selected, elementView: self)
            }
            
        }else{
            
            if (self.delegate?.elementViewCanSelect!(elementView: self))! {
                
                if (self.delegate?.responds(to: #selector(PickerElementViewDelegate.elementViewCanSelect(elementView:))))! {
                    
                    self.selected = true
                    self.delegate?.elementViewDidChangeSelectionState!(selectionState: self.selected, elementView: self)
                }
            }
        }
    }
    
    @objc private func onSelfClick(sender: UITapGestureRecognizer?) {
        
        if self.allowMultipleSelect {
            
            if (self.delegate?.responds(to: #selector(PickerElementViewDelegate.elementViewDidChangeSelectionState(selectionState:elementView:))))! {
                
                self.delegate?.elementViewShowBigImage!(elementView: self)
                
            }
        }else{
         
            self.imageView.image = self.tintedThumbnail()
            
            self.thumbnail()
            
            if (self.delegate?.responds(to: #selector(PickerElementViewDelegate.elementViewDidChangeSelectionState(selectionState:elementView:))))! {
                
                self.delegate?.elementViewDidChangeSelectionState!(selectionState: self.selected, elementView: self)
                
            }
            
        }
    }
    

}
