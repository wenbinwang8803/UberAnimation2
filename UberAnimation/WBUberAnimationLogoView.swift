//
//  WBUberAnimationLogoView.swift
//  UberAnimation
//
//  Created by wenbin on 2017/5/27.
//  Copyright © 2017年 beautyWang. All rights reserved.
//

import UIKit

class WBUberAnimationLogoView: UIView {

    fileprivate let strokeEndTimingFun = CAMediaTimingFunction.init(controlPoints: 1.0, 0.0, 0.35, 1.0)
    fileprivate let circleLayerTimingFun = CAMediaTimingFunction.init(controlPoints: 0.65, 0, 0.4, 1)
    fileprivate let squareLayerTimingFunction      = CAMediaTimingFunction(controlPoints: 0.25, 0.0, 0.20, 1.0)
    fileprivate let fadeInSquareTimingFunction = CAMediaTimingFunction(controlPoints: 0.15, 0, 0.85, 1.0)

    
    fileprivate let radius: CGFloat = 37.5
    fileprivate let squareLayerLength : CGFloat = 21.0
    
    let offsetTime : CFTimeInterval = kAnimationDuration * 0.7
    var beginTime : CFTimeInterval = 0
    
    //圆形动画
    var circleLayer : CAShapeLayer!
    //线动画
    var lineLayer : CAShapeLayer!
    //方形动画
    var squareLayer : CAShapeLayer!
    //被用于视图的遮罩。当边界跟随动画变化时，被用于在一个简单动画中折叠其他的视图层。
    var maskLayer : CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor.orange
        
        circleLayer = self.circlerLayerInit()
        lineLayer = self.lineLayerInit()
        squareLayer = self.squareLayerInit()
        maskLayer = self.createLayer()
        
        layer.addSublayer(circleLayer)
        layer.addSublayer(lineLayer)
        layer.addSublayer(squareLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func startAnimation() {
        layer.anchorPoint = CGPoint.zero
        beginTime = CACurrentMediaTime()
        circlerLayerAnimation()
        lineLayerAniamtion()
        squearLayerAniamtion()
    }
    
    func createLayer() -> CAShapeLayer {
        let layer = CAShapeLayer.init()
        return layer
    }
}

//MARK:- 创建Layer
extension WBUberAnimationLogoView{
    //MARK: 圆形layer
    fileprivate func circlerLayerInit() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = radius
        //CGPoint.init(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
        layer.path = UIBezierPath.init(arcCenter: CGPoint.zero,
                                       radius: radius / 2.0,
                                       startAngle: CGFloat(-Float.pi / 2),
                                       endAngle: CGFloat(3 * Float.pi / 2),
                                       clockwise: true).cgPath
        layer.strokeColor = UIColor.white.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }
    //MARK: 竖线layer
    fileprivate func lineLayerInit() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.position = CGPoint.zero
        layer.frame = CGRect.zero
        layer.lineWidth = 5
        layer.allowsGroupOpacity = true
        layer.strokeColor = UIColor.theme().cgColor
        
        let bezier = UIBezierPath()
        bezier.move(to: CGPoint.zero)
        bezier.addLine(to: CGPoint.init(x: 0.0, y: -radius))
        
        layer.path = bezier.cgPath
        return layer
    }
    //MARK: 中心方块的layer
    fileprivate func squareLayerInit() -> CAShapeLayer {
        let layer = CAShapeLayer()
        
        layer.position = CGPoint.zero
        layer.frame = CGRect(x: -squareLayerLength / 2.0, y: -squareLayerLength / 2.0, width: squareLayerLength, height: squareLayerLength)
        layer.allowsGroupOpacity = true
        layer.cornerRadius = 1.5
        layer.backgroundColor = UIColor.theme().cgColor
        
        return layer
    }
}


