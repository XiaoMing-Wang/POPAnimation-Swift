//
//  WXMDefaultPOPView.swift
//  IM_Client_Swift
//
//  Created by wq on 2020/6/2.
//  Copyright © 2020 wq. All rights reserved.
// 

import UIKit
import Foundation

class FXDefaultPOPView: FXBasePOPView {
    
    private var automaticHeight: Bool = true
    
    convenience init() {
        self.init(frame: .zero)
        self.defaultConfiguration()
        self.initializationInterface()
        self.automaticLayout()
    }
    
    /// 默认配置
    func defaultConfiguration() {
        frame = CGRect(x: 0, y: 0, width: cof.popWidth, height: 0)
        layer.masksToBounds = true
        backgroundColor = .white
        
        touchBlackHiden = true
        touchBtnHiden = true
        priorityType = .wait
        animationType = .def
        chooseType = .double
    }
    
    /** 子类重写UI */
    func initializationInterface() {
        
    }
    
    func automaticLayout() {
        
    }
    
    /** 有popsTitle 或者 popsMessage的时候自适应 没有return */
    func setupAutomaticLayout() {
        if popsTitle == nil && popsMessage == nil { return }
               
        /** 标题和内容的最大宽度 */
        let maxWidth = (automaticHeight  ? totalWidth() : self.frame.size.width)
        let maxTitle = maxWidth - 2 * cof.contentLREdge * 1.0
        
        let maxflt = CGFloat(MAXFLOAT)
        let sizeTitleMaxH = titleLabel.sizeThatFits(CGSize(width: maxTitle, height: maxflt)).height
        let sizeTitleLimitH = titleLabel.sizeThatFits(CGSize(width: maxflt, height: maxflt)).height
                
        /** 标题上下间隔 */
        /** 标题上下间隔 */
        /** 标题上下间隔 */
        let titleEdge = (contentEdge == 0 ? cof.contentEdge : contentEdge);
        
        /** 设置标题frame */
        titleLabel.frame = CGRect(x: 0, y: titleEdge, width: maxTitle, height: sizeTitleMaxH)
        titleLabel.center = CGPoint(x: maxWidth / 2, y: titleLabel.center.y)
        if sizeTitleMaxH == sizeTitleLimitH { titleLabel.numberOfLines = 1 }
        if sizeTitleMaxH > sizeTitleLimitH { titleLabel.numberOfLines = 0 }
        titleLabel.textAlignment = .center
             
        /** 内容上下间隔 */
        /** 内容上下间隔 */
        /** 内容上下间隔 */
        var titleBottom = titleLabel.frame.origin.y + titleLabel.frame.size.height;
        if (popsTitle == nil || popsTitle?.count == 0) { titleBottom = 0 }
        let messageTop = titleBottom + (messageEdge == 0 ? cof.messageEdge : messageEdge);
        let messageWidth = maxWidth - 2 * cof.messageLREdge;

        let sizeMaxHeight = messageText.sizeThatFits(CGSize(width: maxflt, height: maxflt)).height
        var sizeLimitHeight = messageText.sizeThatFits(CGSize(width: messageWidth, height: maxflt)).height
        if (popsMessage == nil || popsMessage?.count == 0) { sizeLimitHeight = 0 }
                 
        /** 设置标题message frame */
        messageText.textAlignment = .center
        messageText.frame = CGRect(x: 0, y: messageTop, width: messageWidth, height: sizeLimitHeight)
        messageText.center = CGPoint(x: maxWidth / 2, y: messageText.center.y)
        if sizeLimitHeight > sizeMaxHeight { messageText.textAlignment = .left }

    }
    
    /** 校验高度 automaticHeight 为YES代表外部手动设置高度 */
    func setupCheckHeight() {
        if automaticHeight == false { return }
        
        let btnHeight = (cancleBtn.frame.size.height > 0) ? cancleBtn.frame.size.height : cof.btnHeight
        let safeHeight = CGFloat((judgeIPhoneX() && animationType == .bottom) ? 30.0 : 0.0)
        
        if (popsMessage != nil && popsMessage?.count ?? 0 > 0) {

            let bottom = messageText.frame.origin.y + messageText.frame.size.height;
            let msgEdge = (messageEdge == 0) ? cof.messageEdge : messageEdge
            let allHeight = bottom + btnHeight + msgEdge + 2.5 + safeHeight
            frame = CGRect(x: 0, y: 0, width: totalWidth(), height: allHeight)
            automaticHeight = true
            
        } else if (popsTitle != nil && popsTitle?.count ?? 0 > 0) {
            
            let bottom = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
            let titleEdg = (contentEdge == 0) ? cof.contentEdge : contentEdge;
            let allHeight = bottom + btnHeight + titleEdg + 2.5 + safeHeight
            frame = CGRect(x: 0, y: 0, width: totalWidth(), height: allHeight)
            automaticHeight = true
        }
    }
    
