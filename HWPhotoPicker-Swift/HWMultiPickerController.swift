//
//  HWMultiPickerController.swift
//  HWPicker
//
//  Created by yellowei on 2017/5/10.
//  Copyright © 2017年 yellowei. All rights reserved.
//

import UIKit

protocol HWMultiPickerViewControllerDelegate: NSObjectProtocol {
    func didFinishPickingWithImages(picker: HWMultiPickerController, images: [Any]) -> ()
}

class HWMultiPickerController: UIViewController {
    
    ///Delegate
    var delegate: HWMultiPickerViewControllerDelegate?
    
    ///相册数据相关模型
    var assetsGroup: AlbumObj?
    
    ///是否支持多选
    var allowMutipleSelection: Bool = false;
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
