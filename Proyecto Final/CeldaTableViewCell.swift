//
//  CeldaTableViewCell.swift
//  Proyecto Final
//
//  Created by Administrador on 01/01/17.
//  Copyright © 2017 ITESO. All rights reserved.
//

import UIKit

class CeldaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var descripcion: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
