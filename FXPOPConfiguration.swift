//
//  WXMPOPConfiguration.swift
//  IM_Client_Swift
//
//  Created by wq on 2020/6/2.
//  Copyright © 2020 wq. All rights reserved.
//
import UIKit
import Foundation

struct WXMPOPCof {
    
    /// 动画类型
    enum AnimationType {
        case def
        case bottom
    }
    
    /// 按钮样式
    enum ChooseType {
        case none
        case cancel
        case confirm
        case double
    }
    
    /// 弹窗优先级
    enum PriorityType {
        case def
        case wait
        case low
        case high
    }
    
    static let popSign:Int = 4004
    
    /// 弹窗宽度系统弹窗宽度270
    let popWidth: CGFloat = 270
    
    
    let sWidth: CGFloat = UIScreen.main.bounds.size.width
    
    /// 圆角 WXMPOPViewAnimationDefaultcal才有
    let roundedCorners: CGFloat = 12
    
    /// 标题上下间隔
    let contentEdge: CGFloat = 15
    
    /// 标题左右边距
    let contentLREdge: CGFloat = 14
    
    /// 描述上下间隔
    let messageEdge: CGFloat = 6.5
    
    /// 描述左右边距
    let messageLREdge: CGFloat = 14
    
    /// 按钮高度
    let btnHeight: CGFloat = 50
    
    /// 标题字号
    let titleFont: UIFont = .systemFont(ofSize: 16)

    /// 描述字号
    let messageFont: CGFloat = 16

    /// 按钮字号
    let btnFont: CGFloat = 16
    
    ///  颜色
    let titleColor: UIColor = kRGBA(45, 45, 45)
    let messageColor: UIColor = kRGBA(120, 120, 120)
    let btnColor: UIColor = kRGBA(35, 35, 35)
    let btnHighColor: UIColor = kRGBA(235, 235, 235)
    let lineColor: UIColor = kRGBA(200, 200, 200)

    ///  颜色
    static func kRGBA(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1);
    }

    static let hiddenNotice = "WXMPOPCof.hiddenNotice"
}
