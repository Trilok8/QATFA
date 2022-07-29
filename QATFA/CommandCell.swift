//
//  CommandCell.swift
//  reemeast
//
//  Created by trilok on 05/02/22.
//

import UIKit

class CommandCell: UITableViewCell {

    @IBOutlet weak var lblCommandName: UILabel!
    @IBOutlet weak var lblCommand: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
