//
//  TimeTool.swift
//  QQMusic
//
//  Created by haoran on 2018/11/2.
//  Copyright © 2018年 haoran. All rights reserved.
//

import UIKit

class TimeTool: NSObject {

    class func getFormatTime(time : TimeInterval) -> String {
        // time 123
        // 03:12
        let min = Int(time / 60)
        let sec = Int(time) % 60
        
        let str = String(format: "%02d:%02d", min, sec)
        return str
        
    }
    
    class func getTimeInterval(formatTine: String) -> TimeInterval {
        
        //  00:00.89  -> 多少秒
        let minAndSec = formatTine.components(separatedBy: ":")
        if minAndSec.count == 2 {
            let min = TimeInterval(minAndSec[0]) ?? 0
            let sec = TimeInterval(minAndSec[1]) ?? 0
            
            return min * 60 + sec
        }
        
        return 0
    }
}
