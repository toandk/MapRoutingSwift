//
//  SearchHistoryCell.swift
//  B4USwift
//
//  Created by admin on 12/7/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class SearchHistoryCell: UITableViewCell, ReactiveView {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func nib() -> UINib {
        return UINib(nibName: NSStringFromClass(SearchHistoryCell.self), bundle: nil)
    }

    func bindViewModel(viewModel: AnyObject) {
        let model = viewModel as! SearchRecentModel
        nameLabel?.text = model.name
        addressLabel?.text = model.address
    }
}
