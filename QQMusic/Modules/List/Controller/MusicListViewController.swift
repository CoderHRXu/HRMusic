//
//  MusicListViewController.swift
//  QQMusic
//
//  Created by haoran on 2018/11/1.
//  Copyright © 2018年 haoran. All rights reserved.
//

import UIKit

class MusicListViewController: UITableViewController {

    var musicList:[QQMusicModel] = [QQMusicModel](){
        
        didSet{
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        QQMusicDataTool.getMusicList { (dataArray) in
            self.musicList = dataArray
            QQMusicOperationTool.shareInstance.musicMList = dataArray
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

    // MARK: - UI
    func setupUI() {
        setupTableView()
        
    }
    
    private func setupTableView() -> () {
        
        // 设置背景图
        let backView                = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        tableView.backgroundView    = backView
        // 设置cell高度
        tableView.rowHeight         = 60;
        // 设置分割线样式
        tableView.separatorStyle    = .none
        tableView.contentInset      = UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    private func hideNavigationBar() -> () {
        navigationController?.isNavigationBarHidden = true
    }
    
  
}


extension MusicListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = QQMusicListCell.cellWithTableView(tableView: tableView)
        let music = self.musicList[indexPath.row]
        cell.musicM = music
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! QQMusicListCell
        
        cell.beginAnimation(type: .Translation)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let musicM = self.musicList[indexPath.row]
        QQMusicOperationTool.shareInstance.playMusic(music: musicM)
        self.performSegue(withIdentifier: "ToDetail", sender: nil)
        
    }
}
