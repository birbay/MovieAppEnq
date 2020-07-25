//
//  TypeCollectionViewCell.swift
//  MovieAppEnq
//
//  Created by Birbay on 25.07.2020.
//  Copyright © 2020 Birbay. All rights reserved.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    func setStyle(){
        backView.layer.cornerRadius = backView.frame.height / 2
        backView.layer.borderWidth = 0.5
        backView.layer.borderColor = UIColor.gray.cgColor
    }

}
