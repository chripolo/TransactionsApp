//
//  TransactionViewCell.swift
//  GNB-trades
//
//  Created by Christian Polo on 12/3/22.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sale: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
