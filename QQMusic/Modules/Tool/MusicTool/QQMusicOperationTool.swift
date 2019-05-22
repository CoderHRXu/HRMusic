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
        
        musicMessageModel.musicM    = musicMList?[index]
        
        musicMessageModel.costTime  = tool.player?.currentTime ?? 0
        musicMessageModel.totalTime = tool.player?.duration ?? 0
        musicMessageModel.isPlaying = tool.player?.isPlaying ?? false
        
        return musicMessageModel
    }
    
    /// 播放音乐
    ///
    /// - Parameter music: 音乐
    func playMusic(music: QQMusicModel) {
        
        let fileName = music.filename ?? ""
        tool.playMusic(name: fileName)
        
        if musicMList == nil {
            print("没有播放列表")
            return
        }
        
        index = (musicMList?.firstIndex(of: music))!
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
    
    /// 上一曲
    func playPreviousSong() {
        
        index -= 1
        
        if let tempList = musicMList{
            let musicM = tempList[index]
            playMusic(music: musicM)
        }
    }
    
    
    /// 指定时间点播放
    ///
    /// - Parameter timeInterval: 时间
    func jumpTo(timeInterval: TimeInterval) {
        tool.jumpTo(timeInterval: timeInterval)
    }
}


extension QQMusicOperationTool {
    
    
    /// 设置锁屏信息
    func setupLockScreenMsg() {
        
        let musicMM                 = getNewMessageModel()
        // 展示锁屏信息
        
        // 1.获取锁屏播放中心
        let playCenter              = MPNowPlayingInfoCenter.default()
        
        // 当前正在播放的歌词信息
        // 1. 根据当前的歌词文件名称, 获取所有的歌词数据模型列表
        let lrcMs                   = QQLrcDataTool.getLrcData(fileName: (musicMM.musicM!.lrcname!))
        
        // 2. 根据列表, 以及当前的播放时间, 获取当前的歌词数据模型
        let rowLrcM                 = QQLrcDataTool.getRowLrcM(currentTime: musicMM.costTime, lrcMs: lrcMs)
        let lrcM                    = rowLrcM.lrcM
        
        // 1.1 创建字典
        let songName                = musicMM.musicM?.name ?? "未知歌曲"
        let singer                  = musicMM.musicM?.singer ?? "未知歌手"
        let costTime                = musicMM.costTime
        let totalTime               = musicMM.totalTime
        
        if musicMM.musicM?.icon != nil {
            
            if let image = UIImage.init(named: (musicMM.musicM?.icon!)!) {
                artwork = MPMediaItemArtwork(image: image)
            }
            
        }
    
        
        var infoDict:[String : Any] = [
            // 适配iOS11以上
            // 歌曲名
            MPMediaItemPropertyTitle: songName + " - " + singer,
            // 歌手
            MPMediaItemPropertyArtist: lrcM.lrcStr.count > 0 ?  lrcM.lrcStr : " ",
            // 当前播放时间
            MPNowPlayingInfoPropertyElapsedPlaybackTime: costTime,
            // 总时长
            MPMediaItemPropertyPlaybackDuration: totalTime
        ]
        
        if artwork != nil {
            infoDict[MPMediaItemPropertyArtwork] = artwork!
        }
        
        // 2.给锁屏中心赋值
        playCenter.nowPlayingInfo = infoDict
        
        // 3.接受远程事件
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        
        
        
    }
}
