//
//  ZLBlurButton.swift
//  ZLCamera
//
//  Created by 周麟 on 2018/6/13.
//  Copyright © 2018年 周麟. All rights reserved.
//

import UIKit
import SnapKit

enum ZLBlurButtonActionType{
    case tap
    case longPress
}

class ZLBlurButton: UIVisualEffectView {

    let circleView : UIView = UIView()
    
    private var tapGesture : UITapGestureRecognizer? = nil
    private var longGesture : UILongPressGestureRecognizer? = nil
    private var targetDic : Dictionary<ZLBlurButtonActionType,Any?> = [.tap:nil,.longPress:nil]
    private var selectorDic : Dictionary<ZLBlurButtonActionType,Selector?> = [.tap:nil,.longPress:nil]
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)

        self.circleView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        self.contentView.addSubview(self.circleView)
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        self.longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        
        self.circleView.addGestureRecognizer(self.tapGesture!)
        self.circleView.addGestureRecognizer(self.longGesture!)
        
        self.circleView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(12)
            make.left.equalTo(self.contentView).offset(12)
            make.right.equalTo(self.contentView).offset(-12)
            make.bottom.equalTo(self.contentView).offset(-12)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc private func tap(_ : UITapGestureRecognizer){
        let animation : CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.25
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        let animationValue1 = CATransform3DMakeScale(1.0, 1.0, 1.0)
        let animationValue2 = CATransform3DMakeScale(0.8, 0.8, 1.0)
        let animationValue3 = CATransform3DMakeScale(0.6, 0.6, 1.0)
        let animationValue4 = CATransform3DMakeScale(1.0, 1.0, 1.0)
        animation.values = [animationValue1,animationValue2,animationValue3,animationValue4]
        animation.timingFunction = CAMediaTimingFunction(name: "easeInEaseOut")
        animation.delegate = self
        self.circleView.layer.add(animation, forKey: nil)
        
    }
    
    @objc private func longPress(_ : UILongPressGestureRecognizer){
        
    }
    
    func addTarget(target : Any?, selector: Selector?, type : ZLBlurButtonActionType!) {
        self.targetDic[type] = target
        self.selectorDic[type] = selector
    }
}

extension ZLBlurButton : CAAnimationDelegate{
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.targetDic[.tap] != nil && self.selectorDic[.tap] != nil{
            let target = self.targetDic[.tap]
            let selector = self.selectorDic[.tap]
            Thread.detachNewThreadSelector(selector as! Selector, toTarget: target as Any, with: nil)
        }
    }
}