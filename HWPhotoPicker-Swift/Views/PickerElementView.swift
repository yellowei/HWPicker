//
//  PickerElementView.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/17.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit

protocol PickerElementViewDelegate: NSObjectProtocol {
    
    func elementView(canSelected: Bool, elementView: PickerElementView)
    
    func elementViewDidChangeSelectionState(selectionState: Bool, elementView: PickerElementView)
    
    func elementViewShowBigImage(elementView: PickerElementView)
}

class PickerElementView: UIView {

    //MARK: - 私有属性
    var delegate: PickerElementViewDelegate?
    
    var selected: Bool = false
    
    var element: PhotoObj?
    
    var allowMultipleSelect: Bool = false
    
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
    
    
    //MARK: - Events
    @objc private func onSelectedClick(sender: UIButton?) {
        
    }
    
    @objc private func onSelfClick(sender: UITapGestureRecognizer?) {
        
    }
    
    setAllowsMultipleSelection

}
