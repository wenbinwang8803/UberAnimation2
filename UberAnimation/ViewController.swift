//
//  ViewController.swift
//  UberAnimation
//
//  Created by wenbin on 2017/5/27.
//  Copyright © 2017年 beautyWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var logoView : WBUberAnimationLogoView!
    var backView : WBUberAnimationBackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let kW = self.view.bounds.size.width
//        let kH = self.view.bounds.size.height
        
        let btn = UIButton.init(frame: CGRect.init(x: 20, y: 20, width: 80, height: 30))
        btn.setTitle("动起来", for: .normal)
        btn.backgroundColor = UIColor.blue
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        backView = WBUberAnimationBackView.init(frame: self.view.bounds)
        logoView = WBUberAnimationLogoView.init(frame: CGRect.init(x: (kW - 100) / 2.0, y: 200, width: 100, height: 100))
        backView.addSubview(logoView)
        self.view.addSubview(backView)
        
        self.view.addSubview(btn)
        logoView.startAnimation()
    }
    
    func btnClick() {
        backView.startAnimating()
        logoView.startAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

