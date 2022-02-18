//
//  MessageTableViewCell.swift
//  FoodHub
//
//  Created by OPSolutions on 2/15/22.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    var trailingConstraint: NSLayoutConstraint!
    var leadingConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        leadingConstraint.isActive = false
        trailingConstraint.isActive = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateMessageCell(by message: MessageData){
        messageBackgroundView.layer.cornerRadius = 16
        messageBackgroundView.clipsToBounds = true
        trailingConstraint = messageBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        leadingConstraint = messageBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        messageLabel.text = message.text
        
        if message.isFirstUser{
            messageBackgroundView.backgroundColor = UIColor(red: 120/255.0, green: 181/255.0, blue: 71/255.0, alpha: 1.0)
            
            trailingConstraint.isActive = true
            messageLabel.textAlignment = .right
        }else{ // Receiver
            messageBackgroundView.backgroundColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1.0)
            messageLabel.textColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            leadingConstraint.isActive = true
            messageLabel.textAlignment = .left
        }
    }

}
