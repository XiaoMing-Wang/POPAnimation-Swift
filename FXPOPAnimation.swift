//
//  FXPOPAnimation.swift
//  IM_Client_Swift
//
//  Created by wq on 2020/6/2.
//  Copyright © 2020 wq. All rights reserved.
//

import UIKit

class FXPOPAnimation: UIView {

    /// 所有wait的数组
    static var allPOPArray: [UIView] = []
    private var contentView: UIView? = nil

    var interactivePop: Bool?
    var isAnimation: Bool = false
    var contentRect: CGRect? = nil

    /// 黑色容器
    private var blackContainer: UIControl? = nil

    convenience init(content: UIView) {
        self.init()
        self.contentView = content
        self.setInterface()
        FXPOPAnimation.allPOPArray.append(self)
    }
    
    /// 配置
    func setInterface() {
        let content = self.contentView as? FXBasePOPView
        let screenBounds = UIScreen.main.bounds

        tag = WXMPOPCof.popSign
        frame = screenBounds
        isUserInteractionEnabled = true

        content?.alpha = 0;
        content?.center = CGPoint(x: screenBounds.size.width / 2, y: screenBounds.size.height / 2)
        
        blackContainer = UIControl(frame: screenBounds)
        blackContainer?.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        blackContainer?.isUserInteractionEnabled = true
        blackContainer?.alpha = 0
        
        if blackContainer != nil { addSubview(blackContainer!) }
        if content != nil { addSubview(content!) }
        
        /**< 点击黑色背景消失 */
        touchBlackHiden(content?.touchBlackHiden ?? true)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(removeFromSuperview),
            name: NSNotification.Name(rawValue: WXMPOPCof.hiddenNotice),
            object: nil
        )
    }
   
    func animationShow() {
        guard var superView: UIView = UIApplication.shared.keyWindow else { return }
        if self.superview != nil {
            superView = self.superview!
        }
        
        let content = self.contentView as? FXBasePOPView
        let contentController = content?.viewController
        if contentController != nil {
            superView = contentController!.view
        }
        
        if contentController is UINavigationController {
            let navigation = contentController as! UINavigationController
            interactivePop = navigation.interactivePopGestureRecognizer?.isEnabled
            navigation.interactivePopGestureRecognizer?.isEnabled = false
            superView = navigation.view
        }
        
        self.bounds = superView.bounds
        self.blackContainer?.bounds = superView.bounds
        
        /// 上一个正在显示的弹窗
        let previous = superView.viewWithTag(WXMPOPCof.popSign) as? FXPOPAnimation
        let previousContent = previous?.contentView as? FXBasePOPView
        
        /** 表示这个弹窗是需要等待的弹窗 在上一个消失后继续弹出 */
        if (previous != nil && previousContent?.priorityType == .wait) { return }

        /** 表示高级弹窗在显示 低级弹窗直接忽略 */
        if (previous != nil && previousContent?.priorityType == .high &&
            (content?.priorityType == .def || content?.priorityType == .low)) {
            deleteLastOne()
            return
        }

        let delay = (previous == nil) ? 0.0 : 0.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            superView.addSubview(self)
            self.setDifferentAnimations()
        }
    }
    
    /// 不同的动画
    func setDifferentAnimations() {
        if isAnimation { return }
        
        isAnimation = true
        blackContainer?.alpha = 0
        
        let content = self.contentView as? FXBasePOPView
        let offset = content?.verticalOffset
        
        /// 中间
        if content?.animationType == .def {
                        
            content?.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2 + (offset ?? 0))
            content?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
                
                self.blackContainer?.alpha = 1.0
                self.contentView?.alpha = 1.0
                self.contentView?.transform = CGAffineTransform.identity
                
            }) { (animation) in
                self.isAnimation = false
            }
            
            
        } else if content?.animationType == .bottom {
            
            let offy = UIScreen.main.bounds.size.height - (self.contentView?.frame.size.height ?? 0)
            self.contentOffY(offY: UIScreen.main.bounds.size.height)
            self.contentView?.alpha = 1.0
            self.contentRect = self.contentView?.frame
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                                
                self.blackContainer?.alpha = 1.0
                self.contentOffY(offY: offy)
                
            }) { (animation) in
                self.isAnimation = false
            }
            
        }
        
    }
    
    @objc func animationHide() {
        contentView?.endEditing(true)
        
        let content = self.contentView as? FXBasePOPView
        let contentVC = content?.viewController
        var delay = 0.15
        
        if content?.animationType == .bottom {
            delay = (content?.decline ?? false) ? 0.25 : 0.10
        }

        UIView.animate(withDuration: delay, delay: 0, options: .layoutSubviews, animations: {

            self.blackContainer?.alpha = 0.0
            if content?.decline ?? false {
                self.contentOffY(offY: UIScreen.main.bounds.size.height)
            } else {
                self.contentView?.alpha = 0.0
            }
            
        }) { _ in

            self.isAnimation = false
            self.removeFromSuperview()
            self.deleteLastOne()
            self.judgeNextPopover(0.0)
            if contentVC is UINavigationController {
                let navigation = contentVC as! UINavigationController
                navigation.interactivePopGestureRecognizer?.isEnabled = self.interactivePop ?? true
            }
        }
    }
    
    /// 删除上一个
    func deleteLastOne() {
        guard let idx = FXPOPAnimation.allPOPArray.firstIndex(of: self) else { return }
        FXPOPAnimation.allPOPArray.remove(at: idx)
    }
    
    /// 判断是否有未弹出的弹窗
    func judgeNextPopover(_ delay: Double) {
        let animationObject = FXPOPAnimation.allPOPArray.first as? FXPOPAnimation
        if animationObject != nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay + 0.1) {
                animationObject?.animationShow()
            }
        }
    }

    func contentOffY(offY: CGFloat) {
        var frame: CGRect = self.contentView!.frame
        frame.origin.y = offY
        self.contentView?.frame = frame
    }
    
    /// 点击事件
    func touchBlackHiden(_ touchHiden: Bool) {
        if touchHiden {
            blackContainer?.addTarget(self, action: #selector(animationHide), for: .touchUpInside)
        } else {
            blackContainer?.removeTarget(self, action: #selector(animationHide), for: .touchUpInside)
        }
    }
    
}
