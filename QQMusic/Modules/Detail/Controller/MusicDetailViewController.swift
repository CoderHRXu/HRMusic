//
//  MusicDetailViewController.swift
//  QQMusic
//
//  Created by haoran on 2018/11/2.
//  Copyright © 2018年 haoran. All rights reserved.
//

import UIKit

class MusicDetailViewController: UIViewController {

    @IBOutlet weak var imageW: NSLayoutConstraint!
    @IBOutlet weak var foreImageTopCons: NSLayoutConstraint!
    @IBOutlet weak var toolBarTopCons: NSLayoutConstraint!
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
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    var timer : Timer?
    
    var displayLink :CADisplayLink?
    
    lazy var lrcVC: LrcViewController = {
        let vc = LrcViewController()
        return vc
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewOnce()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTimer()
        setupDataOnce()
        addDisplayLink()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupFrame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
        removeDisplayLink()
    }
    
    
    // MARK: - Action
    /// 返回列表界面
    @IBAction func close(sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }

    /// 下一首按钮点击
    @IBAction func nextSong() {
//        addDisapperAnimation()
        QQMusicOperationTool.shareInstance.playNextSong()
        setupDataOnce()
    }

    /// 上一首按钮点击
    @IBAction func previousSong() {
//        addDisapperAnimation()
        QQMusicOperationTool.shareInstance.playPreviousSong()
        setupDataOnce()
    }

    @IBAction func playOrPause(_ btn: UIButton) {
        
        btn.isSelected = !btn.isSelected
        
        if btn.isSelected {
            
            QQMusicOperationTool.shareInstance.playCurrentMusic()
            foreImageView.layer.resumeAnimate()
            
        }else{
            
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
            foreImageView.layer.pauseAnimate()
        }
    }
    
    // 进度条逻辑处理
    /// 进度条按下
    @IBAction func sliderTouchDown(_ sender: UISlider) {
        removeTimer()
    }
    
    // 添加定时器啊
    // 并且, 控制当前的播放进度
    @IBAction func sliderTouchUp(_ sender: UISlider) {
        addTimer()
        let totalTime = QQMusicOperationTool.shareInstance.getNewMessageModel().totalTime
        let currentTime = totalTime * Double(sender.value)
        
        QQMusicOperationTool.shareInstance.tool.jumpTo(timeInterval: currentTime)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        // 1. 计算当前时间(0-1)
        // 总时长
        let totalTime           = QQMusicOperationTool.shareInstance.getNewMessageModel().totalTime
        let currentTime         = totalTime * Double(sender.value)
        costTimeLabel.text      = TimeTool.getFormatTime(time: currentTime)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    

}

// MARK: - UI
extension MusicDetailViewController{
    
    func setupViewOnce() {
        setUpSlider()
        setupLrcView()
        
    }
    
    func setupFrame() {
        
        toolBarTopCons.constant     = kStatusHeight > 20 ? -44 : -20
        foreImageTopCons.constant   = kScreenWidth < 375 ? 20: 60
        imageW.constant             = kScreenWidth < 375 ? 250 : 300
        setForeImageView()
        setupLrcViewFrame()
    }
    
    /// 设置进度条
    func setUpSlider() {
        
        slider.setThumbImage(UIImage.init(named: "player_slider_playback_thumb"), for: .normal)
        
        let tap                                     = UITapGestureRecognizer(target: self, action: #selector(touchSlider))
        tap.delegate                                = self as UIGestureRecognizerDelegate
        slider.addGestureRecognizer(tap)
        
    }
    
    func setForeImageView() {
        foreImageView.layer.cornerRadius            = foreImageView.width * 0.5
        foreImageView.layer.masksToBounds           = true
    }
    
    func setupLrcView() {
        
        lrcVC.tableView.backgroundColor             = UIColor.clear
        
        LrcBackView.addSubview(lrcVC.tableView)
        LrcBackView.isPagingEnabled                 = true
        LrcBackView.showsHorizontalScrollIndicator  = false
    }
    
    // 布局  N次(准确说, 是执行多少次都没有关系的), 放到有可能不是一次的方法中执行
    func setupLrcViewFrame() {
        
        lrcVC.tableView.frame   = LrcBackView.bounds
        lrcVC.tableView.x       = LrcBackView.bounds.width
        LrcBackView.contentSize = CGSize(width: LrcBackView.width * 2, height: LrcBackView.height)
    }
    
    @objc func touchSlider() {
        print("点击进度条")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension  MusicDetailViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        // 1.计算比例
        let curP            = touch.location(in: slider)
        let value           = curP.x / slider.size.width
        
        // 2.算出时间
        let totalTime       = QQMusicOperationTool.shareInstance.getNewMessageModel().totalTime
        let currentTime     = totalTime * Double(value)
        
        // 3.设置当前播放进度
        slider.value        = Float(value)
        QQMusicOperationTool.shareInstance.tool.jumpTo(timeInterval: currentTime)
        
        return true
    }
}

// MARK: - 动画
extension MusicDetailViewController : UIScrollViewDelegate{
    