//MARK:- 动画
extension WBUberAnimationLogoView{
    //MARK: 圆形动画
    fileprivate func circlerLayerAnimation() {
        //strokeEnd 就是画个圆圈
        let strokeEndAni = CAKeyframeAnimation.init(keyPath: "strokeEnd")
        strokeEndAni.timingFunction = strokeEndTimingFun
        strokeEndAni.duration = kAnimationDuration - kAnimationDurationDelay
        strokeEndAni.values = [0.0 , 1.0]
        strokeEndAni.keyTimes = [0.0 , 1.0]
        
        //transform
        let transformAni = CABasicAnimation.init(keyPath: "transform")
        transformAni.timingFunction = strokeEndTimingFun
        transformAni.duration = kAnimationDuration - kAnimationDurationDelay
        
        var transStar = CATransform3DMakeRotation(CGFloat(-Double.pi / 4.0), 0, 0, 1)
        transStar = CATransform3DScale(transStar, 0.25, 0.25, 1)
        transformAni.fromValue = NSValue.init(caTransform3D: transStar)
        transformAni.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1, 1, 1))
        
        //group
        let groupAni = CAAnimationGroup()
        groupAni.animations = [strokeEndAni , transformAni]
        groupAni.repeatCount = Float.infinity
        groupAni.duration = kAnimationDuration
        groupAni.beginTime = beginTime
        groupAni.timeOffset = offsetTime
        
        circleLayer.add(groupAni, forKey: "groupAni")
    }
    //MARK: 线的动画-变大-变小
    fileprivate func lineLayerAniamtion() {
        //lineWidth
        let lineWidthAni = CAKeyframeAnimation.init(keyPath: "lineWidth")
        lineWidthAni.values = [0.0 , 5.0 , 0.0]
        lineWidthAni.timingFunctions = [strokeEndTimingFun , circleLayerTimingFun]
//        lineWidthAni.duration = kAnimationDuration
        lineWidthAni.keyTimes = [0.0 , ((kAnimationDuration - kAnimationDurationDelay) / kAnimationDuration) as NSNumber , 1.0]
        
        //transfrom
        let transfromAni = CAKeyframeAnimation.init(keyPath: "transform")
        transfromAni.timingFunctions = [strokeEndTimingFun , circleLayerTimingFun]
        transfromAni.duration = kAnimationDuration
        transfromAni.keyTimes = [0.0 , ((kAnimationDuration - kAnimationDurationDelay) / kAnimationDuration) as NSNumber , 1.0]
        
        var transfrom = CATransform3DMakeRotation(CGFloat(-Double.pi / 4.0), 0, 0, 1)
        transfrom = CATransform3DScale(transfrom, 0.25, 0.25, 1)
        transfromAni.values = [NSValue.init(caTransform3D: transfrom),
                               NSValue.init(caTransform3D: CATransform3DIdentity),
                               NSValue.init(caTransform3D: CATransform3DMakeScale(0.15, 0.15, 1))]
        
        let groupAni = CAAnimationGroup()
        groupAni.animations = [lineWidthAni , transfromAni]
        groupAni.repeatCount = Float.infinity
        groupAni.duration = kAnimationDuration
        groupAni.isRemovedOnCompletion = false
        groupAni.beginTime = beginTime
        groupAni.timeOffset = offsetTime
        
        lineLayer.add(groupAni, forKey: "looping")
    }
    //MARK: 方块动画
    fileprivate func squearLayerAniamtion() {
        // bounds
        let b1 = NSValue(cgRect: CGRect(x: 0.0, y: 0.0, width: 2.0/3.0 * squareLayerLength, height: 2.0/3.0  * squareLayerLength))
        let b2 = NSValue(cgRect: CGRect(x: 0.0, y: 0.0, width: squareLayerLength, height: squareLayerLength))
        let b3 = NSValue(cgRect: CGRect.zero)
        
        let boundsAnimation = CAKeyframeAnimation(keyPath: "bounds")
        boundsAnimation.values = [b1, b2, b3]
        boundsAnimation.timingFunctions = [fadeInSquareTimingFunction, squareLayerTimingFunction]
        boundsAnimation.duration = kAnimationDuration
        boundsAnimation.keyTimes = [0, ((kAnimationDuration - kAnimationDurationDelay) / kAnimationDuration) as NSNumber, 1]
        
        // backgroundColor
        let backgroundColorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        backgroundColorAnimation.fromValue = UIColor.white.cgColor
        backgroundColorAnimation.toValue = UIColor.theme().cgColor
        backgroundColorAnimation.timingFunction = squareLayerTimingFunction
        backgroundColorAnimation.fillMode = kCAFillModeBoth
        backgroundColorAnimation.beginTime = kAnimationDurationDelay * 2.0 / kAnimationDuration
        backgroundColorAnimation.duration = kAnimationDuration / (kAnimationDuration - kAnimationDurationDelay)
        
        // Group
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [boundsAnimation, backgroundColorAnimation]
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.duration = kAnimationDuration
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.beginTime = beginTime
        groupAnimation.timeOffset = offsetTime
        squareLayer.add(groupAnimation, forKey: "looping")
    }
}










