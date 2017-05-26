//
//  MultiPickerController.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit
import Photos

@objc protocol MultiPickerViewControllerDelegate: NSObjectProtocol {
    @objc optional func didFinishPickingWithImages(picker: MultiPickerController, images: [Any]) -> ()
}

class MultiPickerController: UIViewController, UITableViewDelegate, UITableViewDataSource, MultiPickerCellDelegate, HWScrollViewDelegate {
    
    //MARK: - 伪装的宏定义
    private let LabDateWidth: CGFloat = 170.0
    private let LabDateHeigth: CGFloat = 30.0
    
    private let LabBackbuttonWidth: CGFloat = 60.0
    private let LabBackbuttonHeight: CGFloat = 30.0
    
    private let LabBigImageInfoWidth: CGFloat = 60.0
    private let LabBigImageInfoHeight: CGFloat = 20.0
    
    private let MorebuttonWidth: CGFloat = 45.0
    private let MorebuttonHeigth: CGFloat = 30.0
    
    //MARK: - public属性
    var maximumNumberOfSelection: Int = 1
    var limitsMaximumNumberOfSelection: Bool = false
    ///Delegate
    var delegate: MultiPickerViewControllerDelegate?
    
    
    
    
    //MARK:- Private属性
    ///TableView
    private var aTableView: UITableView?
    private var elements: [PhotoObj]
    ///图像大小
    private var imageSize: CGSize = CGSize(width: 0, height: 0)
    private var selectedElements: NSMutableOrderedSet
    private var _bigImgScroll: HWScrollView?
    private var bigImgScroll: HWScrollView {
        get {
            if _bigImgScroll == nil {
                
                _bigImgScroll = HWScrollView.init(frame: UIScreen.main.bounds)
                _bigImgScroll?.backgroundColor = UIColor.init(white: 0, alpha: 0.9)
                _bigImgScroll?.delegate = self

            }
            return _bigImgScroll!
        }
        set {
            _bigImgScroll = newValue
        }
    }
    
    private var m_rightNaviBtn: UIButton?
    
    //MARK: showBigImg相关的视图
    private var m_topView: UIView?
    private var m_labDate: UILabel?
    private var m_backBtn: UIButton?
    private var m_completeBtn: UIButton?
    private var m_bottomView: UIView?
    private var m_overlayImageView: UIButton?
    private var m_currentPage: Int = 0
    private var m_labBigImageInfo: UILabel?
    
    ///是否支持多选
    var allowMutipleSelection: Bool = false;
    
    var filterType: PhotoPickerFilterType = .pickerFilterTypeAllAssets
    
    ///相册数据相关模型
    var assetsGroup: AlbumObj?
    
    //MARK: - 生命周期方法
    
    ///重写init方法
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        elements = [PhotoObj]()
        
        selectedElements = NSMutableOrderedSet()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///重写load方法
    override func loadView() {
        
        var screenBounds = UIScreen.main.bounds
        
        let statusBarFrame = UIApplication.shared.statusBarFrame
        
        let statusBarHeight = min(statusBarFrame.width, statusBarFrame.height)
        
        screenBounds = CGRect(x: screenBounds.origin.x, y: screenBounds.origin.y, width: screenBounds.width, height: screenBounds.height - statusBarHeight)
        
        let mView = UIView.init(frame: screenBounds)
        
        mView.autoresizingMask = kECAutoResizingMask
        
        mView.backgroundColor = UIColor.white
        
        mView.isOpaque = true
        
        view = mView
        
        self.setTableView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageSize = CGSize(width: 75, height: 75)
        
        if self.navigationItem.leftBarButtonItem == nil {
            
            let title = "返回"
            let nameSize = CGSize(width: 30, height: 20)
            let imgSize = CGSize(width: 11, height: 20)
            let btnSize = CGSize(width: 53, height: 28)
            
            let btnLeft = UIButton.init(type: .custom)
            btnLeft.frame = CGRect(x: 0, y: 0, width: btnSize.width, height: btnSize.height)
            btnLeft.setTitle(title, for: .normal)
            btnLeft.setTitleColor(UIColor.black, for: .normal)
            btnLeft.setImage(UIImage.init(named: "btn_navi_return_title"), for: .normal)
            btnLeft.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btnLeft.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
            btnLeft.imageEdgeInsets = UIEdgeInsetsMake((btnLeft.bounds.size.height - imgSize.height),
                                                       (btnLeft.bounds.size.width - (imgSize.width + nameSize.width + 8)) / 2,
                                                       (btnLeft.bounds.size.height - imgSize.height) / 2,
                                                       btnLeft.bounds.size.width - ((btnSize.width - (imgSize.width + nameSize.width + 8)) / 2) - imgSize.width)
            btnLeft.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                       -((btnLeft.imageView?.image?.size.width) ?? 0.0) + imgSize.width + 8,
                                                       0,
                                                       0)
            
            let leftItem = UIBarButtonItem.init(customView: btnLeft)
            self.navigationItem.leftBarButtonItem = leftItem
        }
        