    func addRotationAnimation() {
        
        // 1.移除之前的动画
        foreImageView.layer.removeAnimation(forKey: "rotation")
        let animation                   = CABasicAnimation(keyPath: "transform.rotation.z")
        
        animation.fromValue             = 0
        animation.toValue               = Double.pi * 2
        animation.duration              = 50
        animation.repeatCount           = MAXFLOAT
        animation.isRemovedOnCompletion = false
        
        foreImageView.layer.add(animation, forKey: "rotation")
    }
    
    func addDisapperAnimation() {
        // 1.移除之前的动画
        
        let imageView                   = UIImageView.init(image: foreImageView.image)
        imageView.frame                 = foreImageView.frame
        imageView.layer.cornerRadius    = imageView.width * 0.5
        imageView.layer.masksToBounds   = true
        let musicMsgModel               = QQMusicOperationTool.shareInstance.getNewMessageModel()
        let m                           = Int(musicMsgModel.costTime) / 50
        let angle :Double               = (musicMsgModel.costTime - 50 * Double(m)) / 50 * Double.pi * 2
        foreImageView.superview?.addSubview(imageView)
        
//        imageView.transform             = CGAffineTransform(rotationAngle: CGFloat(angle))
//        imageView.layer.anchorPoint     = CGPoint(x: 0.5, y: 0.5);
//        imageView.layer.transform       = CATransform3DRotate(1, angle, <#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##z: CGFloat##CGFloat#>)
        
        UIView.animate(withDuration: 1, animations: {
            imageView.y                 = -imageView.height;
            imageView.alpha             = 0;
        }) { (finished) in
            if finished {
                imageView.removeFromSuperview()
            }
        }
        
        
       

    }
    
    /// 暂停动画
    func pasueRotationAnimation() {
        foreImageView.layer.pauseAnimate()
    }
    
    /// 继续动画
    func resumeRotationAnimation() {
        foreImageView.layer.resumeAnimate()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let alpha           = 1 - scrollView.contentOffset.x / scrollView.width
        foreImageView.alpha = alpha
        lrcLabel.alpha      = alpha
       
    }
}

// MARK: - Data
extension MusicDetailViewController{
    
    /// 当歌曲切换的时候,更新一次
    func setupDataOnce(){
        
        let musicMsgModel           = QQMusicOperationTool.shareInstance.getNewMessageModel();
        
        
        let image                   = UIImage.init(named: (musicMsgModel.musicM?.icon)!)
        self.foreImageView.image    = image
        self.backImageView.image    = image
        totalTimerLabel.text        = musicMsgModel.totalTimeFormat
        songNameLabel.text          = musicMsgModel.musicM?.name
        singerNameLabel.text        = musicMsgModel.musicM?.singer

        let lrcModelArray           = QQLrcDataTool.getLrcData(fileName: (musicMsgModel.musicM?.lrcname)!)
        lrcVC.dataSource            = lrcModelArray
        
        
        
        addRotationAnimation()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            self.addRotationAnimation()
//
//        }
        
        if musicMsgModel.isPlaying {
            resumeRotationAnimation()
        }else{
            pasueRotationAnimation()
        }
        
    }

    
    /// 更新多次
    @objc func setupDataTimes() {
        
        let musicMsgModel           = QQMusicOperationTool.shareInstance.getNewMessageModel()
        
        costTimeLabel.text          = musicMsgModel.costTimeFormat
        slider.value                = Float( musicMsgModel.costTime / musicMsgModel.totalTime )
        playOrPauseBtn.isSelected   = musicMsgModel.isPlaying
    }
    
    /// 更新歌词
    @objc func updateLrc() {
        
        let musicMsgModel           = QQMusicOperationTool.shareInstance.getNewMessageModel()
        
        // 1.获取滚动号
        let rowLrcM                 = QQLrcDataTool.getRowLrcM(currentTime: musicMsgModel.costTime, lrcMs: lrcVC.dataSource)
        
        // 2.交给歌词展示控制器, 来滚动
        lrcVC.scroll                = rowLrcM.row
        
        // 3.给歌词标签赋值
        let lrcM                    = rowLrcM.lrcM
        lrcLabel.text               = lrcM.lrcStr
        
        // 4.给歌词标签进度赋值
        let value                   = (musicMsgModel.costTime - lrcM.beginTime) / (lrcM.endTime - lrcM.beginTime)
        lrcLabel.progress           = value
        
        // 5.给歌词列表标签赋值
        lrcVC.progress              = value
        
        // 6.设置锁屏信息
        // 前台不更新, 后台更新
        let state = UIApplication.shared.applicationState
        // Active    前台
        // Inactive
        // Background 后台
        
        if state == .background {
            QQMusicOperationTool.shareInstance.setupLockScreenMsg()
        }
    }
    
    
    /// 添加定时器
    func addTimer() {
        timer                       = Timer(timeInterval: 1, target: self, selector: #selector(setupDataTimes), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    /// 移除定时器
    func removeTimer() {
        timer?.invalidate()
        timer                       = nil
    }
    
    /// 添加DisplayLink定时器（频繁调用）
    func addDisplayLink() {
        displayLink                 = CADisplayLink(target: self, selector: #selector(updateLrc))
        displayLink?.add(to: RunLoop.current, forMode: .common)
    }
    
    /// 移除DidsplayLink
    func removeDisplayLink() {
        displayLink?.invalidate()
        displayLink                 = nil
    }
}

