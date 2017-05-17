//
//  VideoElementInfoView.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/17.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit

class VideoElementInfoView: UIView {

    private var _duration: CGFloat = 0.0
    
    var duration: CGFloat {
        get {
            return _duration
        }
        set {
            _duration = newValue
            
            if _duration >= 0 && _duration < 60*60 {
                
                let min: Int = Int(_duration / 60.0)
                
                let sec: Int = Int(_duration - CGFloat(60.0) * CGFloat(min))
                
                durationLabel.text = String.init(format: "%zd:%02zd", min, sec)
                
            }else if _duration >= 60*60 && _duration < 60*60*60 {
                
                let hour: Int = Int(_duration / (60.0*60.0))
                
                let min: Int = Int((_duration - CGFloat(60.0*60.0) * CGFloat(hour)) / 60.0)
                
                let sec: Int = Int(_duration - CGFloat(60*60) * CGFloat(hour) - CGFloat(60*min))
                
                self.durationLabel.text = String.init(format: "%zd:%02zd:%02zd", hour, min, sec)
            }
        }
    }
    
    
    private var durationLabel: UILabel
    
    override init(frame: CGRect) {
        
        durationLabel = UILabel()
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.65)
        
        //ImageView
        let iconImageViewFrame = CGRect(x: 6, y: (self.bounds.size.height - 8) / 2, width: 14, height: 8)
        let iconImageView = UIImageView.init(frame: iconImageViewFrame)
        iconImageView.image = UIImage.init(named: "video")
        iconImageView.autoresizingMask = UIViewAutoresizing.flexibleRightMargin
        self.addSubview(iconImageView)
        
        //Label
        let durationLabelFrame: CGRect = CGRect(x: iconImageViewFrame.origin.x + iconImageViewFrame.size.width + 6,
                                                y: 0,
                                                width: self.bounds.size.width - (iconImageViewFrame.origin.x + iconImageViewFrame.size.width + 6),
                                                height: self.bounds.size.height)
        durationLabel.frame = durationLabelFrame
        durationLabel.backgroundColor = UIColor.clear
        durationLabel.textAlignment = NSTextAlignment.right
        durationLabel.textColor = UIColor.white
        durationLabel.font = UIFont.systemFont(ofSize: 12)
        durationLabel.autoresizingMask = UIViewAutoresizing.init(rawValue: (UIViewAutoresizing.flexibleLeftMargin.rawValue | UIViewAutoresizing.flexibleWidth.rawValue))
        self.addSubview(durationLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
