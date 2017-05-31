//
//  WBTileImgView.swift
//  UberAnimation
//
//  Created by wenbin on 2017/5/31.
//  Copyright © 2017年 beautyWang. All rights reserved.
//

import UIKit

class WBTileImgView: UIView {

    static var image : UIImage!
    //波纹时间
    static let rippleAnimationKeyTimes = [0, 0.61, 0.7, 0.887, 1]
    //是否允许动画~
    var shouldEnableRipple = false
    convenience init(tileImgName: String) {
        let img = UIImage.init(named: tileImgName)
        
        WBTileImgView.image = img
        self.init(frame: CGRect.zero)
        frame = CGRect.init(x: 0,
                            y: 0,
                            width: WBTileImgView.image.size.width,
                            height: WBTileImgView.image.size.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.contents = WBTileImgView.image.cgImage
        layer.shouldRasterize = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimationWithDuration(_ duration: TimeInterval, beginTime: TimeInterval, rippleDelay: TimeInterval, rippleOffset: CGPoint) {
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0, 0.2, 1)
        let linearFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        let easeOutFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        let easeInOutTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        let zeroPointValue = NSValue(cgPoint: CGPoint.zero)
        
        var animations = [CAAnimation]()
        
        if shouldEnableRipple {
            
            // Transform.scale
            let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            scaleAnimation.values = [1, 1, 1.05, 1, 1]
            scaleAnimation.keyTimes = WBTileImgView.rippleAnimationKeyTimes as [NSNumber]?
            scaleAnimation.timingFunctions = [linearFunction, timingFunction, timingFunction, linearFunction]
            scaleAnimation.beginTime = 0.0
            scaleAnimation.duration = duration
            animations.append(scaleAnimation)
            
            // Position
            let positionAnimation = CAKeyframeAnimation(keyPath: "position")
            positionAnimation.duration = duration
            positionAnimation.timingFunctions = [linearFunction, timingFunction, timingFunction, linearFunction]
            positionAnimation.keyTimes = WBTileImgView.rippleAnimationKeyTimes as [NSNumber]?
            positionAnimation.values = [zeroPointValue, zeroPointValue, NSValue(cgPoint:rippleOffset), zeroPointValue, zeroPointValue]
            positionAnimation.isAdditive = true
            
            animations.append(positionAnimation)
        }
        
        // Opacity
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = duration
        opacityAnimation.timingFunctions = [easeInOutTimingFunction, timingFunction, timingFunction, easeOutFunction, linearFunction]
        opacityAnimation.keyTimes = [0.0, 0.61, 0.7, 0.767, 0.95, 1.0]
        opacityAnimation.values = [0.0, 1.0, 0.45, 0.6, 0.0, 0.0]
        animations.append(opacityAnimation)
        
        // Group
        let groupAnimation = CAAnimationGroup()
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.fillMode = kCAFillModeBackwards
        groupAnimation.duration = duration
        groupAnimation.beginTime = beginTime + rippleDelay
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.animations = animations
        groupAnimation.timeOffset = kAnimationTimeOffset
        
        layer.add(groupAnimation, forKey: "ripple")
        
    }
    
}
