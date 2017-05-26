//
//  ViewController.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PhotoPickerControllerDelegate {

    var tableView: UITableView?
    
    private var dataSource: [UIImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTableView()
        
    }

    //MARK: - 私有方法
    func setTableView() {
        
        tableView = UITableView.init(frame: CGRect(x: 0,
                                                   y: 64,
                                                   width: kECScreenWidth,
                                                   height: kECScreenHeight - 64),
                                     style: UITableViewStyle.grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onTableClick(tap:)))
        //        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onTableClik))
        tableView?.addGestureRecognizer(tap)
        view.addSubview(tableView!)
    }
    
    //MARK: - Events
    @objc private func onTableClick(tap: UITapGestureRecognizer) -> () {
        
        let imagePickerController = PhotoPickerController()
        imagePickerController.title = "本地相册"
        imagePickerController.delegate = self
        imagePickerController.maxImageCount = 1//instead of 10
        imagePickerController.filterType = .pickerFilterTypeAllPhotos
        let naviController = UINavigationController.init(rootViewController: imagePickerController)
        self.present(naviController, animated: true) { 
            
        }
        
    }


    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource?[section] != nil {
            return 1
        }else {
            return 0
        }
        
    }
    
    static let identifier = "cell"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ViewController.identifier)
        
        if cell == nil {
            
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: ViewController.identifier)
        }
        
        cell?.imageView?.image = self.dataSource?[indexPath.section]
        cell?.imageView?.contentMode = .scaleAspectFill
        
        return cell!
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    
    //MARK: - PhotoPickerControllerDelegate
    func didFinishPickingWithImages(picker: PhotoPickerController, images: [Any]) {
        
        guard let images = (images as? [Dictionary<String, Any>])  else {
            return
        }
        
        if dataSource == nil {
            
            dataSource = [UIImage]()
        }
        
        self.dataSource?.removeAll()
    
        for dict in images {
            
            guard let image = (dict["IMG"] as? UIImage) else { continue }
            
            dataSource?.append(image)
        }
        
        self.tableView?.reloadData()
    }
    
}

