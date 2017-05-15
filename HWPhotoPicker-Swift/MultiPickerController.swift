//
//  MultiPickerController.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit

protocol MultiPickerViewControllerDelegate: NSObjectProtocol {
    func didFinishPickingWithImages(picker: MultiPickerController, images: [Any]) -> ()
}

class MultiPickerController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    ///Delegate
    var delegate: MultiPickerViewControllerDelegate?
    
    //MARK:- Private属性
    ///TableView
    private var aTableView: UITableView?
    ///相册数据相关模型
    private var assetsGroup: AlbumObj?
    ///
    private var elements: [Any]
    ///图像大小
    private var imageSize: CGSize = CGSize(width: 0, height: 0)
    
    
    ///是否支持多选
    var allowMutipleSelection: Bool = false;
    
    
    ///重写init方法
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        elements = [Any]()
        
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
        
        screenBounds = CGRect(x: screenBounds.origin.x, y: screenBounds.origin.y, width: screenBounds.width, height: statusBarHeight)
        
        let mView = UIView.init(frame: screenBounds)
        
        mView.autoresizingMask = kECAutoResizingMask
        
        mView.backgroundColor = UIColor.white
        
        mView.isOpaque = true
        
        view = mView
        
        self.setTableView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PhotoPickerCell
        
        if cell == nil {
            
            cell = PhotoPickerCell(style: .default, reuseIdentifier: cellIdentifier)
            cell?.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        
        guard
            let album = self.assetsGroup?[indexPath.row] as? AlbumObj,
            let theCell = cell
            else {
                return UITableViewCell()
        }
        
        theCell.photoImageView.image = album.posterImage
        theCell.titleLabel.text = album.name
        theCell.countLabel.text = "(\(album.count)张)"
        
        return theCell
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
        
        let album = self.assetsGroups?[indexPath.row]
        
        let multiPicker = MultiPickerController()
        
    }


}
