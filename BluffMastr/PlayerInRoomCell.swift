//
//  PlayerInRoomCell.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/3/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class PlayerInRoomCell: UITableViewCell {

    @IBOutlet weak var playerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(name: String!){
        playerName.text = name
    }

}
