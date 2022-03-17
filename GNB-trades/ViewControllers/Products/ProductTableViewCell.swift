//
//  ProductTableViewCell.swift
//  GNB-trades
//
//  Created by Christian Polo on 12/3/22.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var product: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
