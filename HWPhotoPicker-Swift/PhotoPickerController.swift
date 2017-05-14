//
//  PhotoPickerController.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit
import Photos

enum PhotoPickerFilterType {
    case pickerFilterTypeAllAssets
    case pickerFilterTypeAllPhotos
    case pickerFilterTypeAllVideos
}

protocol PhotoPickerControllerDelegate: NSObjectProtocol {
    func didFinishPickingWithImages(picker: PhotoPickerController, images: [Any])
}

class PhotoPickerController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK:- Public属性
    ///Delegate
    var delegate: PhotoPickerControllerDelegate?
    
    ///Maximum Selected Count
    var maxImageCount: UInt = 1
    
    ///pickerFilterType
    var filterType: PhotoPickerFilterType
    
    //MARK:- Private属性
    private var aTableView: UITableView?
    private var assetsGroups: [Any]?
    
    ///重写Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        filterType = .pickerFilterTypeAllPhotos
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        filterType = .pickerFilterTypeAllPhotos
        
        super.init(coder: aDecoder)
    }
    
    
    //MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()

        let btnRight = UIButton(type: .custom)
        btnRight.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
        btnRight.setTitle("取消", for: UIControlState.init(rawValue: 0))
        btnRight.setTitleColor(UIColor.black, for: UIControlState(rawValue: 0))
        btnRight.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btnRight.addTarget(self, action: #selector(dissmiss), for: UIControlEvents.touchUpInside)
        let rightItem = UIBarButtonItem(customView: btnRight)
        navigationItem.setRightBarButton(rightItem, animated: true)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.textColor = UIColor.black
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.text = title
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.tintColor = UIColor.color(hex: 0xe6e6e6)
        
        let authorStatus: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if authorStatus == .notDetermined
        {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized
                {
                    self.loadData()
                }
                else
                {
                    self.dismiss(animated: true, completion: {
                        
                    });
                }
            })
        }
        else if authorStatus == .restricted || authorStatus == .denied
        {
            let alert: UIAlertView = UIAlertView(title: "提示", message: "没有访问照片的权限,您可以去系统设置[设置-隐私-照片]中为牙医管家开启照片功能", delegate:(self as! UIAlertViewDelegate), cancelButtonTitle: "确定")
            alert.tag = 1001
            alert.show()
        }
        else
        {
            loadData()
        }
        
    }
    
    override func loadView() {
        
        var screenBounds = UIScreen.main.bounds
        
        let statusBarFrame = UIApplication.shared.statusBarFrame
        
        let statusBarHeight = min(statusBarFrame.width, statusBarFrame.height)
        
        screenBounds = CGRect(x: screenBounds.origin.x, y: screenBounds.origin.y, width: screenBounds.width, height: statusBarHeight)
        
        let mView = UIView.init(frame: screenBounds)
        
        mView.autoresizingMask = kECAutoResizingMask
        
        mView.backgroundColor = UIColor.white
        
        mView.isOpaque = true
        
        view = mView
        
        self.setTableView()
    }
    
    
    //MARK: - Event
    @objc private func dissmiss() {
        self.dismiss(animated: true) { 
            
        }
    }


    //MARK: - 私有方法
    
    /// 加载数据
    private func loadData() -> () {
        
        ImageDataAPI.sharedInstance.getAlbumsWith { (ret, obj) in
            
            if ret ?? false {
                
                guard let obj = obj as? [Any] else {
                    return
                }
                
                self.assetsGroups = Array.init(arrayLiteral: obj)
                
                DispatchQueue.main.async {[weak self] in
                    
                    self?.aTableView?.reloadData()
                }
            }
        }
    }
    
    private func setTableView() {
        
        aTableView = UITableView.init(frame: view.bounds, style: .grouped)
        aTableView?.dataSource = self
        aTableView?.delegate = self
        aTableView?.autoresizingMask = UIViewAutoresizing(rawValue: (UIViewAutoresizing.flexibleHeight.rawValue | UIViewAutoresizing.flexibleWidth.rawValue))
        aTableView?.separatorStyle = .singleLine
        aTableView?.separatorColor = UIColor.color(hex: 0xececec)
        view.addSubview(aTableView!)
    }
    
    
    
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assetsGroups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        static String = "PickerCell"
        
        
        
        return UITableViewCell()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
   

}
