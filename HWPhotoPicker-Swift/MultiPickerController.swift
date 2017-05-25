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
//    private let
    
    
    
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
                _bigImgScroll?.delegate = self as? HWScrollViewDelegate

            }
            return _bigImgScroll!
        }
        set {
            _bigImgScroll = newValue
        }
    }
    
    //MARK: - showBigImg相关的视图
    var m_topView: UIView?
    var m_labDate: UILabel?
    var m_backBtn: UIButton?
    var m_bottomView: UIView?
    var m_overlayImageView: UIButton?
    var m_currentPage: Int = 0
    var m_labBigImageInfo: UILabel?
    
    
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
        let btnRight = UIButton.init(type: .custom)
        btnRight.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
        btnRight.setTitle("完成", for: .normal)
        btnRight.setTitleColor(UIColor.black, for: .normal)
        btnRight.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btnRight.addTarget(self, action: #selector(dissmiss), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: btnRight)
        if self.maximumNumberOfSelection > 1 {
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
        
//        UIView.transition(with: , duration: <#T##TimeInterval#>, options: <#T##UIViewAnimationOptions#>, animations: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
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
            cell?.delegate = self as? MultiPickerCellDelegate
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
            
            let alertView = UIAlertView.init(title: "提示", message: "一次选择的图片不得超过\(self.maximumNumberOfSelection)张", delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
        
        return canSelect
    }
    
    func didChangeElementSeletionState(pickerCell: MultiPickerCell, isSelected: Bool, atIndex: Int) {
        
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
        }
    }
    

}
