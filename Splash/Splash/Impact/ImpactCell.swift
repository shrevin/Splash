//
//  ImpactCell.swift
//  Splash
//
//  Created by Shreya Vinjamuri on 8/5/22.
//

import UIKit

class ImpactCell: UICollectionViewCell {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    func setCell(img: UIImage, top: NSString, bottom: NSString, title: NSString)-> Void {
        self.image.image = img
        self.topLabel.text = top as String
        self.bottomLabel.text = bottom as String
        self.titleLabel.text = title as String
    }

}
