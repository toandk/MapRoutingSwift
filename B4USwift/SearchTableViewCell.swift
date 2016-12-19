//
//  SearchTableViewCell.swift
//  B4USwift
//
//  Created by admin on 12/7/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import GooglePlaces

class SearchTableViewCell: UITableViewCell, ReactiveView {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var addressLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func nib() -> UINib {
        return UINib(nibName: NSStringFromClass(SearchTableViewCell.self), bundle: nil)
    }
    
    func bindViewModel(viewModel: AnyObject) {
        let model = viewModel as! GMSAutocompletePrediction
        nameLabel?.attributedText = model.attributedPrimaryText
        addressLabel?.attributedText = model.attributedSecondaryText
    }
    
}
