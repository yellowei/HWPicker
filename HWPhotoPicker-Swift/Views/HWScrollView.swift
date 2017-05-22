//
//  HWScrollView.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/22.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit

@objc protocol HWScrollViewDelegate: NSObjectProtocol {
    
    @objc optional func endHiddenAnimation(scrollView: HWScrollView, isHide: Bool)
    
    @objc optional func scrollToNextStateWithIndex(leftIndex: Int, middleIndex: Int, rightIndex: Int)
}

class HWScrollView: UIView, UIScrollViewDelegate {

    //MARK: - 公开属性
    var delegate: HWScrollViewDelegate?
    
    
    //MARK: - 私有属性
    private var imageDatasArray: [Any]?
    private var _mainScrollView: UIScrollView
    private var SELFWIDTH: CGFloat
    private var SELFHEIGHT: CGFloat
    private let WIDTH: CGFloat = UIScreen.main.bounds.size.width
    private let HEIGHT: CGFloat = UIScreen.main.bounds.size.height
    
    
    private var _count: Int = 0
    private var current_page: Int = 0
    private var left_page: Int = 0
    private var right_page: Int = 0
    private var _scrollCurrentIndex: Int = 1
    
    
    //MARK: - 生命周期方法
    override init(frame: CGRect) {
        
        SELFWIDTH = 0.0
        SELFHEIGHT = 0.0
        _mainScrollView = UIScrollView(frame: frame)
        
        super.init(frame: frame)
        
        SELFWIDTH = self.bounds.size.width
        SELFHEIGHT = self.bounds.size.height
        
        _mainScrollView.isPagingEnabled = true
        _mainScrollView.delegate = self as? UIScrollViewDelegate
        _mainScrollView.contentSize = CGSize(width: SELFWIDTH * 3, height: SELFHEIGHT)
        _mainScrollView.bounces = false
        _mainScrollView.showsHorizontalScrollIndicator = false
        self.addSubview(_mainScrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 公开方法
    func startWith(imageArray: [Any]?, currentIndex: Int) {
        
        guard let count = imageArray?.count else {
            return
        }
        
        if count > 0
        {
         
            self.imageDatasArray = imageArray
            
            self._count = count
            
            self.current_page = currentIndex
            self.left_page = self.current_page - 1 < 0 ? (count - 1) : (self.current_page - 1)
            self.right_page = self.current_page + 1 < count ? (self.current_page + 1) : 0
            
            self.alpha = 0.0
            
            if count <= 1 {
                
                _mainScrollView.isScrollEnabled = false
                
            }else {
                
                _mainScrollView.isScrollEnabled = true
            }
        }
        
        self.loadImageDatasPage()
    }
    
    
    
    //MARK: - 私有方法
    private func loadImageDatasPage() {
        
        for view in _mainScrollView.subviews {
            view.removeFromSuperview()
        }
        
        _scrollCurrentIndex = 1
        
        //Current Page
        let currentImageView = HWShowImageView.init(frame: CGRect(x: WIDTH, y: 0, width: WIDTH, height: HEIGHT))
        currentImageView.setImageData(newValue: self.imageDatasArray?[current_page])
        _mainScrollView.addSubview(currentImageView)
        currentImageView.singleTapBlock = {[weak self]tap in
        
            UIView.animate(withDuration: 0.25, animations: { 
                if self?.delegate?.responds(to: #selector(HWScrollViewDelegate.endHiddenAnimation(scrollView:isHide:))) ?? false {
                
                    self?.delegate?.endHiddenAnimation!(scrollView: self!, isHide: true)
                }
            })
        }
        
        //Left Page
        let leftImageView = HWShowImageView.init(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        leftImageView.setImageData(newValue: self.imageDatasArray?[current_page])
        _mainScrollView.addSubview(leftImageView)
        
        //Right Page
        let rightImageView = HWShowImageView.init(frame: CGRect(x: WIDTH * 2.0, y: 0, width: WIDTH, height: HEIGHT))
        rightImageView.setImageData(newValue: self.imageDatasArray?[current_page])
        _mainScrollView.addSubview(rightImageView)
        
        _mainScrollView.setContentOffset(CGPoint(x: self.frame.size.width, y: 0), animated: false)
        
    }
    
    //MARK: - UIScrollViewDelegate
    
    
}
