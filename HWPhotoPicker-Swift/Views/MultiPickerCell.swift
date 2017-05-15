//
//  MultiPickerCell.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/15.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit

protocol MultiPickerCellDelegate: NSObjectProtocol {
    
    func canSelectElementAtIndex(picker: MultiPickerController, elementIndex: Int)
    
    func didChangeElementSeletionState(picker: MultiPickerController, isSelected: Bool,atIndex: Int)
    
    func showBigImageWith(imageIndex: Int, picker: MultiPickerController)

}

class MultiPickerCell: UITableViewCell {
    
    ///MultiPickerCellDelegate
    var delegate: MultiPickerCellDelegate?
    
    ///是否可多选
    var allowsMultipleSelection: Bool = false
    
    ///
    var elements: [Any]?
    
    ///图像Size
    var imageSize: CGSize?
    
    ///
    var numberOfElements: Int = 0
    
    ///
    var margin: Float = 0.0
    
    
    init?(style: UITableViewCellStyle, reuseIdentifier: String, imageSize: CGSize, numberOfAssets: Int, margin: Float) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - 公开方法
    func selectElementAtIndex(index: Int) {
        
    }
    
    func deselectElementAtIndex(index: Int) {
        
    }

}
