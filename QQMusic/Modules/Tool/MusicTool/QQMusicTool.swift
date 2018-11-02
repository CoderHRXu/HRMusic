//
//  QQMusicTool.swift
//  QQMusic
//
//  Created by haoran on 2018/11/2.
//  Copyright © 2018年 haoran. All rights reserved.
//

import UIKit
import AVKit

class QQMusicTool: NSObject {

    var player : AVAudioPlayer?
    
    
    override init() {
        super.init()
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            if #available(iOS 10.0, *) {
                try session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.allowAirPlay)
            } else {
//                session.category = .playback
            }
            
        } catch  {
            print(error)
        }
        
    }
    
    
    func playMusic(name : String) {
        
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            return
        }
        
        if url == player?.url {
            // 播放的同一首歌曲
            player?.play()
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error)
        }
        
        // 准备播放
        player?.prepareToPlay()
        
        player?.play()
    }
    
    
    /// 暂停
    func pauseCurrentMusic() {
        player?.pause()
    }
    
    /// 继续播放
    func resumeCurrentMusic() {
        player?.pause()
    }
    
    /// 跳转到指定时间播放
    ///
    /// - Parameter timeInterval: 指定时间
    func jumpTo(timeInterval: TimeInterval) {
        player?.currentTime = timeInterval
    }
}

extension QQMusicTool: AVAudioPlayerDelegate{
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("播放结束")
        NotificationCenter.default.post(name: .kPlayDidFinishNotification, object: nil)
    }
}
