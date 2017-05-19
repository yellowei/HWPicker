//
//  MultiPickerCell.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/15.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit

@objc protocol MultiPickerCellDelegate: NSObjectProtocol {
    
    @objc optional func canSelectElementAtIndex(pickerCell: MultiPickerCell, elementIndex: Int) -> (Bool)
    
    @objc optional func didChangeElementSeletionState(pickerCell: MultiPickerCell, isSelected: Bool,atIndex: Int)
    
    @objc optional func showBigImageWith(imageIndex: Int, pickerCell: MultiPickerCell)

}


class MultiPickerCell: UITableViewCell, PickerElementViewDelegate {
    
    private let PICKER_ELEMENT_VIEW_TAG = 1
    
    ///MultiPickerCellDelegate
    var delegate: MultiPickerCellDelegate?
    
    ///是否可多选
    private var _allowsMultipleSelection: Bool = false
    var allowsMultipleSelection: Bool{
        get{
            return _allowsMultipleSelection
        }
        set{
            _allowsMultipleSelection = newValue
            
            for subView in self.contentView.subviews {
                
                if subView.isMember(of: PickerElementView.self) {
                    
                    (subView as? PickerElementView)?.allowMultipleSelect = _allowsMultipleSelection
                }
            }
        }
    }
    
    ///
    private var _elements:[PhotoObj] = [PhotoObj]()
    var elements: [PhotoObj]{
        get{
            return _elements
        }
        set{
            _elements = newValue
            
            for i in 0..<self.numberOfElements {
                
                guard let elementView = self.contentView.viewWithTag(PICKER_ELEMENT_VIEW_TAG + i) as? PickerElementView else {
                    continue
                }
                
                if i < self.elements.count {
                    
                    elementView.isHidden = false
                    elementView.element = _elements[i]
                }else{
                    
                    elementView.isHidden = true
                }
            }
        }
    }
    
    ///图像Size
    var imageSize: CGSize = CGSize(width: 0, height: 0)
    
    ///
    var numberOfElements: Int = 0
    
    ///
    var margin: CGFloat = 0.0
    
    
    init?(style: UITableViewCellStyle, reuseIdentifier: String, imageSize: CGSize, numberOfAssets: Int, margin: CGFloat) {
        
        self.imageSize = imageSize
        
        self.numberOfElements = numberOfAssets
        
        self.margin = margin
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addElementsViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 私有方法
    private func addElementsViews(){
        
        for subView in self.contentView.subviews {
            
            if subView.isKind(of: PickerElementView.self) {
                
                subView.removeFromSuperview()
            }
        }
        
        for i in 0..<self.numberOfElements {
            
            let offset = (self.margin + self.imageSize.width) * CGFloat(i)
            
            let elementViewFrame = CGRect(x: offset + self.margin, y: self.margin, width: self.imageSize.width, height: self.imageSize.height)
            
            let elementView = PickerElementView.init(frame: elementViewFrame)
            elementView.delegate = self as? PickerElementViewDelegate
            elementView.tag = PICKER_ELEMENT_VIEW_TAG + i
            elementView.autoresizingMask = UIViewAutoresizing.init(rawValue: 0)
            
            self.contentView.addSubview(elementView)
        }
        
    }
    
    
    //MARK: - 公开方法
    func selectElementAtIndex(index: Int) {
        
        let elementView = self.contentView.viewWithTag(PICKER_ELEMENT_VIEW_TAG + index) as? PickerElementView
        elementView?.selected = true
    }
    
    func deselectElementAtIndex(index: Int) {
        
        let elementView = self.contentView.viewWithTag(PICKER_ELEMENT_VIEW_TAG + index) as? PickerElementView
        elementView?.selected = false
    }
    
    //MARK: - PickerElementViewDelegate
    func elementViewCanSelect(elementView: PickerElementView) -> (Bool) {
        
        if (self.delegate?.responds(to: #selector(MultiPickerCellDelegate.canSelectElementAtIndex(pickerCell:elementIndex:))))! {
            
            return (self.delegate?.canSelectElementAtIndex!(pickerCell: self, elementIndex: elementView.tag - PICKER_ELEMENT_VIEW_TAG))!
        }
        return false
    }
    
    func elementViewDidChangeSelectionState(selectionState: Bool, elementView: PickerElementView) {
        
        if (self.delegate?.responds(to: #selector(MultiPickerCellDelegate.didChangeElementSeletionState(pickerCell:isSelected:atIndex:))))! {
            
            self.delegate?.didChangeElementSeletionState!(pickerCell: self, isSelected: selectionState, atIndex: elementView.tag - PICKER_ELEMENT_VIEW_TAG)
        }
    }
    
    func elementViewShowBigImage(elementView: PickerElementView) {
        
        if (self.delegate?.responds(to: #selector(MultiPickerCellDelegate.showBigImageWith(imageIndex:pickerCell:))))! {
            
            self.delegate?.showBigImageWith!(imageIndex: elementView.tag - PICKER_ELEMENT_VIEW_TAG, pickerCell: self)
        }
    }

}
