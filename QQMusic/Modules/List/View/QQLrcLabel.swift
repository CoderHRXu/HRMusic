//
//  QQLrcLabel.swift
//  QQMusic
//
//  Created by haoran on 2018/11/13.
//  Copyright © 2018年 haoran. All rights reserved.
//

import UIKit

class QQLrcLabel: UILabel {

    var progress = 0.0 {
        
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 填充色
        UIColor.green.set()
        
        let progressFloat = CGFloat(progress)
        
        let fillRect = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * progressFloat, height: rect.size.height)
        
        UIRectFillUsingBlendMode(fillRect, .sourceIn)
    }

}
