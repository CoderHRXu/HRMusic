//
//  QQMusicOperationTool.swift
//  QQMusic
//
//  Created by haoran on 2018/11/2.
//  Copyright © 2018年 haoran. All rights reserved.
//

import Foundation
import MediaPlayer

class QQMusicOperationTool: NSObject {
    
    var drawRow: Int = -1
    
    // 音乐播放列表
    var musicMList : [QQMusicModel]?
    // 创建单例
    static let shareInstance = QQMusicOperationTool()
    
    var index = 0 {
        
        didSet{
            if index < 0 {
                
                if musicMList != nil {
                    index = musicMList!.count - 1
                }
            }
            if index > (musicMList?.count ?? 0) - 1 {
                index = 0
            }
        }
    }
    
    let tool = QQMusicTool()
    
    
    private var artwork : MPMediaItemArtwork?
    
    private var musicMessageModel = QQMusicMessageModel()
    
    /// 获得最新的信息
    func getNewMessageModel() -> QQMusicMessageModel {
        
        musicMessageModel.musicM = musicMList?[index]
        
        musicMessageModel.costTime = tool.player?.currentTime ?? 0
        musicMessageModel.totalTime = tool.player?.duration ?? 0
        musicMessageModel.isPlaying = tool.player?.isPlaying ?? false
        
        return musicMessageModel
    }
    
    func playMusic(music: QQMusicModel) {
        
        let fileName = music.filename ?? ""
        tool.playMusic(name: fileName)
        
        if musicMList == nil {
            print("没有播放列表")
            return
        }
        
        index = (musicMList?.index(of: music))!
        
    }
    
    /// 播放
    func playCurrentMusic() {
        tool.resumeCurrentMusic()
    }
    
    /// 暂停
    func pauseCurrentMusic() {
        tool.pauseCurrentMusic()
    }
    
    /// 下一曲
    func playNextSong() {
        
        index += 1
        
        if let tempList = musicMList {
            let musicM = tempList[index]
            playMusic(music: musicM)
        }
    }
    
    func playPreviousSong() {
        
        index -= 1
        
        if let tempList = musicMList{
            let musicM = tempList[index]
            playMusic(music: musicM)
        }
    }
    
    
    func jumpTo(timeInterval: TimeInterval) {
        tool.jumpTo(timeInterval: timeInterval)
    }
}

