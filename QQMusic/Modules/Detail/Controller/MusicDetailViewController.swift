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
    @IBOutlet weak var lrcLabel: UILabel!
    
    var timer : Timer?
    
    var displayLink :CADisplayLink?
    
    lazy var lrcVC: LrcViewController = {
        let vc = LrcViewController()
        return vc
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupDataOnce()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupFrame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: - Action
    /// 返回列表界面
    @IBAction func close(sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }

    /// 下一首按钮点击
    @IBAction func nextSong() {
        addDisapperAnimation()
        QQMusicOperationTool.shareInstance.playNextSong()
        setupDataOnce()
    }

    /// 上一首按钮点击
    @IBAction func previousSong() {
        addDisapperAnimation()
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
    
    
    @IBAction func sliderTouchDown(_ sender: UISlider) {
        
    }
    
    @IBAction func sliderTouchUp(_ sender: UISlider) {
        
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    

}

// MARK: - UI
extension MusicDetailViewController{
    
    func setupOnce() {
        setUpSlider()
//        setupLrcView()
        
    }
    
    func setupFrame() {
        
        toolBarTopCons.constant     = kStatusHeight > 20 ? -44 : -20
        foreImageTopCons.constant   = kScreenWidth < 375 ? 20: 60
        imageW.constant             = kScreenWidth < 375 ? 250 : 300
        setForeImageView()
    }
    
    /// 设置进度条
    func setUpSlider() {
        
        slider.setThumbImage(UIImage.init(named: "player_slider_playback_thumb"), for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchSlider))
        tap.delegate = self as UIGestureRecognizerDelegate
        slider.addGestureRecognizer(tap)
        
    }
    
    func setForeImageView() {
        foreImageView.layer.cornerRadius = foreImageView.width * 0.5
        foreImageView.layer.masksToBounds = true
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
        
        let alpha           = 1 - scrollView.contentOffset.x - scrollView.width
        foreImageView.alpha = alpha
        lrcLabel.alpha      = alpha
    }
}

// MARK: - Data
extension MusicDetailViewController{
    
    /// 当歌曲切换的时候,更新一次
    func setupDataOnce(){
        
        let musicMsgModel = QQMusicOperationTool.shareInstance.getNewMessageModel();
        
        
        let image               = UIImage.init(named: (musicMsgModel.musicM?.icon)!)
        self.foreImageView.image     = image
        self.backImageView.image     = image
        totalTimerLabel.text    = musicMsgModel.totalTimeFormat
        songNameLabel.text      = musicMsgModel.musicM?.name
        singerNameLabel.text    = musicMsgModel.musicM?.singer

//        let lrcModel = qqlrcd
        
        
        
        
        
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

}
