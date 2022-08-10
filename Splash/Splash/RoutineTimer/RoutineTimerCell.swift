//
//  RoutineTimerCell.swift
//  Splash
//
//  Created by Shreya Vinjamuri on 8/6/22.
//

import UIKit

class RoutineTimerCell: UICollectionViewCell {
    
    @IBOutlet var circleTimer: RoutineTimerXIBView!
    @IBOutlet var title: UILabel!
    func setCell(titleLabel: String) {
        self.title.text = titleLabel
    }
}
