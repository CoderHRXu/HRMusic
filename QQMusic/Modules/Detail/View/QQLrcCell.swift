//
//  QQLrcCell.swift
//  QQMusic
//
//  Created by haoran on 2018/11/13.
//  Copyright © 2018年 haoran. All rights reserved.
//

import UIKit

class QQLrcCell: UITableViewCell {

    
    @IBOutlet weak var lrcContentLabel: QQLrcLabel!
    
    var progress :Double = 0.0{
        didSet{
            lrcContentLabel.progress = progress
        }
    }
    
    var lrcStr = ""{
        didSet{
            lrcContentLabel.text = lrcStr
        }
    }
        
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func cellWithTableView(tableView : UITableView) -> QQLrcCell {
        
        let cellID = "lrcCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? QQLrcCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("QQLrcCell", owner: nil, options: nil)?.first as? QQLrcCell
        }
        return cell!
    }
    
}
