//
//  AvisCustomCell.swift
//  Jeu de Piste
//
//  Created by ORTEGA Pierre on 15/02/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit

class AvisCustomCell: UITableViewCell {

  @IBOutlet weak var LabelNom: UILabel!
  @IBOutlet weak var LabelDate: UILabel!
  @IBOutlet weak var LabelCom: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
