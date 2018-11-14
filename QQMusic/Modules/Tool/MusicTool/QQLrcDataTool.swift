//
//  QQLrcDataTool.swift
//  QQMusic
//
//  Created by haoran on 2018/11/14.
//  Copyright © 2018年 haoran. All rights reserved.
//

import UIKit

class QQLrcDataTool: NSObject {

    class func getRowLrcM(currentTime: TimeInterval, lrcMs : [QQLrcModel]) -> (row: Int, lrcM: QQLrcModel) {
        
        let count = lrcMs.count
        
        for i in 0..<count {
            
            let lrcM = lrcMs[i]
            if currentTime >= lrcM.beginTime && currentTime <= lrcM.endTime{
                return (i, lrcM)
            }
        }
        return (0 , QQLrcModel())
    }
    
    
    class func getLrcData(fileName: String) -> [QQLrcModel] {
        
        let path = Bundle.main.path(forResource: fileName, ofType: nil)
        guard path != nil else {
            return [QQLrcModel]()
        }
        
        var lrcContent = ""
        do {
            lrcContent = try String(contentsOfFile: path!)
        } catch  {
            print(error)
        }
        
        let lrcStrArray = lrcContent.components(separatedBy: "\n")
        var lrcMs = [QQLrcModel]()
        
        for lrcStr in lrcStrArray {
            
            // 1.过滤垃圾数据
            if lrcStr.contains("[ti:") || lrcStr.contains("[al:") || lrcStr.contains("[ar:") {
                continue
            }
            
            let lrcM = QQLrcModel()
            lrcMs.append(lrcM)
            // 2. 拿到的是不是, 才是真正的可以解析的字符串
            // [00:00.89]传奇
            // 2.1 处理垃圾数据
            // 00:00.89]传奇
            let resultStr = lrcStr.replacingOccurrences(of: "[", with: "")
            
            // 2.2 开始真正的解析
            // 处理成 ["00:00.89","传奇"]
            let timeAndContent = resultStr.components(separatedBy: "]")
            if timeAndContent.count == 2{
                let time        = timeAndContent[0]
                lrcM.beginTime  = TimeTool.getTimeInterval(formatTine: time)
                let content     = timeAndContent[1]
                lrcM.lrcStr     = content;
            }
            
        }
        
        
        // 设置lrcM结束时间
        let count = lrcMs.count
        
        for i in 0..<count {
            if i != count - 1{
                lrcMs[i].endTime = lrcMs[i + 1].beginTime
            }
        }
        
        return lrcMs
    }
}