        //rightBtn
        m_rightNaviBtn = UIButton.init(type: .custom)
        m_rightNaviBtn?.setTitleColor(UIColor.black, for: .normal)
        m_rightNaviBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        m_rightNaviBtn?.addTarget(self, action: #selector(dissmiss), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: m_rightNaviBtn!)
        if self.maximumNumberOfSelection > 1 {
            
            let title = "完成(\(self.selectedElements.count)/\(maximumNumberOfSelection))"
            let size = String.commonSize(with: title, fontNum: 15.0, size: CGSize(width: CGFloat(MAXFLOAT), height: 17.0))
            m_rightNaviBtn?.frame = CGRect(x: 0, y: 0, width: size.width, height: 25)
            m_rightNaviBtn?.setTitle(title, for: .normal)
            self.navigationItem.rightBarButtonItem = rightItem
        }
        
        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.textColor = UIColor.black
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = self.title
        self.navigationItem.titleView = titleLabel
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if self.elements.count > 0 {
            elements.removeAll()
        }
        
        guard let guardAlbumObj = self.assetsGroup else {
            return
        }
        
        ImageDataAPI.shared.getPhotosWith(group: guardAlbumObj) { (ret, obj) in
            
            guard let photoObjArr = obj as? [PhotoObj] else {
                return
            }
            
            self.elements.append(contentsOf: photoObjArr)
        }
        
        self.aTableView?.reloadData()
    }
    
    
    //MARK: - 私有方法
    private func setTableView() {
        
        aTableView = UITableView.init(frame: view.bounds, style: .grouped)
        aTableView?.dataSource = self
        aTableView?.delegate = self
        aTableView?.autoresizingMask = UIViewAutoresizing(rawValue: (UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleWidth.rawValue))
        aTableView?.separatorStyle = .singleLine
        aTableView?.separatorColor = UIColor.color(hex: 0xececec)
        view.addSubview(aTableView!)
    }
    
