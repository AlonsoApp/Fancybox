//
//  ProductTableViewCell.swift
//  For
//
//  Created by Iñigo Alonso on 21/11/15.
//  Copyright © 2015 Iñigo Alonso. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    // MARK: Properties 
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressPercentageLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
