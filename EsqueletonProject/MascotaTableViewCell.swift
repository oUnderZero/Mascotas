//
//  MascotaTableViewCell.swift
//  EsqueletonProject
//
//  Created by Mac18 on 11/12/21.
//

import UIKit

class MascotaTableViewCell: UITableViewCell {

    @IBOutlet weak var MascotaImage: UIImageView!
    @IBOutlet weak var NombreText: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var RazaText: UILabel!
    @IBOutlet weak var EdadText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.masksToBounds = false
        backView.layer.cornerRadius = 15
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowOffset = .zero
        backView.layer.shadowRadius = 2
        MascotaImage.clipsToBounds = true    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
