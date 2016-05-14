//
//  PlayerInRoomCell.swift
//  BluffMastr
//
//  Created by Srikant Viswanath on 5/3/16.
//  Copyright © 2016 Srikant Viswanath. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var MainLbl: UILabel!
    @IBOutlet weak var LeadingLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(mainLbl: String!, leadingLbl:String = ""){
        MainLbl.text = mainLbl
        if LeadingLbl != nil {
            LeadingLbl.text = leadingLbl
        }
    }

}
