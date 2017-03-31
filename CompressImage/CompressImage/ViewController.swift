//
//  ViewController.swift
//  CompressImage
//
//  Created by vvlong on 2017/2/27.
//  Copyright © 2017年 vvlong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var origin: UIImage
        origin = UIImage(named: "IMG_4385.JPG")!
        let data:Data! = UIImageJPEGRepresentation(origin, 0.1)
        var newImage = UIImage(data: data)
        
        
        func imageSave(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
            if error != nil {
                print("error!")
                return
            }
        }
        
        UIImageWriteToSavedPhotosAlbum(newImage!, nil, nil, nil)
        
//        UIImageWriteToSavedPhotosAlbum(newImage!, self, #selector(imageSave(image:didFinishSavingWithError:contextInfo:)), nil)
        
        func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
            if error != nil
                
            {
                
                print("error!")
                
                return
                
            }
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

