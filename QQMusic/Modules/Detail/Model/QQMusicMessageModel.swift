//
//  QQMusicMessageModel.swift
//  QQMusic
//
//  Created by haoran on 16/5/17.
//  Copyright © 2016年 xuhaoran. All rights reserved.
//

import UIKit

class QQMusicMessageModel: NSObject {


    var musicM : QQMusicModel?
    /// 当前播放时长
    var costTime : TimeInterval = 0
    /// 总时长
    var totalTime : TimeInterval = 0
    /// 正在播放
    var isPlaying : Bool = false
    
    /// 当前播放时长(格式化后)
    var costTimeFormat :String {
        get{
            return TimeTool.getFormatTime(time: costTime)
        }
    }
    
    /// 总时长(格式化后)
    var totalTimeFormat : String {
        get{
            return TimeTool.getFormatTime(time: totalTime)
        }
    }
    
    
    
}