    //MARK: - Events
    @objc private func goBack(sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func dissmiss() {
        
        if self.selectedElements.count > 0 {
            
            var infoArray = [Any]()
            
            for asset in self.selectedElements {
                
                guard let guardAsset = asset as? PhotoObj,
                      let guardPhAsset = guardAsset.photoObj
                    else {
                    continue
                }
                
                ImageDataAPI.shared.getImageForPhotoObj(asset: guardPhAsset, size: (IS_IOS8 ? PHImageManagerMaximumSize : CGSize.zero), completion: { (ret, image) in
                    
                    var dict = [String: Any]()
                    
                    if let image = image {
                        dict.updateValue(image, forKey: "IMG")
                    }
                    dict.updateValue(0, forKey: "SIZE")
                    dict.updateValue("", forKey: "NAME")
                    infoArray.append(dict)
                })
            }
            
            if self.delegate?.responds(to: #selector(MultiPickerViewControllerDelegate.didFinishPickingWithImages(picker:images:))) ?? false {
                
                self.delegate?.didFinishPickingWithImages!(picker: self, images: infoArray)
            }
            self.dismiss(animated: true, completion: nil)
            
        }else {
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func onBackTouch(sender: UIButton?) {
        
        UIView.transition(with: bigImgScroll,
                          duration: 0.35,
                          options: .curveEaseInOut,
                          animations: {
                            
                            self.bigImgScroll.frame = CGRect(x: kECScreenWidth,
                                                             y: 0,
                                                             width: self.bigImgScroll.frame.size.width,
                                                             height: self.bigImgScroll.frame.size.height)
                            self.bigImgScroll.alpha = 0.0
                            self.navigationController?.navigationBar.isHidden = false
                            UIApplication.shared.isStatusBarHidden = false
                            
        }) { (finished) in
            
            self.bigImgScroll.removeFromSuperview()
        }
    }
    
    
    /// Overlay Btn Selected
    ///
    /// - Parameter sender: sender
    @objc private func onSelectedClick(sender: UIButton?) {
        
        var canSelect = true
        
        if self.allowMutipleSelection && self.limitsMaximumNumberOfSelection {
            
            canSelect = self.selectedElements.count < self.maximumNumberOfSelection
        }
        
        if canSelect == false && m_overlayImageView?.isSelected == false {
            
            let alertView = UIAlertController.init(title: "提示", message: "一次选择的图片不得超过\(self.maximumNumberOfSelection)张", preferredStyle: .alert)
            
            alertView.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: nil))
            
            self.present(alertView, animated: true, completion: nil)
        }else {
        
            let asset = self.elements[m_currentPage]
            if self.allowMutipleSelection {
                
                let numberOfAssetsInRow = Int(self.view.frame.size.width / self.imageSize.width)
                let rowNum = m_currentPage / numberOfAssetsInRow
                let tag = (m_currentPage % numberOfAssetsInRow) + PICKER_ELEMENT_VIEW_TAG
                let cell = self.aTableView?.cellForRow(at: IndexPath.init(row: rowNum, section: 0))
                if let elementView = cell?.viewWithTag(tag) as? PickerElementView {
                    if self.m_overlayImageView?.isSelected == false {
                        
                        self.m_overlayImageView?.isSelected = true
                        self.selectedElements.add(asset)
                        elementView.selected = true
                        
                    }else {
                        
                        self.m_overlayImageView?.isSelected = false
                        self.selectedElements.remove(asset)
                        elementView.selected = false
                    }
                }
            }
        }
        
        if self.maximumNumberOfSelection > 1 {
            
            let title = "完成(\(self.selectedElements.count)/\(maximumNumberOfSelection))"
            let size = String.commonSize(with: title, fontNum: 15.0, size: CGSize(width: CGFloat(MAXFLOAT), height: 17.0))
            m_rightNaviBtn?.frame = CGRect(x: 0, y: 0, width: size.width, height: 25)
            m_rightNaviBtn?.setTitle(title, for: .normal)
            m_completeBtn?.frame = CGRect(x: self.view.frame.size.width - size.width - 8,
                                          y: self.view.frame.origin.y + 20 + 5,
                                          width: size.width,
                                          height: MorebuttonHeigth)
            m_completeBtn?.setTitle(title, for: .normal)
        }
    }
    
    
    @objc private func onCompleteBtnClick(sender: UIButton) {
        
        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.isStatusBarHidden = false
        self.dissmiss()
        
        
    }
    
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRowsInSection = 0
        
        if self.elements.count > 0,self.imageSize.width > 0
        {
            let numberOfAssetsInRow = Int(view.bounds.size.width / self.imageSize.width)
            
            numberOfRowsInSection = Int(self.elements.count / numberOfAssetsInRow)
            
            if self.elements.count - numberOfRowsInSection * numberOfAssetsInRow > 0 {
                
                numberOfRowsInSection += 1
            }
        }
        
        return numberOfRowsInSection
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MutilPickerCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MultiPickerCell
        
        if cell == nil {
            
            //计算一行显示几个
            var numberOfAssetsInRow = 0
            if self.imageSize.width > 0 {
                numberOfAssetsInRow = Int(self.view.bounds.size.width / self.imageSize.width)
            }
            
            //计算间距
            let margin = round((self.view.bounds.size.width - self.imageSize.width * CGFloat(numberOfAssetsInRow)) / CGFloat(numberOfAssetsInRow + 1))
            cell = MultiPickerCell.init(style: .default, reuseIdentifier: cellIdentifier, imageSize: self.imageSize, numberOfAssets: numberOfAssetsInRow, margin: margin)
            cell?.selectionStyle = .none
            cell?.delegate = self
            cell?.allowsMultipleSelection = self.allowMutipleSelection
        }
        
        let numberOfAssetsInRow = Int(self.view.bounds.size.width / self.imageSize.width)
        let offset = numberOfAssetsInRow * indexPath.row
        let numberOfAssetsToSet = (offset + numberOfAssetsInRow > self.elements.count) ? (self.elements.count - offset) : numberOfAssetsInRow
        
        var assets = [PhotoObj]()
        for i in 0..<numberOfAssetsToSet {
            
            let asset = self.elements[offset + i]
            assets.append(asset)
        }
        
        cell?.elements = assets
        
        for i in 0..<numberOfAssetsToSet {
         
            let asset = self.elements[offset + i]
            
            if self.selectedElements.contains(asset) {
                cell?.selectElementAtIndex(index: i)
            }else{
                cell?.deselectElementAtIndex(index: i)
            }
            
        }
        
        return cell!
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    

    //MARK: - MultiPickerCellDelegate
    func canSelectElementAtIndex(pickerCell: MultiPickerCell, elementIndex: Int) -> (Bool) {
        
        var canSelect = true
        
        if self.allowMutipleSelection && self.limitsMaximumNumberOfSelection {
        
            canSelect = (self.selectedElements.count < self.maximumNumberOfSelection)
        }
        
        if !canSelect {
            let alertView = UIAlertController.init(title: "提示", message: "一次选择的图片不得超过\(self.maximumNumberOfSelection)张", preferredStyle: .alert)
            
            alertView.addAction(UIAlertAction.init(title: "确定", style: .cancel, handler: nil))
            
            self.present(alertView, animated: true, completion: nil)
            
        }
        
        return canSelect
    }
    
    func didChangeElementSeletionState(pickerCell: MultiPickerCell, isSelected: Bool, atIndex: Int) {
        
        guard let indexPath = self.aTableView?.indexPath(for: pickerCell) else {return}
        let numberOfAssetsInRow = Int(self.view.bounds.size.width / self.imageSize.width)
        let assetIndex = indexPath.row * numberOfAssetsInRow + atIndex
        
        let asset = self.elements[assetIndex]
        if self.allowMutipleSelection {
            
            if isSelected {
                
                self.selectedElements.add(asset)
            }else {
                
                self.selectedElements.remove(asset)
            }
            
            if self.maximumNumberOfSelection > 1 {
                
                let title = "完成(\(self.selectedElements.count)/\(maximumNumberOfSelection))"
                let size = String.commonSize(with: title, fontNum: 15.0, size: CGSize(width: CGFloat(MAXFLOAT), height: 17.0))
                m_rightNaviBtn?.frame = CGRect(x: 0, y: 0, width: size.width, height: 25)
                m_rightNaviBtn?.setTitle(title, for: .normal)
            }
            
        }else {
            
            self.selectedElements.add(asset)
            self.dissmiss()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: UInt64(0.1) * NSEC_PER_SEC), execute: {
                
            })
        }
        
        
        
    }
    
    func showBigImageWith(imageIndex: Int, pickerCell: MultiPickerCell) {
        
        guard let indexPath = self.aTableView?.indexPath(for: pickerCell) else {return}
        let numberOfAssetsInRow = Int(self.view.bounds.size.width / self.imageSize.width)
        let assetIndex = indexPath.row * numberOfAssetsInRow + imageIndex
        self.view .addSubview(self.bigImgScroll)
        
        m_currentPage = assetIndex
        self.bigImgScroll.startWith(imageArray: self.elements, currentIndex: assetIndex)
        
        //顶视图
        if m_topView == nil {
            
            m_topView = UIView.init(frame: CGRect(x: 0, y: 0, width: kECScreenWidth, height: 64))
            m_topView?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.bigImgScroll.addSubview(m_topView!)
            
            //时间Lable
            if (m_labDate == nil) {
                m_labDate = UILabel(frame: CGRect(x: (self.view.frame.size.width - LabDateWidth) / 2,
                                                  y: self.view.frame.origin.y + 20 + 5,
                                                  width: LabDateWidth,
                                                  height: LabDateHeigth))
                m_labDate?.font = UIFont.systemFont(ofSize: 18.0)
                m_labDate?.textAlignment = NSTextAlignment.center
                m_labDate?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
                m_labDate?.layer.cornerRadius = (m_labDate?.frame.height ?? 0.0) / 2.0
                m_labDate?.layer.masksToBounds = true
                m_labDate?.textColor = UIColor.white
                m_labDate?.text = "图片预览"
                
                m_topView?.addSubview(m_labDate!)
            }
            
            //返回按钮
            if (m_backBtn == nil) {
                m_backBtn = UIButton.init(type: .custom)
                m_backBtn?.frame = CGRect(x: 8,
                                          y: self.view.frame.origin.y + 20 + 5,
                                          width: LabBackbuttonWidth,
                                          height: LabBackbuttonHeight)
                m_backBtn?.titleLabel?.textAlignment = NSTextAlignment.center
                m_backBtn?.setImage(UIImage.init(named: "btn_navi_return_title_white"), for: .normal)
                m_backBtn?.imageEdgeInsets = UIEdgeInsetsMake((LabBackbuttonHeight - 14) / 2, (LabBackbuttonWidth - 45) / 2, (LabBackbuttonHeight - 14) / 2, (LabBackbuttonWidth - 45) / 2)
                m_backBtn?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
                m_backBtn?.layer.cornerRadius = (m_backBtn?.frame.height ?? 0.0) / 2.0
                m_backBtn?.layer.masksToBounds = true
                m_backBtn?.addTarget(self, action: #selector(onBackTouch(sender:)), for: .touchUpInside)

                m_topView?.addSubview(m_backBtn!)
            }
            
            m_completeBtn = UIButton.init(type: .custom)
            m_completeBtn?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
            
            if self.maximumNumberOfSelection > 1 {
                
                let title = "完成(\(self.selectedElements.count)/\(maximumNumberOfSelection))"
                let size = String.commonSize(with: title, fontNum: 15.0, size: CGSize(width: CGFloat(MAXFLOAT), height: 17.0))
                m_completeBtn?.frame = CGRect(x: self.view.frame.size.width - size.width - 8,
                                              y: self.view.frame.origin.y + 20 + 5,
                                              width: size.width,
                                              height: MorebuttonHeigth)
                m_completeBtn?.setTitle(title, for: .normal)
                
            }else {
                
                m_completeBtn?.frame = CGRect(x: self.view.frame.size.width - MorebuttonWidth - 8,
                                              y: self.view.frame.origin.y + 20 + 5,
                                              width: MorebuttonWidth,
                                              height: MorebuttonHeigth)
                m_completeBtn?.setTitle("完成", for: .normal)
                
            }
            m_completeBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            m_completeBtn?.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
            m_completeBtn?.addTarget(self, action: #selector(onCompleteBtnClick(sender:)), for: .touchUpInside)
            m_topView?.addSubview(m_completeBtn!)

        }
        
        //底视图
        if m_bottomView == nil {
            
            m_bottomView = UIView.init(frame: CGRect(x: 0,
                                                     y: bigImgScroll.frame.size.height - 49,
                                                     width: bigImgScroll.frame.size.width,
                                                     height: 49))
            bigImgScroll.addSubview(m_bottomView!)
            m_bottomView?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            
            let bottomLine = UIView.init(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: kECScreenWidth,
                                                       height: 0.01))
            bottomLine.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            bottomLine.alpha = 0.2
            m_bottomView?.addSubview(bottomLine)
            
            //Overlay Image View
            if self.allowMutipleSelection {
                m_overlayImageView = UIButton.init(type: .custom)
                m_overlayImageView?.frame = CGRect(x: (m_bottomView?.frame.size.width ?? 0.0) - 35.0,
                                                   y: ((m_bottomView?.frame.size.height ?? 0.0) - 25.0) / 2.0,
                                                   width: 25,
                                                   height: 25)
                m_overlayImageView?.contentMode = .scaleAspectFill
                m_overlayImageView?.layer.cornerRadius = 12.5
                m_overlayImageView?.clipsToBounds = true
                m_overlayImageView?.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
                m_overlayImageView?.setBackgroundImage(UIImage.init(named: "photopicker_nor.png"), for: .normal)
                m_overlayImageView?.setBackgroundImage(UIImage.init(named: "photopicker_sel.png"), for: .selected)
                m_overlayImageView?.autoresizingMask = kECAutoResizingMask
                m_overlayImageView?.clipsToBounds = true
                m_overlayImageView?.addTarget(self, action: #selector(onSelectedClick(sender:)), for: .touchUpInside)
                m_bottomView?.addSubview(m_overlayImageView!)
            }
            
            
            //页码显示label
            m_labBigImageInfo = UILabel.init(frame: CGRect(x: (self.view.frame.size.width - LabBigImageInfoWidth) / 2.0,
                                                           y: self.view.frame.size.height - LabBigImageInfoHeight - 8,
                                                           width: LabBigImageInfoWidth,
                                                           height: LabBigImageInfoHeight))
            m_labBigImageInfo?.font = UIFont.systemFont(ofSize: 18.0)
            m_labBigImageInfo?.textAlignment = NSTextAlignment.center
            m_labBigImageInfo?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            m_labBigImageInfo?.layer.cornerRadius = (m_labBigImageInfo?.frame.size.height ?? 0.0) / 2.0
            m_labBigImageInfo?.layer.masksToBounds = true
            m_labBigImageInfo?.textColor = UIColor.white
            bigImgScroll.addSubview(m_labBigImageInfo!)
        }
        
        if self.selectedElements.contains(self.elements[assetIndex]) {
            
            m_overlayImageView?.isSelected = true
        }else {
            
            m_overlayImageView?.isSelected = false
        }
        
        m_labBigImageInfo?.text = "\(assetIndex + 1)/\(self.elements.count)"
        
        //添加动画效果
        bigImgScroll.frame = CGRect(x: kECScreenWidth,
                                    y: 0,
                                    width: bigImgScroll.frame.size.width,
                                    height: bigImgScroll.frame.size.height)
        bigImgScroll.alpha = 0.0
        
        //放大（全屏显示）ShowImage的动画
        UIView.transition(with: bigImgScroll,
                          duration: 0.35,
                          options: .curveEaseInOut,
                          animations: {
                            
                            self.bigImgScroll.frame = CGRect(x: 0,
                                                        y: 0,
                                                        width: self.bigImgScroll.frame.size.width,
                                                        height: self.bigImgScroll.frame.size.height)
                            self.bigImgScroll.alpha = 1.0
                            self.navigationController?.navigationBar.isHidden = true
                            UIApplication.shared.isStatusBarHidden = true
                            
        }) { (finish) in
            
        }
        
        
        //不支持多选的情况(通过长按来调用的查看大图的情况)
        if self.allowMutipleSelection == false {
            
            self.selectedElements.removeAllObjects()
            self.selectedElements.add(self.elements[assetIndex])
        }
    }
    
    //MARK: - HWScrollViewDelegate
    func scrollToNextStateWithIndex(leftIndex: Int, middleIndex: Int, rightIndex: Int) {
        
        if m_currentPage != middleIndex {
        
            m_currentPage = middleIndex
            
            m_labBigImageInfo?.text = "\(middleIndex + 1)/\(self.elements.count)"
            
            let asset = self.elements[middleIndex]
            if self.allowMutipleSelection {
                
                if self.selectedElements.contains(asset) {
                    
                    m_overlayImageView?.isSelected = true
                    
                }else {
                    
                    m_overlayImageView?.isSelected = false
                }
            } else {
                
                self.selectedElements.removeAllObjects()
                self.selectedElements.add(asset)
            }
        
        }
        
    }
    
    func endHiddenAnimation(scrollView: HWScrollView, isHide: Bool) {
        
        if m_topView?.alpha == 1.0 {
            
            UIView.animate(withDuration: 0.1, animations: { 
                
                self.m_topView?.alpha = 0.0
                self.m_bottomView?.alpha = 0.0
                self.m_labBigImageInfo?.alpha = 0.0
            })
        }else {
        
            self.m_topView?.alpha = 1.0
            self.m_bottomView?.alpha = 1.0
            self.m_labBigImageInfo?.alpha = 1.0
        }
    }
    

}
