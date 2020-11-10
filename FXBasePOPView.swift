//
//  FXBasePOPView.swift
//  IM_Client_Swift
//
//  Created by wq on 2020/6/2.
//  Copyright © 2020 wq. All rights reserved.
//

import UIKit

class FXBasePOPView: UIView {

    /// 配置
    let cof = WXMPOPCof()

    /// 边距
    var contentEdge: CGFloat = 0
    var messageEdge: CGFloat = 0
    var roundedCorners: CGFloat? 

    ///  垂直偏移
    var verticalOffset: CGFloat = 0

    var touchBlackHiden: Bool = true
    var touchBtnHiden: Bool = true
    
    /// .bottom模式是否有收回动画
    var decline: Bool = false

    ///  类型
    var animationType: WXMPOPCof.AnimationType = .def
    var chooseType: WXMPOPCof.ChooseType = .double
    var priorityType: WXMPOPCof.PriorityType = .wait

    /// 显示弹窗的控制器界面 nil为root
    weak var viewController: UIViewController?
    private var popAnimation: FXPOPAnimation?

    // 回掉
    var callbackInt: ((Int) -> Void)?
    var callbackString: ((String) -> Void)?

    /// 显示
    func showpopupView() {
        viewController?.view.endEditing(true)
        (UIApplication.shared.delegate?.window)??.endEditing(true)
        animationObj.animationShow()
    }

    /// 隐藏
    @objc func hidepopupView() {
        animationObj.animationHide()
    }
    
    /// 子类根据需要看是否需要返回
    private func displayViewController() -> UIViewController? {
        return self.viewController
    }

    @objc func touchEvent(sender: UIButton) {
        var index = max(sender.tag - 1, 0)
        if sender == cancleBtn { index = 0 }
        if callbackInt != nil { callbackInt!(index) }
        if callbackString != nil { callbackString!(sender.titleLabel?.text ?? "") }
        if touchBtnHiden { hidepopupView() }
    }

    public lazy var animationObj: FXPOPAnimation = {
        var animationObj = FXPOPAnimation(content: self)
        return animationObj
    }()

    
    public lazy var titleLabel: UILabel = {
        var titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textAlignment = .center
        titleLabel.textColor = cof.titleColor
        titleLabel.font = cof.titleFont
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    public lazy var titleLine: CALayer = {
        var titleLine = CALayer()
        titleLine.backgroundColor = cof.lineColor.cgColor
        return titleLine
    }()
    
    public lazy var messageText: UITextView = {
        var messageText = UITextView(frame: CGRect.zero)
        messageText.textAlignment = .left
        messageText.textColor = cof.messageColor
        messageText.font = .systemFont(ofSize: cof.messageFont)
        messageText.isSelectable = false
        messageText.isScrollEnabled = false
        return messageText
    }()
    
    public lazy var btnContainer: UIView = {
        var btnContainer = UIView(frame: .zero)
        btnContainer.backgroundColor = .clear
        btnContainer.layer.addSublayer(btnHorizontalLine)
        btnContainer.layer.addSublayer(btnVerticalLine)
        return btnContainer
    }()
        
    public lazy var btnHorizontalLine: CALayer = {
        var btnHorizontalLine = CALayer()
        btnHorizontalLine.backgroundColor = cof.lineColor.cgColor
        return btnHorizontalLine
    }()
    
    public lazy var btnVerticalLine: CALayer = {
        var btnVerticalLine = CALayer()
        btnVerticalLine.backgroundColor = cof.lineColor.cgColor
        return btnVerticalLine
    }()
    
    public lazy var cancleBtn: UIButton = {
        var cancleBtn = UIButton(frame: .zero)
        cancleBtn.titleLabel?.font = .systemFont(ofSize: cof.btnFont)
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(cof.btnColor, for: .normal)
        cancleBtn.setBackgroundImage(imageFromColor_k(color: .white), for: .normal)
        cancleBtn.setBackgroundImage(imageFromColor_k(color: cof.btnHighColor), for: .highlighted)
        cancleBtn.addTarget(self, action: #selector(touchEvent(sender:)), for: .touchUpInside)
        cancleBtn.tag = 1
        return cancleBtn
    }()
    
    public lazy var confirmBtn: UIButton = {
        var confirmBtn = UIButton(frame: .zero)
        confirmBtn.titleLabel?.font = .systemFont(ofSize: cof.btnFont)
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.setTitleColor(cof.btnColor, for: .normal)
        confirmBtn.setBackgroundImage(imageFromColor_k(color: .white), for: .normal)
        confirmBtn.setBackgroundImage(imageFromColor_k(color: cof.btnHighColor), for: .highlighted)
        confirmBtn.addTarget(self, action: #selector(touchEvent(sender:)), for: .touchUpInside)
        confirmBtn.tag = 2
        return confirmBtn
    }()
    
    func imageFromColor_k(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)

        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
}
