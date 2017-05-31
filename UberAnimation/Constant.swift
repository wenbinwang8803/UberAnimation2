//
//  Constant.swift
//  UberAnimation
//
//  Created by wenbin on 2017/5/27.
//  Copyright © 2017年 beautyWang. All rights reserved.
//

import Foundation
import UIKit
/// The total animation duration of the splash animation
let kAnimationDuration: TimeInterval = 3.0

/// The length of the second part of the duration
let kAnimationDurationDelay: TimeInterval = 0.5

/// The offset between the AnimatedULogoView and the background Grid
let kAnimationTimeOffset: CFTimeInterval = 0.35 * kAnimationDuration

/// The ripple magnitude. Increase by small amounts for amusement ( <= .2) :]
let kRippleMagnitudeMultiplier: CGFloat = 0.025

extension UIColor {
    public class func theme() -> UIColor {
        return UIColor.init(red: 15/255, green: 78/255, blue: 101/255, alpha: 1)
    }
}
