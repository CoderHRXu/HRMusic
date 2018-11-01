//
//  QQMusicDataTool.swift
//  QQMusic
//
//  Created by haoran on 2018/11/1.
//  Copyright © 2018年 haoran. All rights reserved.
//

import Foundation

class QQMusicDataTool: NSObject {
    
    class func getMusicList(result : ( _ musicList: [QQMusicModel] )->())  {
        
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            result([QQMusicModel]())
            return
        }
        
        guard let dictArray = NSArray.init(contentsOfFile: path) else {
            result([QQMusicModel]())
            return
        }
        
        var resultMs = [QQMusicModel]()
        for dic in dictArray {
            
            let musicM = QQMusicModel(dict: dic as! [String : Any])
            resultMs.append(musicM)
            
        }
        
        result(resultMs)
    }
}
