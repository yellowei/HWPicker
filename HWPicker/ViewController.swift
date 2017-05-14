//
//  ViewController.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTableView()
        
    }

    //MARK: - 私有方法
    func setTableView() {
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 64, width: kECScreenWidth, height: kECScreenHeight), style: UITableViewStyle.grouped)
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
//        imagePickerController.delegate = self
        imagePickerController.maxImageCount = 999
        imagePickerController.filterType = .pickerFilterTypeAllPhotos
        let naviController = UINavigationController.init(rootViewController: imagePickerController)
        self.present(naviController, animated: true) { 
            
        }
        
    }


    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