    /** 修改弹窗类型 */
    override var animationType: WXMPOPCof.AnimationType {
        didSet {
            if (animationType == .def) {
                
                layer.cornerRadius = self.roundedCorners ?? cof.roundedCorners
                chooseType = .double
                
            } else if (animationType == .bottom) {
                
                layer.cornerRadius = self.roundedCorners ?? 0
                chooseType = .confirm
            }
        }
    }
    
    /** 设置标题 */
    var popsTitle: String? {
        didSet {
            if popsTitle == nil { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.25
            let attributes = [
                NSAttributedString.Key.font: titleLabel.font as Any,
                NSAttributedString.Key.foregroundColor: titleLabel.textColor as Any,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ] as [NSAttributedString.Key: Any]

            titleLabel.attributedText = NSAttributedString(string: popsTitle!, attributes: attributes )
            addSubview(titleLabel)
        }
    }
    
    /** 设置信息 */
    var popsMessage: String? {
        didSet {
            if popsMessage == nil { return }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 1.0
            paragraphStyle.lineBreakMode = .byCharWrapping

            let attributes = [
                NSAttributedString.Key.font: messageText.font as Any,
                NSAttributedString.Key.foregroundColor: messageText.textColor as Any,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ] as [NSAttributedString.Key: Any]

            messageText.attributedText = NSAttributedString(string: popsMessage!, attributes: attributes)
            addSubview(messageText)
        }
    }
    
    /** 设置按钮类型 */
    override var chooseType: WXMPOPCof.ChooseType {
        didSet {
            
            if (chooseType == .none) {
                
                btnContainer.removeFromSuperview()
                cancleBtn.removeFromSuperview()
                confirmBtn.removeFromSuperview()
                              
            } else if (chooseType == .cancel || chooseType == .confirm) {

                if (chooseType == .cancel) {
                    btnContainer.addSubview(cancleBtn)
                    confirmBtn.removeFromSuperview()
                                      
                } else {
                    
                    btnContainer.addSubview(confirmBtn)
                    cancleBtn.removeFromSuperview()
                }
                
                addSubview(btnContainer)
                btnContainer.layer.addSublayer(btnHorizontalLine)
                btnVerticalLine.removeFromSuperlayer()
                
            } else if (chooseType == .double) {
                
                addSubview(btnContainer)
                btnContainer.addSubview(cancleBtn)
                btnContainer.addSubview(confirmBtn)
                btnContainer.layer.addSublayer(btnHorizontalLine)
                btnContainer.layer.addSublayer(btnVerticalLine)
                
            }
        }
    }
    
    /** 设置按钮默认frame */
    func setDefaultOptions() {
        let totalWidth: CGFloat = self.frame.size.width
        let totalHeight: CGFloat = self.frame.size.height
        let centerX: CGFloat = totalWidth / 2.0
        let btnHeight: CGFloat = cancleBtn.frame.size.height > 0 ? cancleBtn.frame.size.height : cof.btnHeight
        let safeHeight: CGFloat = (judgeIPhoneX() && animationType == .bottom) ? 30.0 : 0.0
        let btnTop: CGFloat = totalHeight - btnHeight - safeHeight
        
        if (chooseType == .cancel || chooseType == .confirm) {
            
            cancleBtn.frame = CGRect(x: 0, y: 0, width: totalWidth, height: btnHeight)
            confirmBtn.frame = CGRect(x: 0, y: 0, width: totalWidth, height: btnHeight)
            
        } else if (chooseType == .double) {
            
            cancleBtn.frame = CGRect(x: 0, y: 0, width: centerX, height: btnHeight)
            confirmBtn.frame = CGRect(x: centerX, y: 0, width: centerX, height: btnHeight)
        }
        
        btnContainer.frame = CGRect(x: 0, y: btnTop, width: totalWidth, height: btnHeight)
        btnHorizontalLine.frame = CGRect(x: 0, y: 0, width: totalWidth, height: 0.5)
        btnVerticalLine.frame = CGRect(x: centerX, y: 0, width: 0.5, height: btnHeight)
    }
    
    /** 修改frame */
    override var frame: CGRect {
        didSet {
            automaticHeight = (frame.size.height == 0)
        }
    }
    
    /**  按钮点击事件 */
    override func touchEvent(sender: UIButton) {
        super.touchEvent(sender: sender)
    }
    
    override func didMoveToSuperview() {
        if superview == nil { return }
        setupAutomaticLayout()
        setupCheckHeight()
        setDefaultOptions()
    }
    
    /// 总宽度
    func totalWidth() -> CGFloat {
        return (animationType == .bottom) ? UIScreen.main.bounds.size.width : cof.popWidth
    }
    
    func judgeIPhoneX() -> Bool {
        if #available(iOS 11, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
        } else {
            return false
        }
    }
}
