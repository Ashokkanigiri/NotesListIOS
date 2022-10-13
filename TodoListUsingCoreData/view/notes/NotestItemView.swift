//
//  NotestItemView.swift
//  TodoListUsingCoreData
//
//  Created by Ashok Kanigiri on 11/10/22.
//

import UIKit

class NotestItemView: UITableViewCell {

    @IBOutlet weak var notesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
