//
//  MusicDetailViewController.swift
//  QQMusic
//
//  Created by haoran on 2018/11/2.
//  Copyright © 2018年 haoran. All rights reserved.
//

import UIKit

class MusicDetailViewController: UIViewController {

    /// 前景图片 1
    @IBOutlet weak var foreImageView: UIImageView!
    /// 歌曲总时长 1
    @IBOutlet weak var totalTimerLabel: UILabel!
    /// 歌曲名 1
    @IBOutlet weak var songNameLabel: UILabel!
    /// 歌手名 1
    @IBOutlet weak var singerNameLabel: UILabel!
    /// 背景图片 1
    @IBOutlet weak var backImageView: UIImageView!
    
    /// 播放/暂停按钮 待定
    @IBOutlet weak var playOrPauseBtn: UIButton!
    
    
    
    /// 歌词的背景视图(做动画使用) 0
    @IBOutlet weak var LrcBackView: UIScrollView!
    
    /// 已经播放的时长 n
    @IBOutlet weak var costTimeLabel: UILabel!
    /// 进度条 n
    @IBOutlet weak var slider: UISlider!
    /// 歌词显示框 n
    @IBOutlet weak var lrcLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    

}

// MARK: - Data
extension MusicDetailViewController{
    
    /// 当歌曲切换的时候,更新一次
    func setupDataOnce(){
        
    }

}
