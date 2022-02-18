//
//  NamesTVC.swift
//  FoodHub
//
//  Created by OPSolutions on 2/14/22.
//

import UIKit

class NamesTVC: UITableViewCell {

    @IBOutlet weak var nameImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
