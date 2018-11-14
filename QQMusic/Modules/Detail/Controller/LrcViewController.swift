//
//  LrcViewController.swift
//  QQMusic
//
//  Created by haoran on 2018/11/13.
//  Copyright © 2018年 haoran. All rights reserved.
//

import UIKit

class LrcViewController: UITableViewController {

    var scroll: Int = 0{
        
        didSet{
            
            // 防止重复启动
            if scroll != oldValue {
                print(scroll)
                let indexPath = IndexPath(row: scroll, section: 0)
                // 先刷新 在做动画
                tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .fade)
                
                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
    }
    
    var dataSource: [QQLrcModel] = [QQLrcModel](){
        didSet{
            tableView.reloadData()
        }
    }
    
    
    var progress : Double = 0.0{
        
        didSet{
            
            let indexPath = IndexPath(row: scroll, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? QQLrcCell
            
            cell?.progress = progress
            
        }
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: tableView.height * 0.5, left: 0, bottom: tableView.height * 0.5, right: 0)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = QQLrcCell.cellWithTableView(tableView: tableView) as QQLrcCell
        if indexPath.row == scroll {
            cell.progress = progress
        } else {
            cell.progress = 0
        }

        cell.lrcStr = dataSource[indexPath.row].lrcStr
        return cell
    }
 
    
}
