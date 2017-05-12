//
//  HWPhotoPickerController.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit
import AssetsLibrary
import Photos

enum PhotoPickerFilterType {
    case pickerFilterTypeAllAssets
    case pickerFilterTypeAllPhotos
    case pickerFilterTypeAllVideos
}

protocol HWPhotoPickerControllerDelegate: NSObjectProtocol{
    func didFinishPickingWithImages(picker: HWPhotoPickerController, images: [Any])
}

class HWPhotoPickerController: UIViewController {

    //MARK:- Public属性
    ///Delegate
    var delegate: HWPhotoPickerControllerDelegate?
    
    ///Maximum Selected Count
    var maxImageCount: UInt = 1
    
    ///pickerFilterType
    var filterType: PhotoPickerFilterType = .pickerFilterTypeAllAssets
    
    //MARK:- Private属性
    private var aTableView: UITableView?
    private var assetsLibrary: ALAssetsLibrary?
    private var assetsGroups: [Any]?
    
    //MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()

        let btnRight = UIButton(type: .custom)
        btnRight.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
        btnRight.setTitle("取消", for: UIControlState.init(rawValue: 0))
        btnRight.setTitleColor(UIColor.black, for: UIControlState(rawValue: 0))
        btnRight.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        btnRight.addTarget(self, action: #selector(dismiss(animated:completion:)), for: UIControlEvents.touchUpInside)
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


    //MARK: - 私有方法
    private func loadData() -> () {
        
    }
    
    

   

}
