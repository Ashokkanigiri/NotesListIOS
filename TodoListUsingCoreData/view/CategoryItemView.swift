//
//  CategoryItemView.swift
//  TodoListUsingCoreData
//
//  Created by Ashok Kanigiri on 11/10/22.
//

import UIKit

class CategoryItemView: UITableViewCell {
    
    var categoryItemProtocol : CategoryItemProtocol? = nil
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBAction func onCategoryDeleteClicked(_ sender: UIButton) {
        categoryItemProtocol?.onDeleteButtonClicked(category: categoryLabel?.text ?? "")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
